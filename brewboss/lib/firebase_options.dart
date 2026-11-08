import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Placeholder for the local Emulator Suite (project demo-brewboss needs no
/// cloud account). Run `flutterfire configure --project=brewboss-prm393` to
/// replace this file before building for production.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => FirebaseOptions(
        apiKey: 'demo-api-key',
        appId: kIsWeb
            ? '1:000000000000:web:0000000000000000000000'
            : defaultTargetPlatform == TargetPlatform.iOS
                ? '1:000000000000:ios:0000000000000000000000'
                : '1:000000000000:android:0000000000000000000000',
        messagingSenderId: '000000000000',
        projectId: 'demo-brewboss',
        storageBucket: 'demo-brewboss.appspot.com',
        iosBundleId: 'vn.brewboss.brewboss',
      );
}
