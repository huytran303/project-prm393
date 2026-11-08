import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'core/emulators.dart';
import 'core/notifications.dart';
import 'core/router/app_router.dart';
import 'core/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // The table QR opens /c/:tableId directly.
  Intl.defaultLocale = 'vi_VN';
  await initializeDateFormatting('vi_VN');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (useEmulators) await connectEmulators();
  runApp(const ProviderScope(child: BrewBossApp()));
}

class BrewBossApp extends ConsumerStatefulWidget {
  const BrewBossApp({super.key});
  @override
  ConsumerState<BrewBossApp> createState() => _BrewBossAppState();
}

class _BrewBossAppState extends ConsumerState<BrewBossApp> {
  final _messenger = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    ref.read(notificationServiceProvider).listen(
          onMessage: (text) => _messenger.currentState?.showSnackBar(SnackBar(content: Text(text))),
          onOpen: (route) => ref.read(routerProvider).push(route),
        );
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'BrewBoss',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: ref.watch(routerProvider),
        scaffoldMessengerKey: _messenger,
        locale: const Locale('vi', 'VN'),
        supportedLocales: const [Locale('vi', 'VN')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
      );
}
