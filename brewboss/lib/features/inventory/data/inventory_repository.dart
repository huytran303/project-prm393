import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/models.dart';
import '../application/inventory_rules.dart';

class InventoryRepository {
  InventoryRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('ingredients');

  Stream<List<Ingredient>> watchIngredients() => _col.orderBy('name').snapshots().map(
      (s) => s.docs.map((d) => Ingredient.fromJson(withId(d))).toList());

  Stream<List<StockMovement>> watchMovements(String ingredientId) => _col
      .doc(ingredientId)
      .collection('movements')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => StockMovement.fromJson(withId(d))).toList());

  /// New ingredients log positive opening stock as "Tồn đầu kỳ" (UC11).
  Future<void> createIngredient(Ingredient i, String uid) => _db.runTransaction((txn) async {
        final ref = _col.doc();
        txn.set(ref, toDoc(i.toJson()));
        if (i.stock > 0) {
          txn.set(ref.collection('movements').doc(), {
            'type': 'in',
            'qty': i.stock,
            'reason': 'Tồn đầu kỳ',
            'byUserId': uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      });

  /// Name, unit and minimum only; stock changes go through movements.
  Future<void> updateIngredient(Ingredient i) =>
      _col.doc(i.id).update({'name': i.name, 'unit': i.unit, 'minStock': i.minStock});

  Future<void> deleteIngredient(String id) => _col.doc(id).delete();

  Future<void> runStockChange(String ingredientId, num qty, MovementType type, String uid,
          {int? cost, String? reason}) =>
      _db.runTransaction((txn) async {
        final ref = _col.doc(ingredientId);
        final ingredient = Ingredient.fromJson(withId(await txn.get(ref)));
        txn.update(ref, {'stock': ingredient.stock + qty});
        txn.set(ref.collection('movements').doc(), {
          'type': type == MovementType.stockIn ? 'in' : type.name,
          'qty': qty,
          'cost': cost,
          'reason': reason,
          'byUserId': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

  /// Re-reads stock inside the transaction; returns whether anything changed (SD-08).
  Future<bool> stocktakeIngredient(String ingredientId, num counted, String uid) => _db.runTransaction((txn) async {
        final ref = _col.doc(ingredientId);
        final ingredient = Ingredient.fromJson(withId(await txn.get(ref)));
        final diff = stocktakeDiff(counted, ingredient.stock);
        if (diff == 0) return false;
        final movement = ref.collection('movements').doc();
        txn.update(ref, {'stock': counted, 'lastMovementId': movement.id});
        txn.set(movement, {
          'type': 'adjust',
          'qty': diff,
          'reason': 'Kiểm kho',
          'byUserId': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return true;
      });
}
