import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:wti_vendor_dashboard/utility/constants/strings/string_constants.dart';

import 'core/route_management/app_page.dart';
import 'firebase_options.dart';


final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel', // Must match AndroidManifest
  'High Importance Notifications',
  importance: Importance.high,
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// getIt
final GetIt getIt = GetIt.instance();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔄 Background message received: ${message.messageId}');
}


void main() async{
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
  // This widget is the root of your application.
  String? _fcmToken = 'Fetching...';

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  Future<void> initFCM() async {
    // Request permissions
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('🛂 User permission status: ${settings.authorizationStatus}');

    // Skip APNs handling on iOS simulator
    if (Platform.isIOS && !Platform.environment.containsKey('SIMULATOR_DEVICE_NAME')) {
      String? apnsToken;
      do {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        await Future.delayed(Duration(milliseconds: 500));
      } while (apnsToken == null);
      print('📲 APNs Token: $apnsToken');
    } else {
      print('ℹ️ Skipping APNs token setup (non-iOS or Simulator)');
    }

    // Get FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔑 FCM Token: $token");

    setState(() {
      _fcmToken = token;
    });

    // Local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(initSettings);

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message received!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Background open
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 App opened from background notification: ${message.data}');
    });

    // Terminated open
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App launched from terminated notification: ${initialMessage.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      routerDelegate: AppPages.router.routerDelegate,
      routeInformationParser: AppPages.router.routeInformationParser,
      routeInformationProvider: AppPages.router.routeInformationProvider,
      title: StringConstants.title,
    );
  }
}

