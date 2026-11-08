import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase_providers.dart';
import '../../../core/utils/date_range.dart';
import '../../../models/models.dart';
import '../data/report_repository.dart';
import 'report_rules.dart';

final reportRepositoryProvider = Provider((ref) => ReportRepository(ref.watchDb()));

final todayPaidOrdersProvider = StreamProvider<List<Order>>((ref) {
  final today = DateRange.today();
  return ref.watch(reportRepositoryProvider).watchPaidOrders(today.from, today.to);
});

final yesterdayRevenueProvider = FutureProvider<int>((ref) async {
  final today = DateRange.today();
  final start = DateTime(today.from.year, today.from.month, today.from.day - 1);
  final orders = await ref.watch(reportRepositoryProvider).paidOrders(start, today.from);
  return summary(orders).revenue;
});

final onShiftCountProvider = StreamProvider<int>((ref) => ref.watch(reportRepositoryProvider).watchOnShiftCount());

class ReportQuery {
  const ReportQuery(this.bucket, this.range);
  final Bucket bucket;
  final DateRange range;
  @override
  bool operator ==(Object other) => other is ReportQuery && other.bucket == bucket && other.range == range;
  @override
  int get hashCode => Object.hash(bucket, range);
}

class Report {
  const Report(this.orders, this.points);
  final List<Order> orders;
  final List<Point> points;
  RevenueSummary get totals => summary(orders);
}

final reportProvider = FutureProvider.autoDispose.family<Report, ReportQuery>((ref, q) async {
  final orders = await ref.watch(reportRepositoryProvider).paidOrders(q.range.from, q.range.to);
  return Report(orders, byBucket(orders, q.bucket, q.range.from, q.range.to));
});

final historyProvider = FutureProvider.autoDispose.family<List<Order>, DateRange>(
    (ref, r) => ref.watch(reportRepositoryProvider).ordersCreatedIn(r.from, r.to));

final customerOrdersProvider = FutureProvider.autoDispose.family<List<Order>, String>(
    (ref, id) => ref.watch(reportRepositoryProvider).paidOrdersOfCustomer(id));
