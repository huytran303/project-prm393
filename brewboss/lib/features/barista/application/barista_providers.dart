import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/models.dart';
import '../../pos/application/pos_providers.dart';

final queueProvider = StreamProvider<List<Order>>((ref) => ref.watch(orderRepositoryProvider).watchQueue());
