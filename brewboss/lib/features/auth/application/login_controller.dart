import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/notifications.dart';
import '../../../core/utils/rule_exception.dart';
import 'auth_providers.dart';

final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(LoginController.new);

class LoginController extends WriteController {
  Future<bool> signIn(String email, String password) => guard(() async {
        final auth = ref.read(authRepositoryProvider);
        await auth.signIn(email.trim(), password);
        final uid = ref.read(authProvider).currentUser!.uid;
        final profile = await ref.read(userRepositoryProvider).getUser(uid);
        if (profile == null || !profile.isActive) {
          await auth.signOut();
          throw RuleException(profile == null ? 'MSG04' : 'MSG03');
        }
        // Not awaited: the OS permission prompt or a slow FCM must not hold up sign-in.
        unawaited(ref.read(notificationServiceProvider).registerToken(uid));
      });

  Future<bool> signOut() => guard(() async {
        final uid = ref.read(authProvider).currentUser?.uid;
        if (uid != null) await ref.read(notificationServiceProvider).removeToken(uid);
        await ref.read(authRepositoryProvider).signOut();
      });

  /// Always reports success so the existence of an email is not disclosed (UC03).
  Future<bool> sendReset(String email) async {
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email.trim());
    } catch (_) {}
    return true;
  }

  Future<bool> changePassword(String current, String next) =>
      guard(() => ref.read(authRepositoryProvider).changePassword(current, next));
}
