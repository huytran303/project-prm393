import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/models.dart';

class StaffRepository {
  StaffRepository(this._db, this._secondaryAuth);
  final FirebaseFirestore _db;

  /// Auth of a secondary FirebaseApp, so the manager stays signed in.
  final Future<FirebaseAuth> Function() _secondaryAuth;

  Stream<List<AppUser>> watchStaff() => _db.collection('users').orderBy('name').snapshots().map(
      (s) => s.docs.map((d) => AppUser.fromJson(withId(d))).toList());

  Future<String> createAccount(
      {required String name, required String email, required String phone, required UserRole role, required String tempPassword}) async {
    final auth = await _secondaryAuth();
    final cred = await auth.createUserWithEmailAndPassword(email: email, password: tempPassword);
    final uid = cred.user!.uid;
    await auth.signOut();
    await _db.doc('users/$uid').set({
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'isActive': true,
      'fcmTokens': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return uid;
  }

  Future<void> update(AppUser u) =>
      _db.doc('users/${u.id}').update({'name': u.name, 'phone': u.phone, 'role': u.role.name});

  Future<void> setActive(String uid, bool active) => _db.doc('users/$uid').update({'isActive': active});
}
