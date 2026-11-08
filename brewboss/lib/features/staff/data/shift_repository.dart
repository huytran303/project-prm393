import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/rule_exception.dart';
import '../../../models/models.dart';
import '../application/staff_rules.dart';

class ShiftRepository {
  ShiftRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _shifts => _db.collection('shifts');

  Shift _fromDoc(DocumentSnapshot<Map<String, dynamic>> d) => Shift.fromJson(withId(d));

  Stream<Shift?> watchOpenShift(String userId) => _shifts
      .where('userId', isEqualTo: userId)
      .where('checkOut', isNull: true)
      .limit(1)
      .snapshots()
      .map((s) => s.docs.isEmpty ? null : _fromDoc(s.docs.first));

  /// The lock document makes a second check-in fail on any device (BR-STAFF-01).
  Future<void> checkIn(AppUser user, int? openingCash) => _db.runTransaction((txn) async {
        final lock = _db.doc('shiftLocks/${user.id}');
        if ((await txn.get(lock)).exists) throw const RuleException('Bạn đang trong ca, hãy check-out trước');
        final shift = _shifts.doc();
        txn.set(shift, {
          'userId': user.id,
          'userName': user.name,
          'userRole': user.role.name,
          'checkIn': FieldValue.serverTimestamp(),
          'checkOut': null,
          'openingCash': openingCash,
          'cashSales': 0,
          'qrSales': 0,
        });
        txn.set(lock, {'shiftId': shift.id});
      });

  /// Recomputes expected cash from the shift totals, so a payment confirmed after
  /// the preview is included (SD-07).
  Future<void> checkOut(String shiftId, int? closingCash, String? note) => _db.runTransaction((txn) async {
        final ref = _shifts.doc(shiftId);
        final shift = _fromDoc(await txn.get(ref));
        final data = <String, Object?>{'checkOut': FieldValue.serverTimestamp()};
        if (shift.openingCash != null) {
          final expected = shift.openingCash! + shift.cashSales;
          final diff = cashDiff(closingCash ?? 0, expected);
          if (needsNote(diff) && (note == null || note.trim().isEmpty)) throw const RuleException('MSG43');
          data.addAll({'closingCash': closingCash, 'expectedCash': expected, 'cashDiff': diff, 'handoverNote': note});
        }
        txn.update(ref, data);
        txn.delete(_db.doc('shiftLocks/${shift.userId}'));
      });

  Stream<List<Shift>> watchShifts(DateTime from, DateTime to) => _shifts
      .where('checkIn', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
      .where('checkIn', isLessThan: Timestamp.fromDate(to))
      .orderBy('checkIn', descending: true)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  Stream<List<Shift>> watchRecent(String userId) => _shifts
      .where('userId', isEqualTo: userId)
      .orderBy('checkIn', descending: true)
      .limit(6)
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());
}
