import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(authProvider)));
final userRepositoryProvider = Provider((ref) => UserRepository(ref.watchDb()));

final authStateProvider =
    StreamProvider<User?>((ref) => ref.watch(authRepositoryProvider).authStateChanges());

final currentUidProvider = Provider<String?>((ref) => ref.watch(authStateProvider).valueOrNull?.uid);

/// Live users/{uid}; null for no session and for anonymous customers.
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final auth = ref.watch(authStateProvider);
  final user = auth.valueOrNull;
  if (user == null || user.isAnonymous) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchUser(user.uid);
});

final shopSettingsProvider = StreamProvider<ShopSettings>((ref) {
  ref.watch(currentUidProvider);
  return ref.watch(userRepositoryProvider).watchSettings();
});
