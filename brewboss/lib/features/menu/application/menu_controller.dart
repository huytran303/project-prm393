import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import 'menu_providers.dart';

final menuControllerProvider = AsyncNotifierProvider<MenuController, void>(MenuController.new);

class MenuController extends WriteController {
  Future<bool> saveCategory(Category c) => guard(() async {
        final categories = ref.read(categoriesProvider).valueOrNull ?? const <Category>[];
        final name = foldAccents(c.name);
        if (categories.any((o) => o.id != c.id && foldAccents(o.name) == name)) {
          throw const RuleException('Tên danh mục đã tồn tại');
        }
        await ref.read(menuRepositoryProvider).saveCategory(c);
      });

  Future<bool> deleteCategory(String id) => guard(() async {
        final products = ref.read(productsProvider).valueOrNull ?? const <Product>[];
        if (products.any((p) => p.categoryId == id)) throw const RuleException('MSG11');
        await ref.read(menuRepositoryProvider).deleteCategory(id);
      });

  Future<bool> reorder(List<Category> ordered) => guard(() => ref.read(menuRepositoryProvider).reorder(ordered));

  /// An image upload failure must not block saving the product itself (UC08).
  Future<bool> saveProduct(Product p, XFile? image) => guard(() async {
        final repo = ref.read(menuRepositoryProvider);
        final id = p.id.isEmpty ? repo.newProductId() : p.id;
        var imageUrl = p.imageUrl;
        Object? uploadError;
        if (image != null) {
          try {
            imageUrl = await repo.uploadImage(id, await image.readAsBytes());
          } catch (e) {
            uploadError = e;
          }
        }
        await repo.saveProduct(p.copyWith(id: id, imageUrl: imageUrl));
        if (uploadError != null) throw const RuleException('Đã lưu món nhưng không tải được ảnh');
      });

  Future<bool> deleteProduct(String id) => guard(() => ref.read(menuRepositoryProvider).deleteProduct(id));

  Future<bool> setAvailable(String productId, bool available) =>
      guard(() => ref.read(menuRepositoryProvider).setAvailable(productId, available));
}
