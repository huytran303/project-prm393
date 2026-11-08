import '../../../core/utils/format.dart';
import '../../../models/models.dart';

/// basePrice + size delta + Σ topping price (BR-ORD-01).
int unitPrice(Product p, String size, List<ItemTopping> toppings) {
  final delta = p.sizes.where((s) => s.code == size).fold(0, (sum, s) => sum + s.priceDelta);
  return p.basePrice + delta + toppings.fold(0, (sum, t) => sum + t.price);
}

/// Current menu price of a saved line, re-reading topping prices by name (UC22).
/// A size or topping removed from the menu no longer counts.
int currentUnitPrice(Product p, OrderItem item) {
  final toppings = [
    for (final t in item.toppings)
      for (final m in p.toppings.where((m) => m.name == t.name)) ItemTopping(name: m.name, price: m.price),
  ];
  return unitPrice(p, item.size, toppings);
}

bool matches(Product p, String query) => foldAccents(p.name).contains(foldAccents(query.trim()));

/// Immutable filter for menuQueryProvider.
class MenuQuery {
  const MenuQuery({this.categoryId, this.text = '', this.onlyAvailable = false});
  final String? categoryId;
  final String text;
  final bool onlyAvailable;

  @override
  bool operator ==(Object other) =>
      other is MenuQuery && other.categoryId == categoryId && other.text == text && other.onlyAvailable == onlyAvailable;
  @override
  int get hashCode => Object.hash(categoryId, text, onlyAvailable);
}
