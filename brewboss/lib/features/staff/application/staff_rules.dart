import '../../../models/models.dart';

bool canCheckIn(Shift? open) => open == null;

int expectedCash(int opening, List<Order> paid) =>
    paid.fold(opening, (sum, o) => sum + o.cashAmount);

int cashDiff(int closing, int expected) => closing - expected;

bool needsNote(int diff) => diff != 0;

Duration shiftDuration(Shift s, DateTime now) {
  final start = s.checkIn;
  return start == null ? Duration.zero : (s.checkOut ?? now).difference(start);
}
