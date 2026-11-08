import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/models.dart';
import '../application/loyalty_rules.dart';

class LoyaltyRepository {
  LoyaltyRepository(this._db);
  final FirebaseFirestore _db;

  Voucher _voucher(DocumentSnapshot<Map<String, dynamic>> d) => Voucher.fromJson({...d.data()!, 'code': d.id});

  Stream<List<Customer>> watchCustomers() => _db.collection('customers').snapshots().map(
      (s) => s.docs.map((d) => Customer.fromJson(withId(d))).toList());

  Stream<Customer?> watchCustomer(String id) => _db
      .doc('customers/$id')
      .snapshots()
      .map((d) => d.exists ? Customer.fromJson(withId(d)) : null);

  Future<Customer?> findByPhone(String phone) async {
    final doc = await _db.doc('customers/${normalizePhone(phone)}').get();
    return doc.exists ? Customer.fromJson(withId(doc)) : null;
  }

  Future<Customer> create(String phone, {String? name}) async {
    final id = normalizePhone(phone);
    final customer = Customer(id: id, phone: id, name: name?.isEmpty ?? true ? null : name);
    await _db.doc('customers/$id').set(toDoc(customer.toJson()));
    return customer;
  }

  Future<void> updateName(String id, String? name) => _db.doc('customers/$id').update({'name': name});

  Stream<List<Voucher>> watchVouchers() =>
      _db.collection('vouchers').snapshots().map((s) => s.docs.map(_voucher).toList());

  Future<Voucher?> findVoucher(String code) async {
    final doc = await _db.doc('vouchers/$code').get();
    return doc.exists ? _voucher(doc) : null;
  }

  Future<void> saveVoucher(Voucher v) {
    final data = v.toJson()..remove('code');
    return _db.doc('vouchers/${v.code}').set(data);
  }

  Future<void> setVoucherActive(String code, bool active) => _db.doc('vouchers/$code').update({'isActive': active});
}
