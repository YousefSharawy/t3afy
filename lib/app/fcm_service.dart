import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t3afy/firebase_options.dart';

/// Called in the background / terminated state by FirebaseMessaging.
/// Must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No UI work here — system tray handles display automatically via FCM data.
}

class FcmService {
  FcmService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 't3afy_notifications';
  static const _channelName = 'إشعارات تعافي';

  static Future<void>? _initFuture;
  static StreamSubscription<String>? _tokenRefreshSub;

  /// Initializes Firebase + local notifications once. Runs after the first
  /// frame (see main.dart); every other entry point awaits it, so callers never
  /// race the init. Safe to call any number of times.
  static Future<void> initialize() => _initFuture ??= _init();

  static Future<void> _init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      importance: Importance.high,
      enableVibration: true,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(
        // Asked explicitly in [requestPermission], not on plugin init.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Navigation on tap handled via onMessageOpenedApp stream
      },
    );

    FirebaseMessaging.onMessage.listen(_showForeground);

    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /// Shows the OS permission prompt (iOS + Android 13+). Called after the
  /// first frame so the dialog never blocks startup.
  static Future<void> requestPermission() async {
    try {
      await initialize();
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Non-fatal — push is best-effort
    }
  }

  static void _showForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  static Future<void> _writeToken(String userId, String? token) => Supabase
      .instance
      .client
      .from('users')
      .update({'fcm_token': token})
      .eq('id', userId);

  /// Save the device FCM token to Supabase users table and keep it updated.
  static Future<void> saveTokenForUser(String userId) async {
    try {
      await initialize();
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _writeToken(userId, token);
      await listenForTokenRefresh(userId);
    } catch (_) {
      // Non-fatal — push is best-effort
    }
  }

  /// Keeps exactly one rotation listener alive (replaces any previous one, so
  /// repeated logins don't stack listeners writing to old user ids).
  static Future<void> listenForTokenRefresh(String userId) async {
    try {
      await initialize();
      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
        (newToken) => _writeToken(userId, newToken).catchError((_) {}),
      );
    } catch (_) {}
  }

  /// Logout: stop tracking rotations and detach this device from the user so
  /// they stop receiving pushes meant for the account.
  static Future<void> clearTokenForUser(String userId) async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    try {
      await _writeToken(userId, null);
    } catch (_) {}
  }
}
