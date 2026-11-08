import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../../pos/application/pos_providers.dart';
import '../data/customer_order_repository.dart';

final customerOrderRepositoryProvider =
    Provider((ref) => CustomerOrderRepository(ref.watchDb(), ref.watch(authProvider)));

/// Anonymous sign-in when no session exists; every customer read waits for it.
final customerSessionProvider =
    FutureProvider<String>((ref) => ref.watch(customerOrderRepositoryProvider).signInAnonymously());

final publicShopProvider = StreamProvider<String>((ref) async* {
  await ref.watch(customerSessionProvider.future);
  yield* ref.watch(customerOrderRepositoryProvider).watchShopName();
});

final customerTableProvider = FutureProvider.family<CafeTable?, String>((ref, id) async {
  await ref.watch(customerSessionProvider.future);
  return ref.watch(tableRepositoryProvider).getTable(id);
});

final lastCustomerOrderProvider = FutureProvider.family<String?, String>((ref, tableId) async {
  final uid = await ref.watch(customerSessionProvider.future);
  return ref.watch(customerOrderRepositoryProvider).lastOrderFor(tableId, uid);
});

/// Own order, or the order its mergedIntoId points to after an add-on (BR-ORD-07).
final trackedOrderProvider = StreamProvider.family<TrackedOrder, String>((ref, id) async* {
  await ref.watch(customerSessionProvider.future);
  final repo = ref.watch(customerOrderRepositoryProvider);
  await for (final own in repo.watchOrder(id)) {
    final target = own.mergedIntoId;
    if (target == null) {
      yield TrackedOrder(own, merged: false);
    } else {
      yield* repo.watchOrder(target).map((o) => TrackedOrder(o, merged: true));
    }
  }
});

class TrackedOrder {
  const TrackedOrder(this.order, {required this.merged});
  final Order order;
  final bool merged;
}
