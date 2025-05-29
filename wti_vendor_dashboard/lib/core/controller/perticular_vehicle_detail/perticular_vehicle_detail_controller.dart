import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/driver/driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/model/perticular_driver/perticular_driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle/vehicle_response_model.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../api/api_services.dart';
import '../../model/perticular_vehicle/perticular_vehicle_response.dart';


class PerticularVehicleDetailController extends GetxController {
  var particularVehicleResponse = Rxn<ParticularVehicleResponse>();
  var perticularDriver = Rxn<PerticularDriverResponse>();
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

  Future<void> fetchPerticularVehicle(String vehicleId, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();

      final requestData = {"Vehicleid": vehicleId};

      final responseData = await apiService.postRequest(
        'Vehicle/getParticularVehicleDetailByID',
        requestData,
        context,
      );

      print('request data of fetchPerticularVehicle: $requestData');


      particularVehicleResponse.value = ParticularVehicleResponse.fromJson(responseData);
      print("driver fetched: ${particularVehicleResponse.value?.vehicle!.driverId}");

      fetchPerticularDriver(particularVehicleResponse.value!.vehicle!.activeDriver!, context);
    } catch (e) {
      print("Error fetching vehicle: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPerticularDriver(String driverId, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();

      final requestData = {"Driverid": driverId};
      print('request data of fetchPerticularDriver: $requestData');

      final responseData = await apiService.postRequest(
        'Driver/getParticularDriverDetailByID',
        requestData,
        context,
      );


      perticularDriver.value = PerticularDriverResponse.fromJson(responseData);
      print("Driver fetched: ${perticularDriver.value!.driver!.driverName}");
    } catch (e) {
      print("Error fetching driver: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
