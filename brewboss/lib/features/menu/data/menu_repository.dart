import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/models.dart';

class MenuRepository {
  MenuRepository(this._db, this._storage);
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  Stream<List<Category>> watchCategories() => _db.collection('categories').orderBy('sortOrder').snapshots().map(
      (s) => s.docs.map((d) => Category.fromJson(withId(d))).toList());

  Stream<List<Product>> watchProducts() => _db.collection('products').orderBy('name').snapshots().map(
      (s) => s.docs.map((d) => Product.fromJson(withId(d))).toList());

  String newProductId() => _db.collection('products').doc().id;

  Future<void> saveProduct(Product p) => _db.doc('products/${p.id}').set(toDoc(p.toJson()));
  Future<void> deleteProduct(String id) => _db.doc('products/$id').delete();
  Future<void> setAvailable(String id, bool available) => _db.doc('products/$id').update({'isAvailable': available});

  Future<String> uploadImage(String productId, Uint8List bytes) async {
    final ref = _storage.ref('products/$productId.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<void> saveCategory(Category c) {
    final col = _db.collection('categories');
    return (c.id.isEmpty ? col.doc() : col.doc(c.id)).set(toDoc(c.toJson()));
  }

  Future<void> deleteCategory(String id) => _db.doc('categories/$id').delete();

  Future<void> reorder(List<Category> ordered) {
    final batch = _db.batch();
    for (final (i, c) in ordered.indexed) {
      batch.update(_db.doc('categories/${c.id}'), {'sortOrder': i});
    }
    return batch.commit();
  }
}
