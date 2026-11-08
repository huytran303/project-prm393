import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../data/inventory_repository.dart';
import '../data/stock_deductor.dart';
import 'inventory_rules.dart';

final inventoryRepositoryProvider = Provider((ref) => InventoryRepository(ref.watchDb()));
final stockDeductorProvider = Provider((ref) => StockDeductor(ref.watchDb()));

final ingredientsProvider =
    StreamProvider<List<Ingredient>>((ref) => ref.watch(inventoryRepositoryProvider).watchIngredients());

final movementsProvider = StreamProvider.family<List<StockMovement>, String>(
    (ref, id) => ref.watch(inventoryRepositoryProvider).watchMovements(id));

final lowStockProvider = Provider<List<Ingredient>>(
    (ref) => (ref.watch(ingredientsProvider).valueOrNull ?? const <Ingredient>[]).where(isLowStock).toList());
