import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../../inventory/application/inventory_providers.dart';
import '../data/order_repository.dart';
import '../data/table_repository.dart';

final orderRepositoryProvider =
    Provider((ref) => OrderRepository(ref.watchDb(), ref.watch(stockDeductorProvider)));
final tableRepositoryProvider = Provider((ref) => TableRepository(ref.watchDb()));

final openOrdersProvider = StreamProvider<List<Order>>((ref) => ref.watch(orderRepositoryProvider).watchOpenOrders());
final orderProvider = StreamProvider.family<Order, String>((ref, id) => ref.watch(orderRepositoryProvider).watchOrder(id));
final tablesProvider = StreamProvider<List<CafeTable>>((ref) => ref.watch(tableRepositoryProvider).watchTables());

/// tableId → table name, with "Mang đi" for orders without a table.
final tableNamesProvider = Provider<Map<String, String>>((ref) {
  final tables = ref.watch(tablesProvider).valueOrNull ?? const <CafeTable>[];
  return {for (final t in tables) t.id: t.name};
});

extension TableLabel on Map<String, String> {
  String labelFor(Order o) => o.tableId == null ? 'Mang đi' : (this[o.tableId] ?? 'Bàn');
}
