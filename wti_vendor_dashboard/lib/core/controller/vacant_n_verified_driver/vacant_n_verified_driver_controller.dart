import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/driver/driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/model/pair_vehicle/set_active_driver/set_active_driver.dart';
import 'package:wti_vendor_dashboard/core/model/perticular_driver/perticular_driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/vacant_n_verified_driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle/vehicle_response_model.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../../utility/constants/fonts/common_fonts.dart';
import '../../api/api_services.dart';

class VacantNVerifiedDriverController extends GetxController {
  var vacantDriverResponse = Rxn<VacantNVerifiedDriverResponse>();
  var setActiveDriver = Rxn<SetActiveDriverResponse>();
  var filteredDrivers = <VacantDriver>[].obs;
  var selectedDriverId = ''.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final Rx<String> tabName = ''.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  RxString localStartTime = "Loading...".obs;
  Rx<String> fileName = ''.obs;

  @override
  void onInit() {
    super.onInit(); // Initialize timezone data
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

  Future<void> fetchVacantDriver(String activeDriver, BuildContext context) async {
    try {
      isLoading.value = true;
      filteredDrivers.clear(); // Clear previous drivers to avoid stale data
      selectedDriverId.value = ''; // Reset selected driver
      final apiService = ApiService();
      final vendorId = await readData('userid');

      // Normalize activeDriver for comparison
      final normalizedActiveDriver = activeDriver?.trim().toLowerCase() ?? '';
      final requestData = {
        "vendorid": vendorId ?? '',
        "ActiveDriver": activeDriver.trim() ?? '',
      };

      print('Request data for fetchVacantDriver: $requestData');

      final responseData = await apiService.postRequest(
        'Driver/getVacantAndVerifiedDrivers',
        requestData,
        context,
      );

      print('API Response: $responseData');

      vacantDriverResponse.value = VacantNVerifiedDriverResponse.fromJson(responseData);

      // Log drivers before filtering
      print('Drivers before filtering: ${vacantDriverResponse.value?.vacantDrivers?.map((d) => {"id": d.id, "name": d.driverName}).toList() ?? []}');

      // Filter drivers, excluding activeDriver
      filteredDrivers.value = vacantDriverResponse.value?.vacantDrivers
          ?.where((driver) =>
      driver.id != null &&
          driver.id!.trim().toLowerCase() != normalizedActiveDriver)
          .toList() ??
          [];

      print('Filtered drivers count: ${filteredDrivers.length}');
      print('Filtered drivers: ${filteredDrivers.map((d) => {"id": d.id, "name": d.driverName}).toList()}');
    } catch (e) {
      print("Error fetching vacant drivers: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setActiveDriverMethod(String vehicleId ,String activeDriver, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      // Normalize activeDriver for comparison
      final requestData = {
        "Vehicleid": vehicleId,
        "Driverid": activeDriver
      };

      print('Request data for set vehicle : $requestData');

      final responseData = await apiService.postRequest(
        'Vehicle/setActiveDriver',
        requestData,
        context,
      );

      print('API Response: $responseData');

      setActiveDriver.value = SetActiveDriverResponse.fromJson(responseData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text('Set Active Driver Successfully', style: CommonFonts.primaryButtonText),
          backgroundColor: Colors.green[300],
        ),
      );

    } catch (e) {
      print("Error fetching vacant drivers: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}