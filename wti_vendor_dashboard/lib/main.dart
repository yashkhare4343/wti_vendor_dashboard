import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/screens/booking/booking_confirmation.dart';

import 'core/route_management/app_page.dart';
import 'core/route_management/app_routes.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Helper: Parse raw payload string into Map<String,String>
Map<String, String> parsePayload(String payload) {
  final Map<String, String> map = {};
  final lines = payload.split('\n');
  for (var line in lines) {
    final parts = line.split(':');
    if (parts.length >= 2) {
      final key = parts[0].trim().toLowerCase();
      final value = parts.sublist(1).join(':').trim();
      map[key] = value;
    }
  }
  return map;
}

// Navigate and pass data via MaterialPageRoute
void _navigateToConfirmBookingWithPayload(BuildContext context, String rawPayload) {
  final bookingDetails = parsePayload(rawPayload);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookingConfirmation(bookingDetails: bookingDetails),
  ));
}

// Background handler (optional here, no navigation from background)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📥 [Background] message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  Future<void> writeData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> debugStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getString(key);
    print("✅ Stored [$key]: $storedValue");
  }

  Future<void> initFCM() async {
    await FirebaseMessaging.instance.requestPermission();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for booking notifications.',
      importance: Importance.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'), // Add custom sound

    );

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          final rawPayload = response.payload ?? "";
          _navigateToConfirmBookingWithPayload(context, rawPayload);
        }
      },
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("🔑 FCM Token: $fcmToken");

    if (fcmToken != null && fcmToken.isNotEmpty) {
      await debugStorage("fcm_token");
    }

    // Foreground messages: show local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 [Foreground] message: ${message.data}');

      final title = message.notification?.title ??
          message.data['title'] ??
          "Booking Alert";
      final body = message.data['body'] ??
          message.notification?.body ??
          "You have a new booking";

      // ✅ FIX: Proper payload format for foreground tap
      final payload = message.data.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');

      _localNotificationsPlugin.show(
        message.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: const BigTextStyleInformation(''),
            playSound: true,
            sound: const RawResourceAndroidNotificationSound('notification'), // Add custom sound
          ),
        ),
        payload: payload,
      );
    });

    // When app is opened from notification (background -> foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📩 [OpenedApp] message: ${message.data}');
      final context = navigatorKey.currentContext;
      if (context != null) {
        final payload = message.data.entries
            .map((e) => '${e.key}: ${e.value}')
            .join('\n');
        _navigateToConfirmBookingWithPayload(context, payload);
      }
    });

    // ✅ Handle terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      print('📩 [InitialMessage] message: ${initialMessage.data}');
      final payload = initialMessage.data.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');

      // Delay navigation until context is available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          _navigateToConfirmBookingWithPayload(context, payload);
        } else {
          print("⚠️ navigatorKey context not ready at launch.");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      routerDelegate: AppPages.router.routerDelegate,
      routeInformationParser: AppPages.router.routeInformationParser,
      routeInformationProvider: AppPages.router.routeInformationProvider,
      title: "Booking App",
      debugShowCheckedModeBanner: false,
    );
  }
}
