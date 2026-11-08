import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:intl/intl.dart';

import '../../../core/utils/format.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../inventory/data/stock_deductor.dart';
import '../../loyalty/application/loyalty_rules.dart';
import '../../menu/application/menu_rules.dart';
import '../application/order_rules.dart';

const openStatuses = ['awaiting', 'pending', 'preparing', 'ready', 'served'];

/// orders and tables writes; every multi-document change is one transaction
/// that reads everything first (NFR-REL-01).
class OrderRepository {
  OrderRepository(this._db, this._stock);
  final FirebaseFirestore _db;
  final StockDeductor _stock;

  CollectionReference<Map<String, dynamic>> get _orders => _db.collection('orders');
  DocumentReference<Map<String, dynamic>> _table(String id) => _db.doc('tables/$id');

  Order _fromDoc(DocumentSnapshot<Map<String, dynamic>> d) => Order.fromJson(withId(d));
  List<Order> _list(QuerySnapshot<Map<String, dynamic>> s) => s.docs.map(_fromDoc).toList();

  Future<Order> _read(Transaction txn, String id) async => _fromDoc(await txn.get(_orders.doc(id)));

  Map<String, Object?> _audit(String uid) => {'updatedAt': FieldValue.serverTimestamp(), 'updatedBy': uid};

  Map<String, Object?> _money(Order o) => {
        'items': o.items.map((i) => i.toJson()).toList(),
        'subtotal': o.subtotal,
        'total': o.total,
      };

  Stream<List<Order>> watchOpenOrders() =>
      _orders.where('status', whereIn: openStatuses).snapshots().map(_list);

  Stream<Order> watchOrder(String id) => _orders.doc(id).snapshots().map(_fromDoc);

  Stream<List<Order>> watchQueue() => _orders
      .where('status', whereIn: ['pending', 'preparing'])
      .orderBy('createdAt')
      .snapshots()
      .map(_list);

  /// Reserves the next daily code; call only after every other read of the
  /// transaction, because it also performs the counter write.
  Future<String> _nextShortId(Transaction txn) async {
    final ref = _db.doc('counters/${DateFormat('yyyyMMdd').format(DateTime.now())}');
    final doc = await txn.get(ref);
    final next = ((doc.data()?['next'] as num?) ?? 1).toInt();
    txn.set(ref, {'next': next + 1});
    return shortIdFrom(next);
  }

  Future<String> create(Order o, String uid) => _db.runTransaction((txn) async {
        if (o.tableId != null) {
          final table = await txn.get(_table(o.tableId!));
          if (table.data()?['currentOrderId'] != null) throw const RuleException('MSG19');
        }
        final shortId = await _nextShortId(txn);
        final ref = _orders.doc();
        txn.set(ref, {
          ...toDoc(o.copyWith(shortId: shortId, createdBy: uid).toJson()),
          'createdAt': FieldValue.serverTimestamp(),
          ..._audit(uid),
        });
        if (o.tableId != null) txn.update(_table(o.tableId!), {'currentOrderId': ref.id});
        return ref.id;
      });

