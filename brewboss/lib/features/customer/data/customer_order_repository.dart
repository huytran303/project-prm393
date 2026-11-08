import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/models.dart';

/// Writes allowed to an anonymous user by Security Rules (SEC-ANON).
class CustomerOrderRepository {
  CustomerOrderRepository(this._db, this._auth);
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _orders => _db.collection('orders');

  Future<String> signInAnonymously() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;
    return (await _auth.signInAnonymously()).user!.uid;
  }

  /// No shortId: it is allocated when the cashier confirms (UC22).
  Future<String> placeOrder(Order o) async {
    final ref = _orders.doc();
    await ref.set({
      ...toDoc(o.copyWith(source: OrderSource.customer, status: OrderStatus.awaiting).toJson()),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Stream<Order> watchOrder(String orderId) =>
      _orders.doc(orderId).snapshots().map((d) => Order.fromJson(withId(d)));

  /// Last order of this anonymous uid for the table (UC33 alternative 1a).
  Future<String?> lastOrderFor(String tableId, String uid) async {
    final snap = await _orders
        .where('createdBy', isEqualTo: uid)
        .where('tableId', isEqualTo: tableId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    return snap.docs.isEmpty ? null : snap.docs.first.id;
  }

  Stream<String> watchShopName() => _db.doc('settings/public').snapshots().map(
      (d) => d.data()?['name'] as String? ?? 'BrewBoss');
}
