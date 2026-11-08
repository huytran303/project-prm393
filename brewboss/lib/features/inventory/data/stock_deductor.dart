import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../../../models/models.dart';
import '../application/inventory_rules.dart';

/// What [StockDeductor.readForOrder] read: current ingredients and their usage.
class StockRead {
  const StockRead(this.ingredients, this.usage);
  final Map<String, Ingredient> ingredients;
  final Map<String, num> usage;
}

/// Reads, then deducts, inside a transaction owned by the caller (UC15, UC43):
/// Firestore requires every read before the first write.
class StockDeductor {
  StockDeductor(this._db);
  final FirebaseFirestore _db;

  Future<StockRead> readForOrder(Transaction txn, Order order) async {
    final products = <String, Product>{};
    for (final id in order.items.map((i) => i.productId).toSet()) {
      final doc = await txn.get(_db.doc('products/$id'));
      if (doc.exists) products[id] = Product.fromJson(withId(doc));
    }
    final usage = recipeUsage(order.items, products);
    final ingredients = <String, Ingredient>{};
    for (final id in usage.keys) {
      final doc = await txn.get(_db.doc('ingredients/$id'));
      if (doc.exists) ingredients[id] = Ingredient.fromJson(withId(doc));
    }
    return StockRead(ingredients, usage);
  }

  /// Stock may go negative. One movement per ingredient: sale on payment,
  /// adjust with the cancel reason on waste. lastOrderId lets Security Rules
  /// verify that this write belongs to the order settled in the same commit.
  void deduct(Transaction txn, Order order, StockRead read, MovementType type, String uid, {String? reason}) {
    read.ingredients.forEach((id, ingredient) {
      final qty = read.usage[id]!;
      final ref = _db.doc('ingredients/$id');
      txn.update(ref, {'stock': ingredient.stock - qty, 'lastOrderId': order.id});
      txn.set(ref.collection('movements').doc(), {
        'type': type == MovementType.sale ? 'sale' : 'adjust',
        'qty': -qty,
        'orderId': order.id,
        'reason': reason,
        'byUserId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
