/// Half-open period [from, to) used by shift, report and order queries.
class DateRange {
  const DateRange(this.from, this.to);
  final DateTime from;
  final DateTime to;

  factory DateRange.today([DateTime? now]) {
    final n = now ?? DateTime.now();
    final start = DateTime(n.year, n.month, n.day);
    return DateRange(start, DateTime(n.year, n.month, n.day + 1));
  }

  /// Monday-based current week.
  factory DateRange.thisWeek([DateTime? now]) {
    final n = now ?? DateTime.now();
    final start = DateTime(n.year, n.month, n.day - (n.weekday - 1));
    return DateRange(start, DateTime(start.year, start.month, start.day + 7));
  }

  /// Inclusive last day, for display and pickers.
  DateTime get lastDay => DateTime(to.year, to.month, to.day - 1);

  @override
  bool operator ==(Object other) => other is DateRange && other.from == from && other.to == to;
  @override
  int get hashCode => Object.hash(from, to);
}
