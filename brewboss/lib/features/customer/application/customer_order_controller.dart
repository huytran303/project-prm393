import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../../pos/application/order_rules.dart';
import 'customer_providers.dart';

final customerOrderControllerProvider =
    AsyncNotifierProvider<CustomerOrderController, void>(CustomerOrderController.new);

class CustomerOrderController extends WriteController {
  /// Id of the order sent by the last successful [placeOrder].
  String? placedId;

  Future<bool> placeOrder(String tableId, List<OrderItem> items) => guard(() async {
        final uid = await ref.read(customerSessionProvider.future);
        final subtotal = subtotalOf(items);
        try {
          placedId = await ref.read(customerOrderRepositoryProvider).placeOrder(
              Order(id: '', tableId: tableId, items: items, subtotal: subtotal, total: subtotal, createdBy: uid));
        } catch (_) {
          throw const RuleException('MSG38');
        }
      });
}
