import 'package:intl/intl.dart';

import '../../../models/models.dart';

enum Bucket { day, week, month }

class RevenueSummary {
  const RevenueSummary(this.revenue, this.count);
  final int revenue;
  final int count;
  int get average => count == 0 ? 0 : revenue ~/ count;
}

/// One chart bar: its period [from, to) and paid revenue.
class Point {
  const Point(this.label, this.from, this.to, this.revenue);
  final String label;
  final DateTime from;
  final DateTime to;
  final int revenue;
}

RevenueSummary summary(List<Order> orders) =>
    RevenueSummary(orders.fold(0, (s, o) => s + o.total), orders.length);

DateTime _bucketStart(DateTime d, Bucket b) => switch (b) {
      Bucket.day => DateTime(d.year, d.month, d.day),
      Bucket.week => DateTime(d.year, d.month, d.day - (d.weekday - 1)),
      Bucket.month => DateTime(d.year, d.month),
    };

DateTime _bucketNext(DateTime start, Bucket b) => switch (b) {
      Bucket.day => DateTime(start.year, start.month, start.day + 1),
      Bucket.week => DateTime(start.year, start.month, start.day + 7),
      Bucket.month => DateTime(start.year, start.month + 1),
    };

String _bucketLabel(DateTime d, Bucket b) => switch (b) {
      Bucket.day => d.weekday == DateTime.sunday ? 'CN' : 'T${d.weekday + 1}',
      Bucket.week => DateFormat('dd/MM').format(d),
      Bucket.month => DateFormat('MM/yy').format(d),
    };

/// Revenue per bucket across [from, to), including empty buckets.
List<Point> byBucket(List<Order> orders, Bucket b, DateTime from, DateTime to) {
  final points = <Point>[];
  for (var start = _bucketStart(from, b); start.isBefore(to); start = _bucketNext(start, b)) {
    final next = _bucketNext(start, b);
    final revenue = orders
        .where((o) => o.paidAt != null && !o.paidAt!.isBefore(start) && o.paidAt!.isBefore(next))
        .fold(0, (s, o) => s + o.total);
    points.add(Point(_bucketLabel(start, b), start, next, revenue));
  }
  return points;
}

/// Best sellers by quantity.
List<(String, int)> topProducts(List<Order> orders, int n) {
  final qty = <String, int>{};
  for (final o in orders) {
    for (final i in o.items) {
      qty[i.name] = (qty[i.name] ?? 0) + i.qty;
    }
  }
  final sorted = qty.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  return [for (final e in sorted.take(n)) (e.key, e.value)];
}

(int cash, int qr) paymentSplit(List<Order> orders) => (
      orders.fold(0, (s, o) => s + o.cashAmount),
      orders.fold(0, (s, o) => s + o.qrAmount),
    );

/// false for merge / add-on closures (mergedIntoId set).
bool isRealCancel(Order o) => o.status == OrderStatus.cancelled && o.mergedIntoId == null;
