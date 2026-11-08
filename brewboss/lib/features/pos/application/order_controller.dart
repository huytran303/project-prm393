import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import 'order_rules.dart';
import 'pos_providers.dart';

final orderControllerProvider = AsyncNotifierProvider<OrderController, void>(OrderController.new);

class OrderController extends WriteController {
  String get _uid => ref.read(currentUidProvider)!;
  int get _vndPerPoint => ref.read(shopSettingsProvider).valueOrNull?.vndPerPoint ?? 1000;

  /// Id of the order created by the last successful [create].
  String? createdId;

  /// Merge target of the last [confirmCustomerOrder], for MSG21.
  String? mergedInto;

  Future<bool> create(String? tableId, List<OrderItem> items) => guard(() async {
        final subtotal = subtotalOf(items);
        createdId = await ref.read(orderRepositoryProvider).create(
              Order(id: '', tableId: tableId, items: items, subtotal: subtotal, total: subtotal, createdBy: _uid),
              _uid,
            );
      });

  Future<bool> addItems(String orderId, List<OrderItem> items) =>
      guard(() => ref.read(orderRepositoryProvider).appendItems(orderId, items, _vndPerPoint, _uid));

  Future<bool> updateItems(String orderId, List<OrderItem> items) =>
      guard(() => ref.read(orderRepositoryProvider).updateItems(orderId, items, _vndPerPoint, _uid));

  Future<bool> confirmCustomerOrder(String orderId) => guard(() async {
        mergedInto = await ref.read(orderRepositoryProvider).confirm(orderId, _vndPerPoint, _uid);
      });

  /// Reject is a cancel of an awaiting order; both require a reason (MSG32).
  Future<bool> cancel(String orderId, String reason, bool made) => guard(() {
        if (reason.trim().isEmpty) throw const RuleException('MSG32');
        final role = ref.read(currentUserProvider).requireValue!.role;
        return ref.read(orderRepositoryProvider).cancel(orderId, reason.trim(), made, role, _uid);
      });

  Future<bool> markServed(String orderId) => guard(() => ref.read(orderRepositoryProvider).markServed(orderId, _uid));

  Future<bool> moveTable(String orderId, String targetTableId) =>
      guard(() => ref.read(orderRepositoryProvider).moveTable(orderId, targetTableId, _uid));

  Future<bool> merge(String sourceId, String targetId) =>
      guard(() => ref.read(orderRepositoryProvider).merge(sourceId, targetId, _vndPerPoint, _uid));
}
