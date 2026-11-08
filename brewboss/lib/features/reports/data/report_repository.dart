import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../../../models/models.dart';

class ReportRepository {
  ReportRepository(this._db);
  final FirebaseFirestore _db;

  Query<Map<String, dynamic>> _paid(DateTime from, DateTime to) => _db
      .collection('orders')
      .where('status', isEqualTo: 'paid')
      .where('paidAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
      .where('paidAt', isLessThan: Timestamp.fromDate(to));

  List<Order> _list(QuerySnapshot<Map<String, dynamic>> s) => s.docs.map((d) => Order.fromJson(withId(d))).toList();

  Stream<List<Order>> watchPaidOrders(DateTime from, DateTime to) => _paid(from, to).snapshots().map(_list);

  Future<List<Order>> paidOrders(DateTime from, DateTime to) async => _list(await _paid(from, to).get());

  /// ponytail: loads the whole period for in-memory filters and totals, instead
  /// of the 50-row paging in the SDS. Fine for one shop; add startAfter paging
  /// if a long period becomes slow.
  Future<List<Order>> ordersCreatedIn(DateTime from, DateTime to) async => _list(await _db
      .collection('orders')
      .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
      .where('createdAt', isLessThan: Timestamp.fromDate(to))
      .orderBy('createdAt', descending: true)
      .get());

  Future<List<Order>> paidOrdersOfCustomer(String customerId) async => _list(await _db
      .collection('orders')
      .where('customerId', isEqualTo: customerId)
      .orderBy('paidAt', descending: true)
      .limit(50)
      .get());

  /// Number of staff with an open shift (UC34 shortcut).
  Stream<int> watchOnShiftCount() =>
      _db.collection('shifts').where('checkOut', isNull: true).snapshots().map((s) => s.size);
}
