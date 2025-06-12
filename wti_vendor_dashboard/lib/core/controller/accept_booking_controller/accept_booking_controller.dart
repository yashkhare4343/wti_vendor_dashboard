import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/accept_booking_response/accept_booking_response.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../api/api_services.dart';

// Update with the correct path

class AcceptBookingController extends GetxController {
  var acceptBookingResponse = Rxn<AcceptBookingResponse>(); // Holds API response
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

  Future<void> clearSpecificKeys(List<String> keys) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      for (String key in keys) {
        await prefs.remove(key);
      }
    } else {
      final secureStorage = FlutterSecureStorage();
      for (String key in keys) {
        await secureStorage.delete(key: key);
      }
    }

    print("✅ Selected keys cleared from local storage");
  }

  Future<void> verifyAcceptBooking(String bookingId, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');


      Map<String, dynamic> requestData = {
        "vendorId": vendorId,
        "bookingid": bookingId
      };

      print('request data is : $requestData');

      final responseData = await apiService.postRequest(
          'flashRouter/acceptBookingFlash',
          requestData,
          context
      );

      // Parse response into BookingResponse model
      acceptBookingResponse.value = AcceptBookingResponse.fromJson(responseData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking Accepted Successfully"), backgroundColor: Colors.green,),
      );
      GoRouter.of(context).push(AppRoutes.allBooking);


      // mostly using in tracking event

    } catch (error) {
      print("Error fetching booking data: $error");
      errorMessage.value = error.toString();
      GoRouter.of(context).push(AppRoutes.dashboard);
    } finally {
      isLoading.value = false;
    }
  }
}
