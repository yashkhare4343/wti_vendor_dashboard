import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/booking/all_booking_response.dart';


import '../../api/api_services.dart';

// Update with the correct path

class FetchBookingController extends GetxController {
  var allBookingsResponse = Rxn<AllBookingResponse>(); // Holds API response
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

  Future<void> fetchBooking(String selectedValued, String searchByValue, String searchedDate, String tabName, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');


      Map<String, dynamic> requestData = {
        "vendorId": vendorId,
        "date": searchedDate,
        "page": 1,
        "AlloctedDriverAndVehicle": tabName == 'Assigned'? true : false,
        "limit": 100,
        if (selectedValued == 'Booking Status') 'SearchFor': "BookingStatus",
        if (selectedValued == 'Trip State') 'SearchFor': 'trip_state',
        if (selectedValued == 'Trip Type') 'SearchFor': 'trip_type_details.trip_type',
        if (selectedValued == 'Basic Trip Type') 'SearchFor': 'trip_type_details.trip_type',

        if(selectedValued.isNotEmpty) 'searchby' : searchByValue
      };

      print('request data is : $requestData');

      final responseData = await apiService.postRequest(
          'Vendor/getAllBookingforParticluarVendor',
          requestData,
          context
      );

      // Parse response into BookingResponse model
      allBookingsResponse.value = AllBookingResponse.fromJson(responseData);

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
