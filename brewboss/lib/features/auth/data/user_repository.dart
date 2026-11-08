import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/models.dart';

class UserRepository {
  UserRepository(this._db);
  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _user(String uid) => _db.doc('users/$uid');

  Stream<AppUser?> watchUser(String uid) =>
      _user(uid).snapshots().map((d) => d.exists ? AppUser.fromJson(withId(d)) : null);

  Future<AppUser?> getUser(String uid) async {
    final doc = await _user(uid).get();
    return doc.exists ? AppUser.fromJson(withId(doc)) : null;
  }

  Future<void> addFcmToken(String uid, String token) =>
      _user(uid).update({'fcmTokens': FieldValue.arrayUnion([token])});
  Future<void> removeFcmToken(String uid, String token) =>
      _user(uid).update({'fcmTokens': FieldValue.arrayRemove([token])});

  Stream<ShopSettings> watchSettings() => _db.doc('settings/shop').snapshots().map(
      (d) => d.exists ? ShopSettings.fromJson(d.data()!) : const ShopSettings());

  /// settings/public is the only part anonymous customers may read.
  Future<void> saveSettings(ShopSettings s) => (_db.batch()
        ..set(_db.doc('settings/shop'), s.toJson())
        ..set(_db.doc('settings/public'), {'name': s.name}))
      .commit();
}
