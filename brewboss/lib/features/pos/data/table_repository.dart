import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';

class TableRepository {
  TableRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('tables');

  Stream<List<CafeTable>> watchTables() => _col.orderBy('area').orderBy('name').snapshots().map(
      (s) => s.docs.map((d) => CafeTable.fromJson(withId(d))).toList());

  Future<CafeTable?> getTable(String id) async {
    final doc = await _col.doc(id).get();
    return doc.exists ? CafeTable.fromJson(withId(doc)) : null;
  }

  /// Name, area and capacity only; currentOrderId is written by transactions.
  Future<void> save(CafeTable t) {
    final data = {'name': t.name, 'area': t.area, 'capacity': t.capacity};
    return t.id.isEmpty ? _col.add({...data, 'currentOrderId': null}) : _col.doc(t.id).update(data);
  }

  Future<void> delete(CafeTable t) => _db.runTransaction((txn) async {
        final fresh = await txn.get(_col.doc(t.id));
        if (fresh.data()?['currentOrderId'] != null) throw const RuleException('MSG17');
        txn.delete(_col.doc(t.id));
      });
}
