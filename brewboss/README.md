# BrewBoss — Cafe Shop Management (PRM393 G2)

Flutter app built from `SRS_PRM393_G2_Cafe_Shop_Management.docx` and
`SDS_PRM393_G2_Cafe_Shop_Management.docx`: 22 screens, one code base for staff
(Android / iOS) and customers (web). The backend is Firebase, with no custom server.

## Run locally (no Firebase account needed)

Requires Flutter 3.x, Node.js and Java 21+ (Android Studio's bundled JDK works:
`export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"`).

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
(cd functions && npm install)
firebase emulators:start --only auth,firestore,storage --project demo-brewboss   # keep running
(cd functions && npm run seed)                                                    # resets demo data
flutter run                                                                       # or -d chrome
```

On a physical device add `--dart-define=EMULATOR_HOST=<your-LAN-IP>`.

| Account | Role | Home |
|---|---|---|
| quan@brewboss.vn | Manager | Dashboard |
| ha@brewboss.vn | Shift Supervisor | Table map |
| lan@brewboss.vn | Cashier | Table map |
| minh@brewboss.vn | Barista | Queue |
| thanh@brewboss.vn | Cashier (deactivated) | Login is refused |

Password for all accounts: `123456`. The customer menu is at `/c/<tableId>`; the
QR dialog on Manager → Bàn encodes that URL.

## Tests

```bash
flutter test                         # business rules
(cd functions && npm run test:rules) # Security Rules, starts its own emulator
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d <device>   # full flow; needs emulators + fresh seed
```

## Deploy to a real project

```bash
flutterfire configure --project=brewboss-prm393   # replaces lib/firebase_options.dart
firebase deploy --project prod --only firestore,storage,functions
flutter build web --dart-define=USE_EMULATORS=false && firebase deploy --project prod --only hosting
flutter build apk --dart-define=USE_EMULATORS=false \
  --dart-define=CUSTOMER_BASE_URL=https://brewboss-prm393.web.app
```

Cloud Functions need the Blaze plan. Without them, the in-app banners on the table
map and dashboard still show ready orders and low stock.

## Layout

`lib/features/<feature>/{data,application,presentation}` as in SDS 3.2.3, with
`lib/core` and `lib/models` shared. Generated `*.freezed.dart` / `*.g.dart` files
are not git-ignored, so the project can build right after checkout.
