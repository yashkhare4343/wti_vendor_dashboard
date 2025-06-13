import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:wti_vendor_dashboard/screens/booking/booking_confirmation.dart';
import 'core/route_management/app_page.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

void _navigateToConfirmBookingWithPayload(BuildContext context, String rawPayload) {
  final bookingDetails = parsePayload(rawPayload);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookingConfirmation(bookingDetails: bookingDetails),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📥 [Background] message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initFCM();
  }

  Future<void> initFCM() async {
    await FirebaseMessaging.instance.requestPermission();

    // Register all channels which backend may send
    const flashingChannel = AndroidNotificationChannel(
      'flashing_channel',
      'Flashing Booking Notifications',
      description: 'Notifications for new flashing bookings.',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const assignedChannel = AndroidNotificationChannel(
      'assigned_channel',
      'Assigned Booking Notifications',
      description: 'Notifications for assigned bookings.',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const defaultChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for booking notifications.',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    final initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final context = navigatorKey.currentContext;
        if (context != null && response.payload != null) {
          _navigateToConfirmBookingWithPayload(context, response.payload!);
        }
      },
    );

    final android = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(flashingChannel);
    await android?.createNotificationChannel(assignedChannel);
    await android?.createNotificationChannel(defaultChannel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Booking Alert";
      final body = message.notification?.body ?? "You have a new booking";
      final payload = message.data['ordered_data'] ?? "";

      // Choose correct channel from backend payload
      String channelId = message.notification?.android?.channelId ?? defaultChannel.id;

      _localNotificationsPlugin.show(
        message.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelId,  // channel name is not required at runtime
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            sound: RawResourceAndroidNotificationSound('notification'),
          ),
        ),
        payload: payload,
      );
    });

    // Handle when app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final payload = message.data['ordered_data'] ?? "";
      final context = navigatorKey.currentContext;
      if (context != null && payload.isNotEmpty) {
        _navigateToConfirmBookingWithPayload(context, payload);
      }
    });

    // Handle initial message
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      final payload = initialMessage.data['ordered_data'] ?? "";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          _navigateToConfirmBookingWithPayload(context, payload);
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
