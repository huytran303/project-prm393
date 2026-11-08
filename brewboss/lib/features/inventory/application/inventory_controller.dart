import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../menu/application/menu_providers.dart';
import 'inventory_providers.dart';

final inventoryControllerProvider = AsyncNotifierProvider<InventoryController, void>(InventoryController.new);

class InventoryController extends WriteController {
  String get _uid => ref.read(currentUidProvider)!;

  Future<bool> saveIngredient(Ingredient i) => guard(() async {
        final all = ref.read(ingredientsProvider).valueOrNull ?? const <Ingredient>[];
        if (all.any((o) => o.id != i.id && foldAccents(o.name) == foldAccents(i.name))) {
          throw const RuleException('Tên nguyên liệu đã tồn tại');
        }
        final repo = ref.read(inventoryRepositoryProvider);
        i.id.isEmpty ? await repo.createIngredient(i, _uid) : await repo.updateIngredient(i);
      });

  /// Refused while a recipe uses the ingredient (MSG13).
  Future<bool> deleteIngredient(String id) => guard(() async {
        final products = ref.read(productsProvider).valueOrNull ?? const <Product>[];
        final using = products
            .where((p) => p.recipe.values.any((items) => items.any((r) => r.ingredientId == id)))
            .map((p) => p.name)
            .toList();
        if (using.isNotEmpty) throw RuleException('MSG13', {'products': using.join(', ')});
        await ref.read(inventoryRepositoryProvider).deleteIngredient(id);
      });

  Future<bool> stockIn(String ingredientId, num qty, int? cost, String note) => guard(() {
        if (qty <= 0) throw const RuleException('MSG42');
        return ref.read(inventoryRepositoryProvider).runStockChange(ingredientId, qty, MovementType.stockIn, _uid,
            cost: cost, reason: note.isEmpty ? null : note);
      });

  Future<bool> adjust(String ingredientId, num qty, String reason) => guard(() {
        if (reason.trim().isEmpty) throw const RuleException('MSG14');
        if (qty == 0) throw const RuleException('MSG15');
        return ref.read(inventoryRepositoryProvider).runStockChange(ingredientId, qty, MovementType.adjust, _uid, reason: reason.trim());
      });

  /// Number of ingredients adjusted by the last stocktake (MSG41).
  int lastAdjusted = 0;

  Future<bool> stocktake(Map<String, num> counted) => guard(() async {
        lastAdjusted = 0;
        for (final e in counted.entries) {
          if (await ref.read(inventoryRepositoryProvider).stocktakeIngredient(e.key, e.value, _uid)) lastAdjusted++;
        }
      });
}