  Future<void> appendItems(String id, List<OrderItem> added, int vndPerPoint, String uid) =>
      _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        if (o.status == OrderStatus.paid || o.status == OrderStatus.cancelled) {
          throw const RuleException('MSG20');
        }
        final next = reprice(addItems(o, added), vndPerPoint);
        txn.update(_orders.doc(id), {..._money(next), 'status': next.status.name, ..._audit(uid)});
      });

  /// Existing lines can change only while awaiting or pending (BR-ORD-04, MSG20).
  Future<void> updateItems(String id, List<OrderItem> items, int vndPerPoint, String uid) =>
      _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        if (o.status != OrderStatus.pending && o.status != OrderStatus.awaiting) {
          throw const RuleException('MSG20');
        }
        txn.update(_orders.doc(id), {..._money(reprice(o.copyWith(items: items), vndPerPoint)), ..._audit(uid)});
      });

  /// SD-03: re-validates prices, then either the QR order becomes the table's
  /// order, or its items join the open order and the QR order closes (BR-ORD-07).
  /// Returns the shortId of the merge target, or null when no merge happened.
  Future<String?> confirm(String id, int vndPerPoint, String uid) => _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        if (o.status != OrderStatus.awaiting) throw const RuleException('MSG20');
        final tableDoc = o.tableId == null ? null : await txn.get(_table(o.tableId!));
        if (tableDoc != null && !tableDoc.exists) throw const RuleException('MSG37');
        final openId = tableDoc?.data()?['currentOrderId'] as String?;
        final open = openId == null ? null : await _read(txn, openId);

        final items = <OrderItem>[];
        for (final item in o.items) {
          final doc = await txn.get(_db.doc('products/${item.productId}'));
          if (!doc.exists) throw RuleException('${item.name}: món không còn trong thực đơn');
          final product = Product.fromJson(withId(doc));
          if (!product.isAvailable) throw RuleException('${item.name}: hết hàng');
          items.add(item.copyWith(unitPrice: currentUnitPrice(product, item)));
        }
        final audit = {
          'confirmedBy': uid,
          'confirmedAt': FieldValue.serverTimestamp(),
          ..._audit(uid),
        };

        if (open != null) {
          final merged = reprice(addItems(open, items), vndPerPoint);
          final reason = 'Gộp vào ${open.shortId}';
          txn.update(_orders.doc(openId), {
            ..._money(merged),
            'status': merged.status.name,
            'followerUids': FieldValue.arrayUnion([o.createdBy]),
            ..._audit(uid),
          });
          txn.update(_orders.doc(id), {
            'status': OrderStatus.cancelled.name,
            'cancelReason': reason,
            'cancelledBy': uid,
            'mergedIntoId': openId,
            ...audit,
          });
          return open.shortId;
        }

        final shortId = await _nextShortId(txn);
        final next = reprice(o.copyWith(items: items), vndPerPoint);
        txn.update(_orders.doc(id), {
          ..._money(next),
          'status': OrderStatus.pending.name,
          'shortId': shortId,
          ...audit,
        });
        if (o.tableId != null) txn.update(_table(o.tableId!), {'currentOrderId': id});
        return null;
      });

  /// Barista and "Đã phục vụ" status changes.
  Future<void> setStatus(String id, OrderStatus status, String uid) =>
      _orders.doc(id).update({'status': status.name, ..._audit(uid)});

  Future<void> markServed(String id, String uid) => _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        if (o.status != OrderStatus.ready) throw const RuleException('Đơn chưa sẵn sàng');
        txn.update(_orders.doc(id), {'status': OrderStatus.served.name, ..._audit(uid)});
      });

  /// BR-ORD-05, BR-INV-02. Frees the table; made drinks are deducted as waste.
  Future<void> cancel(String id, String reason, bool made, UserRole role, String uid) =>
      _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        if (!canCancel(o.status, role)) throw const RuleException('MSG33');
        final read = made ? await _stock.readForOrder(txn, o) : null;
        final tableDoc = o.tableId == null ? null : await txn.get(_table(o.tableId!));
        txn.update(_orders.doc(id), {
          'status': OrderStatus.cancelled.name,
          'cancelReason': reason,
          'cancelledBy': uid,
          ..._audit(uid),
        });
        if (tableDoc?.data()?['currentOrderId'] == id) {
          txn.update(_table(o.tableId!), {'currentOrderId': null});
        }
        if (read != null) _stock.deduct(txn, o, read, MovementType.adjust, uid, reason: reason);
      });

  /// UC26: only to an empty table (MSG30).
  Future<void> moveTable(String id, String targetTableId, String uid) => _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        final target = await txn.get(_table(targetTableId));
        if (target.data()?['currentOrderId'] != null) throw const RuleException('MSG30');
        txn.update(_orders.doc(id), {'tableId': targetTableId, ..._audit(uid)});
        txn.update(_table(targetTableId), {'currentOrderId': id});
        if (o.tableId != null) txn.update(_table(o.tableId!), {'currentOrderId': null});
      });

  /// BR-ORD-08: the target keeps its id; the source closes without stock deduction.
  Future<void> merge(String sourceId, String targetId, int vndPerPoint, String uid) =>
      _db.runTransaction((txn) async {
        final source = await _read(txn, sourceId);
        final target = await _read(txn, targetId);
        if (!canMerge(source, target)) throw const RuleException('MSG31');
        final next = reprice(target.copyWith(items: [...target.items, ...source.items]), vndPerPoint);
        txn.update(_orders.doc(targetId), {
          ..._money(next),
          'followerUids': FieldValue.arrayUnion([...source.followerUids, source.createdBy]),
          ..._audit(uid),
        });
        txn.update(_orders.doc(sourceId), {
          'status': OrderStatus.cancelled.name,
          'cancelReason': 'Gộp vào ${target.shortId}',
          'cancelledBy': uid,
          'mergedIntoId': targetId,
          ..._audit(uid),
        });
        if (source.tableId != null) txn.update(_table(source.tableId!), {'currentOrderId': null});
      });

  /// Saves the voucher and recomputes the total on the open order (UC24).
  Future<void> updateVoucher(String id, String? code, int discount, int vndPerPoint, String uid) =>
      _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        final next = reprice(o.copyWith(voucherCode: code, discount: discount), vndPerPoint);
        txn.update(_orders.doc(id), {'voucherCode': code, 'discount': discount, 'total': next.total, ..._audit(uid)});
      });

  /// Saves the customer and points on the open order (UC38, UC39). The balance
  /// itself changes only in the payment transaction.
  Future<void> updateLoyalty(String id, String? customerId, int points, int vndPerPoint, String uid) =>
      _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        final next = reprice(o.copyWith(pointsRedeemed: points), vndPerPoint);
        txn.update(_orders.doc(id), {
          'customerId': customerId,
          'pointsRedeemed': points,
          'total': next.total,
          ..._audit(uid),
        });
      });

  /// SD-04: order, stock, points, voucher, shift totals and table in one commit.
  Future<void> pay(String id, PaymentInput input, ShopSettings settings, String uid) =>
      _db.runTransaction((txn) async {
        final o = await _read(txn, id);
        if (o.status != OrderStatus.served) throw const RuleException('Đơn chưa được phục vụ');

        final lock = await txn.get(_db.doc('shiftLocks/$uid'));
        if (!lock.exists) throw const RuleException('MSG28');
        final shiftId = lock.data()!['shiftId'] as String;
        final shiftRef = _db.doc('shifts/$shiftId');
        final shift = Shift.fromJson(withId(await txn.get(shiftRef)));
        if (shift.checkOut != null) throw const RuleException('MSG28');

        final voucherRef = o.voucherCode == null ? null : _db.doc('vouchers/${o.voucherCode}');
        Voucher? voucher;
        if (voucherRef != null) {
          final doc = await txn.get(voucherRef);
          voucher = doc.exists ? Voucher.fromJson({...doc.data()!, 'code': doc.id}) : null;
          final error = voucherError(voucher, o.subtotal, DateTime.now());
          if (error != null) throw RuleException(error, {'minOrder': formatVnd(voucher?.minOrder ?? 0)});
        }

        final customerRef = o.customerId == null ? null : _db.doc('customers/${o.customerId}');
        final customer = customerRef == null ? null : Customer.fromJson(withId(await txn.get(customerRef)));
        if (customer != null && o.pointsRedeemed > customer.points) {
          throw RuleException('MSG40', {'max': customer.points});
        }

        final read = await _stock.readForOrder(txn, o);

        final discount = voucher == null ? 0 : voucherDiscount(voucher, o.subtotal);
        final total = totalOf(o.subtotal, discount, o.pointsRedeemed, settings.vndPerPoint);
        validatePayment(total, input.cash, input.qr);

        txn.update(_orders.doc(id), {
          'status': OrderStatus.paid.name,
          'discount': discount,
          'total': total,
          'cashAmount': input.cash,
          'qrAmount': input.qr,
          'paidBy': uid,
          'shiftId': shiftId,
          'paidAt': FieldValue.serverTimestamp(),
          ..._audit(uid),
        });
        _stock.deduct(txn, o, read, MovementType.sale, uid);
        txn.update(shiftRef, {
          'cashSales': shift.cashSales + input.cash,
          'qrSales': shift.qrSales + input.qr,
          'lastPaidOrderId': id,
        });
        if (voucherRef != null) {
          txn.update(voucherRef, {'usedCount': voucher!.usedCount + 1, 'lastOrderId': id});
        }
        if (customerRef != null) {
          txn.update(customerRef, {
            'points': customer!.points - o.pointsRedeemed + pointsEarned(total, settings.pointsPerVnd),
            'visitCount': customer.visitCount + 1,
            'lastOrderId': id,
          });
        }
        if (o.tableId != null) txn.update(_table(o.tableId!), {'currentOrderId': null});
      });

  Future<List<Order>> paidOrders(String paidBy, DateTime from) async => _list(await _orders
      .where('paidBy', isEqualTo: paidBy)
      .where('paidAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
      .get());
}
