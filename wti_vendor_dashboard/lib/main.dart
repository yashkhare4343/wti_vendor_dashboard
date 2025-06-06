import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/route_management/app_page.dart';
import 'core/route_management/app_routes.dart';
import 'firebase_options.dart';

final secureStorage = FlutterSecureStorage();
final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> writeData(String key, String value) async {
  if (Platform.isIOS) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  } else {
    await secureStorage.write(key: key, value: value);
  }
}

Future<String?> readData(String key) async {
  if (Platform.isIOS) {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  } else {
    return await secureStorage.read(key: key);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.notification?.body != null) {
    await writeData('notification_payload', message.notification!.body!);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _navigateToConfirmBooking() {
    Future.delayed(const Duration(milliseconds: 300), () {
      final context = navigatorKey.currentContext;
      if (context != null) {
        GoRouter.of(context).go(AppRoutes.confirmBooking);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  Future<void> initFCM() async {
    await FirebaseMessaging.instance.requestPermission();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for booking notifications.',
      importance: Importance.high,
    );

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateToConfirmBooking();
      },
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("🔑 FCM Token: $fcmToken");

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📩 Foreground message: ${message.notification?.body}');

      if (message.notification?.body != null) {
        await writeData('notification_payload', message.notification!.body!);
      }

      final notification = message.notification;
      if (notification?.android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Background Tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification?.body != null) {
        await writeData('notification_payload', message.notification!.body!);
      }
      _navigateToConfirmBooking();
    });

    // Terminated State
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.notification?.body != null) {
      await writeData('notification_payload', initialMessage!.notification!.body!);
      _navigateToConfirmBooking();
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
