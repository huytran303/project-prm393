import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../loyalty/application/loyalty_providers.dart';
import '../../loyalty/application/loyalty_rules.dart';
import '../../staff/application/staff_providers.dart';
import 'order_rules.dart';
import 'pos_providers.dart';

final paymentControllerProvider = AsyncNotifierProvider<PaymentController, void>(PaymentController.new);

class PaymentController extends WriteController {
  String get _uid => ref.read(currentUidProvider)!;
  ShopSettings get _settings => ref.read(shopSettingsProvider).valueOrNull ?? const ShopSettings();

  /// One voucher per order; applying replaces the previous one (BR-DIS-01).
  Future<bool> applyVoucher(Order order, String code) => guard(() async {
        final voucher = await ref.read(loyaltyRepositoryProvider).findVoucher(code.trim().toUpperCase());
        final error = voucherError(voucher, order.subtotal, DateTime.now());
        if (error != null) throw RuleException(error, {'minOrder': formatVnd(voucher?.minOrder ?? 0)});
        await ref.read(orderRepositoryProvider).updateVoucher(
            order.id, voucher!.code, voucherDiscount(voucher, order.subtotal), _settings.vndPerPoint, _uid);
      });

  Future<bool> removeVoucher(Order order) =>
      guard(() => ref.read(orderRepositoryProvider).updateVoucher(order.id, null, 0, _settings.vndPerPoint, _uid));

  /// Finds or creates the customer, then saves it on the open order (UC38).
  Future<bool> attachCustomer(Order order, String phone, {String? name}) => guard(() async {
        final repo = ref.read(loyaltyRepositoryProvider);
        final normalized = normalizePhone(phone);
        final customer = await repo.findByPhone(normalized) ?? await repo.create(normalized, name: name);
        await ref.read(orderRepositoryProvider).updateLoyalty(order.id, customer.id, 0, _settings.vndPerPoint, _uid);
      });

  Future<bool> detachCustomer(Order order) =>
      guard(() => ref.read(orderRepositoryProvider).updateLoyalty(order.id, null, 0, _settings.vndPerPoint, _uid));

  Future<bool> redeemPoints(Order order, Customer customer, int points) => guard(() async {
        final beforePoints = totalOf(order.subtotal, order.discount, 0, _settings.vndPerPoint);
        final max = maxRedeemable(customer.points, beforePoints, _settings.vndPerPoint);
        if (points < 0 || points > max) throw RuleException('MSG40', {'max': max});
        await ref.read(orderRepositoryProvider).updateLoyalty(order.id, customer.id, points, _settings.vndPerPoint, _uid);
      });

  Future<bool> pay(Order order, PaymentInput input) => guard(() async {
        if (ref.read(openShiftProvider).valueOrNull == null) throw const RuleException('MSG28');
        validatePayment(order.total, input.cash, input.qr);
        await ref.read(orderRepositoryProvider).pay(order.id, input, _settings, _uid);
      });
}
