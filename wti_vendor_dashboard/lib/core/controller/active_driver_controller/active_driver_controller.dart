import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/active_driver/active_driver_model.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle_list/vehicle_list_response.dart';
import '../../api/api_services.dart';
import '../../model/driver_details/driver_details_response.dart';

class ActiveDriverController extends GetxController {
  var activeDriverModel = Rxn<ActiveDriverModel>();
  var driverDetailsResponse = Rxn<DriverDetailsResponse>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  RxString localStartTime = "Loading...".obs;
  RxString selectedVehicleId = ''.obs; // ✅ Add this line

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

  Future<void> fetchActiveDriver(String vehicleId, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();

      Map<String, dynamic> requestData = {
        "Vehicleid": vehicleId
      };

      print('request data is : $requestData');

      final responseData = await apiService.postRequest(
          'Vehicle/getActiveDriverOfParticularVehicle',
          requestData,
          context
      );


      // Parse response into BookingResponse model
      activeDriverModel.value = ActiveDriverModel.fromJson(responseData);
      String? driverId = activeDriverModel.value?.activeDriver??'';
      print('response is: ${activeDriverModel.value?.toJson()}');

      fetchDriverDetails(driverId, context);

    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDriverDetails(String driverId, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();

      Map<String, dynamic> requestData = {
        "Driverid": driverId
      };

      print('fetch driver request data is : $requestData');

      final responseData = await apiService.postRequest(
          'Driver/getParticularDriverDetailByID',
          requestData,
          context
      );


      // Parse response into BookingResponse model
      driverDetailsResponse.value = DriverDetailsResponse.fromJson(responseData);
      print('fetch driver is: ${driverDetailsResponse.value?.toJson()}');

    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

}
