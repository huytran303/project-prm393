import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import 'staff_providers.dart';

final staffControllerProvider = AsyncNotifierProvider<StaffController, void>(StaffController.new);

class StaffController extends WriteController {
  Future<bool> create(
          {required String name, required String email, required String phone, required UserRole role, required String tempPassword}) =>
      guard(() => ref
          .read(staffRepositoryProvider)
          .createAccount(name: name, email: email, phone: phone, role: role, tempPassword: tempPassword));

  Future<bool> updateStaff(AppUser user) => guard(() => ref.read(staffRepositoryProvider).update(user));

  /// A manager cannot deactivate their own account (BR-STAFF-02).
  Future<bool> setActive(String uid, bool active) => guard(() async {
        if (!active && uid == ref.read(currentUidProvider)) {
          throw const RuleException('Không thể khóa tài khoản của chính mình');
        }
        await ref.read(staffRepositoryProvider).setActive(uid, active);
      });
}
