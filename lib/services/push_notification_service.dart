import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/student_notifications_screen.dart';

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel medilearnChannel = AndroidNotificationChannel(
  'medilearn_channel',
  'MediLearn Notifications',
  description: 'Medical learning notifications',
  importance: Importance.max,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String get _baseUrl =>
      kIsWeb ? 'http://127.0.0.1:5000' : 'http://10.0.2.2:5000';

  static Future<void> initialize({
    required String currentUserId,
  }) async {
    await Firebase.initializeApp();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint("Notification permission: ${settings.authorizationStatus}");

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notification clicked with payload: ${response.payload}");

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const StudentNotificationsScreen(),
          ),
        );
      },
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(medilearnChannel);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final token = await _messaging.getToken();
    debugPrint("FCM Token: $token");

    if (token != null && token.isNotEmpty) {
      await sendTokenToBackend(
        userId: currentUserId,
        token: token,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;

      debugPrint("Foreground notification received: ${message.data}");

      if (notification != null) {
        await localNotifications.show(
          notification.hashCode,
          notification.title ?? "New Medical Announcement",
          notification.body ?? "",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'medilearn_channel',
              'MediLearn Notifications',
              channelDescription: 'Medical learning notifications',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("User opened app from notification: ${message.data}");

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const StudentNotificationsScreen(),
        ),
      );
    });

    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint("FCM Token refreshed: $newToken");
      await sendTokenToBackend(
        userId: currentUserId,
        token: newToken,
      );
    });
  }

  static Future<void> sendTokenToBackend({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/notifications/save-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'fcmToken': token,
        }),
      );

      debugPrint("Save token status: ${response.statusCode}");
      debugPrint("Save token response: ${response.body}");
    } catch (e) {
      debugPrint("Failed to send token to backend: $e");
    }
  }
}