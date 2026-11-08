import 'package:firebase_auth/firebase_auth.dart';

import 'messages.dart';
import 'rule_exception.dart';

/// Maps exceptions to the Vietnamese messages of SDS 4.1.1.
class ErrorMapper {
  static String message(Object? error) {
    if (error is RuleException) return msg(error.code, error.args);
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'wrong-password' || 'invalid-credential' || 'user-not-found' || 'invalid-email' => msg('MSG01'),
        'too-many-requests' => msg('MSG02'),
        'user-disabled' => msg('MSG03'),
        'email-already-in-use' => msg('MSG07'),
        'network-request-failed' => msg('MSG18'),
        _ => error.message ?? 'Đã có lỗi xảy ra',
      };
    }
    if (error is FirebaseException) {
      return switch (error.code) {
        'permission-denied' => 'Bạn không có quyền thực hiện thao tác này',
        'unavailable' => msg('MSG18'),
        _ => error.message ?? 'Đã có lỗi xảy ra',
      };
    }
    return 'Đã có lỗi xảy ra';
  }
}
