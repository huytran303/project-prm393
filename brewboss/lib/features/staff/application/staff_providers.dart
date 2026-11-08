import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/emulators.dart';
import '../../../core/firebase_providers.dart';
import '../../../core/utils/date_range.dart';
import '../../../firebase_options.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../data/shift_repository.dart';
import '../data/staff_repository.dart';

Future<FirebaseAuth> _secondaryAuth() async {
  const name = 'staff-admin';
  final exists = Firebase.apps.any((a) => a.name == name);
  final app = exists
      ? Firebase.app(name)
      : await Firebase.initializeApp(name: name, options: DefaultFirebaseOptions.currentPlatform);
  final auth = FirebaseAuth.instanceFor(app: app);
  if (!exists && useEmulators) await auth.useAuthEmulator(emulatorHost, 9099);
  return auth;
}

final staffRepositoryProvider = Provider((ref) => StaffRepository(ref.watchDb(), _secondaryAuth));
final shiftRepositoryProvider = Provider((ref) => ShiftRepository(ref.watchDb()));

final openShiftProvider = StreamProvider<Shift?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(shiftRepositoryProvider).watchOpenShift(uid);
});

final recentShiftsProvider = StreamProvider<List<Shift>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(shiftRepositoryProvider).watchRecent(uid);
});

final staffListProvider =
    StreamProvider<List<AppUser>>((ref) => ref.watch(staffRepositoryProvider).watchStaff());

final shiftsProvider = StreamProvider.family<List<Shift>, DateRange>(
    (ref, r) => ref.watch(shiftRepositoryProvider).watchShifts(r.from, r.to));

/// Manager-only lookup uid → staff name for history rows.
final staffNamesProvider = Provider<Map<String, String>>((ref) {
  final staff = ref.watch(staffListProvider).valueOrNull ?? const [];
  return {for (final u in staff) u.id: u.name};
});
