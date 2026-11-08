import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../pos/application/pos_providers.dart';
import 'staff_providers.dart';
import 'staff_rules.dart';

final myShiftControllerProvider = AsyncNotifierProvider<MyShiftController, void>(MyShiftController.new);

class MyShiftController extends WriteController {
  Future<bool> checkIn(int? openingCash) => guard(() async {
        final user = ref.read(currentUserProvider).requireValue!;
        if (user.role.handlesCash && (openingCash == null || openingCash < 0)) {
          throw const RuleException('MSG09');
        }
        await ref.read(shiftRepositoryProvider).checkIn(user, user.role.handlesCash ? openingCash : null);
      });

  /// Preview only; the stored value is recomputed at check-out (BR-STAFF-04).
  Future<CashSummary> previewHandover(Shift shift) async {
    final paid = await ref.read(orderRepositoryProvider).paidOrders(shift.userId, shift.checkIn!);
    final opening = shift.openingCash ?? 0;
    return CashSummary(
      opening: opening,
      cashSales: expectedCash(0, paid),
      qrSales: paid.fold(0, (sum, o) => sum + o.qrAmount),
    );
  }

  Future<bool> checkOut(String shiftId, int? closingCash, String? note) =>
      guard(() => ref.read(shiftRepositoryProvider).checkOut(shiftId, closingCash, note));
}
