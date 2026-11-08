import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../models/models.dart';
import '../data/loyalty_repository.dart';

final loyaltyRepositoryProvider = Provider((ref) => LoyaltyRepository(ref.watchDb()));

final customersProvider = StreamProvider<List<Customer>>((ref) => ref.watch(loyaltyRepositoryProvider).watchCustomers());
final vouchersProvider = StreamProvider<List<Voucher>>((ref) => ref.watch(loyaltyRepositoryProvider).watchVouchers());
final customerProvider = StreamProvider.autoDispose.family<Customer?, String>(
    (ref, id) => ref.watch(loyaltyRepositoryProvider).watchCustomer(id));
