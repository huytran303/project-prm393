import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';

int subtotalOf(List<OrderItem> items) => items.fold(0, (sum, i) => sum + i.lineTotal);

/// subtotal − discount − points value, minimum 0 (BR-ORD-02).
int totalOf(int subtotal, int discount, int points, int vndPerPoint) {
  final total = subtotal - discount - points * vndPerPoint;
  return total < 0 ? 0 : total;
}

/// Order with subtotal and total recomputed from its items and deductions.
Order reprice(Order o, int vndPerPoint) {
  final sub = subtotalOf(o.items);
  return o.copyWith(subtotal: sub, total: totalOf(sub, o.discount, o.pointsRedeemed, vndPerPoint));
}

/// Transition table of the state machine (SRS 5.1 STATE, figure 2-2).
bool canTransition(OrderStatus from, OrderStatus to, UserRole role) {
  final cashierUp = role != UserRole.barista;
  final bar = role == UserRole.barista || role == UserRole.supervisor || role == UserRole.manager;
  return switch ((from, to)) {
    (OrderStatus.awaiting, OrderStatus.pending) => cashierUp,
    (OrderStatus.pending, OrderStatus.preparing) => bar,
    (OrderStatus.preparing, OrderStatus.ready) => bar,
    (OrderStatus.ready, OrderStatus.preparing) => bar, // "Hoàn tác" (UC30)
    (OrderStatus.ready, OrderStatus.served) => cashierUp,
    (OrderStatus.ready, OrderStatus.pending) => cashierUp,
    (OrderStatus.served, OrderStatus.pending) => cashierUp,
    (OrderStatus.served, OrderStatus.paid) => cashierUp,
    (_, OrderStatus.cancelled) => canCancel(from, role),
    _ => false,
  };
}

int maxBatch(List<OrderItem> items) => items.fold(1, (m, i) => i.batch > m ? i.batch : m);

/// BR-ORD-04: ready / served go back to pending with a new batch; pending and
/// preparing keep their status and current batch.
Order addItems(Order o, List<OrderItem> added) {
  final reopen = o.status == OrderStatus.ready || o.status == OrderStatus.served;
  final batch = maxBatch(o.items) + (reopen ? 1 : 0);
  return o.copyWith(
    items: [...o.items, for (final i in added) i.copyWith(batch: batch)],
    status: reopen ? OrderStatus.pending : o.status,
  );
}

/// awaiting / pending: cashier and up; started orders: supervisor or manager (BR-ORD-05).
bool canCancel(OrderStatus s, UserRole role) => switch (s) {
      OrderStatus.awaiting || OrderStatus.pending => role != UserRole.barista,
      OrderStatus.preparing || OrderStatus.ready || OrderStatus.served =>
        role == UserRole.supervisor || role == UserRole.manager,
      OrderStatus.paid || OrderStatus.cancelled => false,
    };

/// "Đã pha" default: ticked for ready / served, unticked for preparing, hidden
/// before preparation started (BR-INV-02). Null means the box is not offered.
bool? madeDefault(OrderStatus s) => switch (s) {
      OrderStatus.preparing => false,
      OrderStatus.ready || OrderStatus.served => true,
      _ => null,
    };

/// Why an order cannot be merged, or null when it can (BR-ORD-08).
String? mergeBlock(Order o) {
  if (o.status != OrderStatus.served) return '${o.status.label} — chưa gộp được';
  if (o.voucherCode != null) return 'Đã áp voucher — không gộp được';
  if (o.customerId != null || o.pointsRedeemed > 0) return 'Đã gắn khách — không gộp được';
  return null;
}

bool canMerge(Order a, Order b) => mergeBlock(a) == null && mergeBlock(b) == null;

/// cash + qr = total and both ≥ 0 (BR-PAY-01).
void validatePayment(int total, int cash, int qr) {
  if (cash < 0 || qr < 0 || qr > total) throw const RuleException('MSG44');
  if (cash + qr != total) throw const RuleException('MSG27');
}

int changeDue(int received, int cashAmount) => received - cashAmount;

/// SRS 3.1.4 #8. Null when no bank account is configured (MSG29).
String? vietQrUrl(ShopSettings s, int qrAmount, String shortId) {
  if (!s.hasBankAccount) return null;
  final query = Uri(queryParameters: {
    'amount': '$qrAmount',
    'addInfo': transferNote(shortId),
    'accountName': s.bankAccountName,
  }).query;
  return 'https://img.vietqr.io/image/${s.bankBin}-${s.bankAccountNo}-compact2.png?$query';
}

String transferNote(String shortId) => 'BREWBOSS $shortId';

/// One letter and 4 digits; the letter advances every 10.000 orders (BR-ORD-06).
String shortIdFrom(int next) {
  final letter = String.fromCharCode('A'.codeUnitAt(0) + next ~/ 10000);
  return '$letter${(next % 10000).toString().padLeft(4, '0')}';
}
