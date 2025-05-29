import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/add_driver/add_driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/driver/driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../../utility/constants/fonts/common_fonts.dart';
import '../../api/api_services.dart';
import '../../model/update_driver_doc_responce/update_driver_doc_response.dart';

// Update with the correct path

class AddDriverController extends GetxController {
  var addDriverResponse = Rxn<AddDriverResponse>(); // Holds API response
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

  Future<void> addDriverDetails(String driverName, String mobileNo, String dob, String driverPhoto, String licenseIdNumber, String licensePhotoFront, String licensePhotoBack, String licenseExpiryDate, String idProofType, String idproofFrontPhoto, String idproofBackPhoto, String pccPhoto, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');


      Map<String, dynamic> requestData = {
        "VendorId": vendorId,
        "DriverName": driverName,
        "MobileNumber": mobileNo,
        "DoB": dob,
        "Driverphoto": 'http://65.2.66.230:4000/0auth/aws/image/vendorDriverDocument/$driverPhoto',
        "LicenseIdNumber": licenseIdNumber,
        "LicensePhotoFront": "http://65.2.66.230:4000/0auth/aws/image/vendorDriverDocument/$licensePhotoFront",
        "LicensePhotoBack": "http://65.2.66.230:4000/0auth/aws/image/vendorDriverDocument/$licensePhotoBack",
        "LicenseExpiryDate": licenseExpiryDate,
        "Idprooftype": idProofType,
        "IdproofFrontPhoto": "http://65.2.66.230:4000/0auth/aws/image/vendorDriverDocument/$idproofFrontPhoto",
        "IdproofBackPhoto": "http://65.2.66.230:4000/0auth/aws/image/vendorDriverDocument/$idproofBackPhoto",
        "pccPhoto": "http://65.2.66.230:4000/0auth/aws/image/vendorDriverDocument/$pccPhoto"
      };

      print('request data is : $requestData');

      final responseData = await apiService.postRequest(
        'Driver/AddDriver',
        requestData,
        context
      );

      // Parse response into BookingResponse model
      addDriverResponse.value = AddDriverResponse.fromJson(responseData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text('Driver Added Successfully', style: CommonFonts.primaryButtonText),
          backgroundColor: Colors.green[300],
        ),
      );
      Future.delayed(Duration(seconds: 2));
      GoRouter.of(context).push(AppRoutes.driverBottomNavigation);
    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
