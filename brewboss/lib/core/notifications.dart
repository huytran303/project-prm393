import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/application/auth_providers.dart';
import 'router/routes.dart';

final notificationServiceProvider = Provider((ref) => NotificationService(ref));

/// FCM token registration and deep links (SDS 4.1.3). Staff apps only: the web
/// build serves customers. A failed token call must never block sign-in.
class NotificationService {
  NotificationService(this._ref);
  final Ref _ref;

  bool get _supported => !kIsWeb;

  StreamSubscription<String>? _tokens;
  String? _token;

  /// Also covers token refreshes for as long as the session lasts.
  Future<void> registerToken(String uid) async {
    if (!_supported) return;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      await _tokens?.cancel();
      _tokens = messaging.onRegistered.listen((token) {
        _token = token;
        _ref.read(userRepositoryProvider).addFcmToken(uid, token).catchError(
            (Object e) => debugPrint('FCM token save skipped: $e'));
      });
      await messaging.register();
    } catch (e) {
      debugPrint('FCM registration skipped: $e');
    }
  }

  Future<void> removeToken(String uid) async {
    await _tokens?.cancel();
    _tokens = null;
    final token = _token;
    _token = null;
    if (token == null) return;
    try {
      await _ref.read(userRepositoryProvider).removeFcmToken(uid, token);
    } catch (e) {
      debugPrint('FCM removal skipped: $e');
    }
  }

  /// Foreground pushes become a message; a tapped push opens its target screen.
  void listen({required void Function(String text) onMessage, required void Function(String route) onOpen}) {
    if (!_supported) return;
    FirebaseMessaging.onMessage.listen((m) {
      final body = m.notification?.body;
      if (body != null) onMessage(body);
    });
    void open(RemoteMessage m) {
      final route = routeFor(m.data);
      if (route != null) onOpen(route);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(open);
    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) open(m);
    }).catchError((Object e) => debugPrint('FCM initial message skipped: $e'));
  }

  static String? routeFor(Map<String, dynamic> data) => switch (data['type']) {
        'orderReady' => Routes.order('${data['orderId']}'),
        'lowStock' => '${Routes.inventory}/${data['ingredientId']}',
        _ => null,
      };
}
