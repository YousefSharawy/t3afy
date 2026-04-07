import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Call once from main() after Firebase.initializeApp().
  static Future<void> init() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permission (iOS + Android 13+)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android local notification channel
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

    // Init flutter_local_notifications
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Navigation on tap handled via onMessageOpenedApp stream
      },
    );

    // Show local notification for foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
    });
  }

  /// Save the device FCM token to Supabase users table.
  static Future<void> saveTokenForUser(String userId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await Supabase.instance.client
          .from('users')
          .update({'fcm_token': token})
          .eq('id', userId);

      // Refresh token if it rotates
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await Supabase.instance.client
            .from('users')
            .update({'fcm_token': newToken})
            .eq('id', userId);
      });
    } catch (_) {
      // Non-fatal — push is best-effort
    }
  }

  /// iOS only: must be called to show foreground notifications on iOS.
  static Future<void> setForegroundPresentationOptions() async {
    if (!Platform.isIOS) return;
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
