import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import 'auth_providers.dart';

final settingsControllerProvider = AsyncNotifierProvider<SettingsController, void>(SettingsController.new);

class SettingsController extends WriteController {
  Future<bool> save(ShopSettings s) => guard(() async {
        final digitsOnly = RegExp(r'^\d*$').hasMatch(s.bankAccountNo);
        if (!digitsOnly || s.lateOrderMinutes <= 0 || s.pointsPerVnd <= 0 || s.vndPerPoint <= 0) {
          throw const RuleException('MSG09');
        }
        await ref.read(userRepositoryProvider).saveSettings(s);
      });
}
