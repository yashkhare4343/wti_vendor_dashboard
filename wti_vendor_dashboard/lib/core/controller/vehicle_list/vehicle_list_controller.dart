import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle_list/vehicle_list_response.dart';
import '../../api/api_services.dart';

class VehicleListController extends GetxController {
  var vehicleListResponse = Rxn<VehicleListResponse>(); // Holds API response
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  RxString localStartTime = "Loading...".obs;
  RxString selectedVehicleId = ''.obs;
  Rx<Vehicle?> selectedVehicle = Rx<Vehicle?>(null);
  // ✅ Add this line

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

  Future<void> fetchVehiclesList(String startTime, String endTime, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');

      Map<String, dynamic> requestData = {
        "vendorid": vendorId,
        "start_time": startTime,
        "end_time": endTime
      };

      print('Fetching vehicle list with: $requestData');

      final responseData = await apiService.postRequest(
        'Vehicle/getVacantAndVerifiedVehicles',
        requestData,
        context
      );

      vehicleListResponse.value = VehicleListResponse.fromJson(responseData);
      print('VehicleList API response: ${vehicleListResponse.value?.toJson()}');

      // Set default vehicle if available
      final firstVehicle = vehicleListResponse.value?.vehicles?.firstOrNull;
      if (firstVehicle != null && selectedVehicleId.value.isEmpty) {
        selectedVehicleId.value = firstVehicle.id ?? '';
      }

    } catch (error) {
      print("Error in updateDriverDetails: $error");
    } finally {
      isLoading.value = false;
    }
  }
}
