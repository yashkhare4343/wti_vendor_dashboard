import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/driver/driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../api/api_services.dart';
import '../../model/update_driver_doc_responce/update_driver_doc_response.dart';

// Update with the correct path

class UpdateDriverDocController extends GetxController {
  var updateDriverResponse = Rxn<UpdateDriverDocResponse>(); // Holds API response
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

  Future<void> updateDriverDetails(String driverName, String mobileNo, String dob, String driverPhoto, String licenseIdNumber, String licensePhotoFront, String licensePhotoBack, String licenseExpiryDate, String idproofFrontPhoto, String idproofBackPhoto, String pccPhoto, String registerStatus, String message, String driverId, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');


      Map<String, dynamic> requestData = {

          "VendorId": vendorId,
          "VehicleId": null,
          "DriverName": driverName,
          "MobileNumber": mobileNo,
          "DoB": dob,
          "Driverphoto": driverPhoto,
          "LicenseIdNumber": licenseIdNumber,
          "LicensePhotoFront": licensePhotoFront,
          "LicensePhotoBack": licensePhotoBack,
          "LicenseExpiryDate": licenseExpiryDate,
          "Idprooftype": "Driver Licence",
          "IdproofFrontPhoto": idproofFrontPhoto,
          "IdproofBackPhoto": idproofBackPhoto,
          "pccPhoto": pccPhoto,
          "DriverStatus": "DutyAssigned",
          "RegisterStatus": registerStatus,
          "message": message,
          "DriverOccupancy": []

      };

      print('request data is : $requestData');

      final responseData = await apiService.putRequest(
          'Driver/updateDriver/$driverId',
          requestData,
      );

      // Parse response into BookingResponse model
      updateDriverResponse.value = UpdateDriverDocResponse.fromJson(responseData);
      print('response is: ${updateDriverResponse.value?.toJson()}');



      // mostly using in tracking event
      // await writeData('userExists', authResponse.value?.userExists.toString()?? '');
      // await writeData('token', authResponse.value?.accessToken ?? '');
      // await writeData('role', authResponse.value?.role ?? '');
      // await writeData('userid', authResponse.value?.userid ?? '');


    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
