import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:wti_vendor_dashboard/core/controller/auth/auth_controller.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_page.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📥 Background FCM: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initializeLocalNotifications();

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  runApp(MyApp(initialMessage));
}

Future<void> initializeLocalNotifications() async {
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  await notificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload != null && payload.isNotEmpty) {
        final bookingDetails = parsePayload(payload);
        AppPages.router.push(AppRoutes.confirmBooking, extra: bookingDetails);
      }
    },
  );
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const MyApp(this.initialMessage, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    authController.initFCM();
    listenToFCM();
    handleInitialMessage(widget.initialMessage);
  }

  void listenToFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Booking Alert";
      final body = message.notification?.body ?? "You have a new booking";
      final payload = message.data['ordered_data'] ?? "";

      notificationsPlugin.show(
        message.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            sound: RawResourceAndroidNotificationSound('notification'), // your custom sound
          ),
        ),
        payload: payload,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final payload = message.data['ordered_data'] ?? "";
      if (payload.isNotEmpty) {
        final bookingDetails = parsePayload(payload);
        AppPages.router.push(AppRoutes.confirmBooking, extra: bookingDetails);
      }
    });
  }

  void handleInitialMessage(RemoteMessage? initialMessage) {
    if (initialMessage != null) {
      final payload = initialMessage.data['ordered_data'] ?? "";
      if (payload.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          final bookingDetails = parsePayload(payload);
          AppPages.router.push(AppRoutes.confirmBooking, extra: bookingDetails);
        });
      }
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
