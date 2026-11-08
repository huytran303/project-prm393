import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../data/menu_repository.dart';
import 'menu_rules.dart';

final menuRepositoryProvider =
    Provider((ref) => MenuRepository(ref.watchDb(), ref.watch(storageProvider)));

final categoriesProvider = StreamProvider<List<Category>>((ref) => ref.watch(menuRepositoryProvider).watchCategories());
final productsProvider = StreamProvider<List<Product>>((ref) => ref.watch(menuRepositoryProvider).watchProducts());

final menuQueryProvider = Provider.family<List<Product>, MenuQuery>((ref, q) {
  final products = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  return products
      .where((p) => q.categoryId == null || p.categoryId == q.categoryId)
      .where((p) => !q.onlyAvailable || p.isAvailable)
      .where((p) => matches(p, q.text))
      .toList();
});
