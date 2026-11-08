import '../../../models/models.dart';
import '../../pos/application/order_rules.dart';

bool isLate(Order o, DateTime now, int lateOrderMinutes) {
  final at = o.createdAt;
  return at != null && now.difference(at).inMinutes > lateOrderMinutes;
}

/// Latest batch highlighted, earlier batches collapsed (BR-ORD-04).
(List<OrderItem> current, List<OrderItem> earlier) visibleItems(Order o) {
  final latest = maxBatch(o.items);
  return (
    o.items.where((i) => i.batch == latest).toList(),
    o.items.where((i) => i.batch < latest).toList(),
  );
}

/// A new order, a new batch, or more items in the current batch (BR-ORD-04).
bool shouldBeep(List<Order> prev, List<Order> next) {
  final before = {for (final o in prev) o.id: o};
  return next.any((o) {
    final old = before[o.id];
    return old == null || o.items.length > old.items.length;
  });
}
