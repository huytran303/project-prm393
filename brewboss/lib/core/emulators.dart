import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Local Firebase Emulator Suite is the default until a real project is
/// configured; build with --dart-define=USE_EMULATORS=false for production.
const useEmulators = bool.fromEnvironment('USE_EMULATORS', defaultValue: true);

/// Android emulators reach the host machine through 10.0.2.2.
/// Override with --dart-define=EMULATOR_HOST=192.168.x.x for physical devices.
String get emulatorHost {
  const override = String.fromEnvironment('EMULATOR_HOST');
  if (override.isNotEmpty) return override;
  return !kIsWeb && defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
}

Future<void> connectEmulators() async {
  FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
  await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
  await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
}
