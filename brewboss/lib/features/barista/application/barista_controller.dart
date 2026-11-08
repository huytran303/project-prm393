import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../pos/application/pos_providers.dart';

final baristaControllerProvider = AsyncNotifierProvider<BaristaController, void>(BaristaController.new);

class BaristaController extends WriteController {
  Future<bool> _set(String orderId, OrderStatus status) => guard(
      () => ref.read(orderRepositoryProvider).setStatus(orderId, status, ref.read(currentUidProvider)!));

  Future<bool> start(String orderId) => _set(orderId, OrderStatus.preparing);
  Future<bool> done(String orderId) => _set(orderId, OrderStatus.ready);

  /// "Hoàn tác" within five seconds of "Xong" (UC30).
  Future<bool> undoDone(String orderId) => _set(orderId, OrderStatus.preparing);
}
