import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import 'loyalty_providers.dart';

final voucherControllerProvider = AsyncNotifierProvider<VoucherController, void>(VoucherController.new);

class VoucherController extends WriteController {
  /// [isNew] enforces a unique code; editing keeps code and usage count (UC40).
  Future<bool> save(Voucher v, {required bool isNew}) => guard(() async {
        final repo = ref.read(loyaltyRepositoryProvider);
        if (!RegExp(r'^[A-Z0-9]+$').hasMatch(v.code)) throw const RuleException('Mã chỉ gồm A–Z và 0–9');
        if (v.type == VoucherType.percent ? (v.value < 1 || v.value > 100) : v.value <= 0) {
          throw const RuleException('Giá trị giảm không hợp lệ');
        }
        if (v.usageLimit < 1) throw const RuleException('Số lượt phải từ 1 trở lên');
        if (isNew && await repo.findVoucher(v.code) != null) throw const RuleException('Mã đã tồn tại');
        await repo.saveVoucher(v);
      });

  Future<bool> setActive(String code, bool active) =>
      guard(() => ref.read(loyaltyRepositoryProvider).setVoucherActive(code, active));

  Future<bool> updateCustomerName(String id, String? name) =>
      guard(() => ref.read(loyaltyRepositoryProvider).updateName(id, name));
}
