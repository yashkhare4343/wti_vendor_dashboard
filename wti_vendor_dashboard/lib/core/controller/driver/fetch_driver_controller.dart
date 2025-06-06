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

// Update with the correct path

class FetchDriverController extends GetxController {
  var driverResponse = Rxn<DriversResponse>(); // Holds API response
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final Rx<String> tabName = ''.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  RxString localStartTime = "Loading...".obs;
  Rx<String> fileName = ''.obs;
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

  Future<void> fetchDriver(String selectedValued, String searchedText, String tabName, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');


      Map<String, dynamic> requestData = {
        "vendorId": vendorId,
        selectedValued.isEmpty? "undefined": "DriverName" : searchedText,
        "RegisterStatus": tabName,
        if(tabName == 'Verified') "RegisterStatus": "Verify"
      };

      print('request data is : $requestData');

      final responseData = await apiService.postRequest(
          'Driver/AllDriverbyVendorId/1',
          requestData,
          context
      );

      // Parse response into BookingResponse model
      driverResponse.value = DriversResponse.fromJson(responseData);

      // mostly using in tracking event
      // for(int i = 0; i < driverResponse.value!.drivers.length;i++){
      //   await writeData('driverPhotograph', driverResponse.value?.drivers[i].driverPhoto??'');
      //
      // }
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
