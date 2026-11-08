import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((_) => FirebaseFirestore.instance);
final authProvider = Provider((_) => FirebaseAuth.instance);
final storageProvider = Provider((_) => FirebaseStorage.instance);

final _sessionUidProvider = StreamProvider<String?>(
    (ref) => ref.watch(authProvider).authStateChanges().map((user) => user?.uid));

extension SessionDb on Ref {
  /// Firestore for a repository provider. Depending on the session rebuilds the
  /// repository, so every stream re-subscribes after login instead of staying
  /// stuck on the permission-denied error it received at logout.
  FirebaseFirestore watchDb() {
    watch(_sessionUidProvider.select((session) => session.valueOrNull));
    return watch(firestoreProvider);
  }
}

/// True while snapshots come from the offline cache (MSG18 banner). Uses the
/// Firestore metadata, so no connectivity package is needed.
final offlineProvider = StreamProvider<bool>((ref) {
  return ref
      .watchDb()
      .doc('settings/public')
      .snapshots(includeMetadataChanges: true)
      .map((s) => s.metadata.isFromCache);
});

/// Base of every write controller: `guard` runs the write, keeps the loading
/// state for disabling buttons and reports success as a bool (SDS 4.1.1).
abstract class WriteController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> guard(Future<void> Function() write) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(write);
    return !state.hasError;
  }
}
