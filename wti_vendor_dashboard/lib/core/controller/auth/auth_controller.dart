import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../api/api_services.dart';

// Update with the correct path

class AuthController extends GetxController {
  var authResponse = Rxn<AuthResponse>(); // Holds API response
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  RxString localStartTime = "Loading...".obs;
  var fcmToken = ''.obs;

  // Reactive variable for UI updates

  @override
  void onInit() {
    super.onInit();
    initFCM();// Initialize timezone data
  }

  Future<String?> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> writeData(String key, String value) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await secureStorage.write(key: key, value: value);
      print('User Exist store successfully');
    }
  }

  Future<void> initFCM() async {
    await FirebaseMessaging.instance.requestPermission();

    // Create all channels your backend is using
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

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final android = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(flashingChannel);
    await android?.createNotificationChannel(assignedChannel);
    await android?.createNotificationChannel(defaultChannel);

    // Fetch and print FCM token
    fcmToken.value = await FirebaseMessaging.instance.getToken() ?? '';
    print("🔑 FCM Token: $fcmToken");
  }

    Future<void> verifyAuth(String email, String password,
        BuildContext context) async {
      try {
        isLoading.value = true;
        final apiService = ApiService();

        Map<String, dynamic> requestData = {
          "Email": email,
          "password": password,
          "fcm_token": fcmToken.value
        };

        // Map<String, dynamic> requestData = {
        //   "Email": 'gauravgangola444@gmail.com',
        //   "password": '123456'
        // };

        print('request data is : $requestData');

        final responseData = await apiService.postRequest(
            'Auth/login',
            requestData,
            context
        );

        // Parse response into BookingResponse model
        authResponse.value = AuthResponse.fromJson(responseData);
        // mostly using in tracking event
        await writeData(
            'userExists', authResponse.value?.userExists.toString() ?? '');
        await writeData('token', authResponse.value?.accessToken ?? '');
        await writeData('role', authResponse.value?.role ?? '');
        await writeData('userid', authResponse.value?.userid ?? '');

        if (authResponse.value?.userExists == true) {
          GoRouter.of(context).push(AppRoutes.dashboard);
        }
        if (authResponse.value?.userExists == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Username and password does not match correctly',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }

      } catch (error) {
        // print("Error fetching booking data: $error");
        //         // errorMessage.value = error.toString();
        if (authResponse.value?.userExists == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Username and password does not match correctly',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }


