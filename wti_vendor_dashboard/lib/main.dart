import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:wti_vendor_dashboard/core/controller/auth/auth_controller.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_page.dart';
import 'firebase_options.dart';
import 'notification_service.dart';

// ✅ Background FCM Handler (mandatory for terminated state)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📥 [Background] FCM data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Initialize notification service singleton
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    authController.initFCM();
    WidgetsBinding.instance.addObserver(this);

    // ✅ Handle initial notification navigation after app loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().checkPendingNavigation();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService().checkPendingNavigation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      routerDelegate: AppPages.router.routerDelegate,
      routeInformationParser: AppPages.router.routeInformationParser,
      routeInformationProvider: AppPages.router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: "Booking App",
    );
  }
}
