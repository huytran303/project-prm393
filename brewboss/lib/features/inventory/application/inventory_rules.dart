import '../../../models/models.dart';

/// Σ recipe qty × item qty per ingredient; toppings ignored (BR-INV-04).
Map<String, num> recipeUsage(List<OrderItem> items, Map<String, Product> products) {
  final usage = <String, num>{};
  for (final item in items) {
    for (final r in products[item.productId]?.recipe[item.size] ?? const <RecipeItem>[]) {
      usage[r.ingredientId] = (usage[r.ingredientId] ?? 0) + r.qty * item.qty;
    }
  }
  return usage;
}

bool isLowStock(Ingredient i) => i.stock <= i.minStock;

num stocktakeDiff(num counted, num stock) => counted - stock;
