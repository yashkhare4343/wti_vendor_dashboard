import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  // Reactive variable for UI updates

  @override
  void onInit() {
    super.onInit();// Initialize timezone data
  }

  Future<String?> readData(String key) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  Future<void> writeData(String key, String value) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await secureStorage.write(key: key, value: value);
    }
  }

  Future<void> verifyAuth(String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();

      Map<String, dynamic> requestData = {
        "Email": email,
        "password": password
        };

      // Map<String, dynamic> requestData = {
      //   "Email": 'gauravgangola444@gmail.com',
      //   "password": '123456'
      // };

      // print('request data is : $requestData');

      final responseData = await apiService.postRequest(
          'Auth/login',
          requestData,
          context
      );

      // Parse response into BookingResponse model
      authResponse.value = AuthResponse.fromJson(responseData);
      // mostly using in tracking event
      await writeData('userExists', authResponse.value?.userExists.toString()?? '');
      await writeData('token', authResponse.value?.accessToken ?? '');
      await writeData('role', authResponse.value?.role ?? '');
      await writeData('userid', authResponse.value?.userid ?? '');

      GoRouter.of(context).push(AppRoutes.dashboard);

    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
