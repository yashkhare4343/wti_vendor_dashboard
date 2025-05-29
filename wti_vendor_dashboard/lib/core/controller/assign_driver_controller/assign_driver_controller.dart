import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/active_driver/active_driver_model.dart';
import 'package:wti_vendor_dashboard/core/model/assign_driver_response/assign_driver_model.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle_list/vehicle_list_response.dart';
import '../../../utility/constants/fonts/common_fonts.dart';
import '../../api/api_services.dart';
import '../../model/driver_details/driver_details_response.dart';

class AssignDriverController extends GetxController {
  var assignDriverModel = Rxn<AssignDriverModel>();
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

  Future<void> submitAssignDriver(String bookingId, String vehicleId, String driverId, String name, String registernumber,String vehicletype, String partnername,String mobilenumber,  BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();

      Map<String, dynamic> requestData = {
          "bookingId": bookingId,
          "vehicleId": vehicleId,
          "driverId": driverId,
          "name": name,
          "registernumber": registernumber,
          "vehicletype": vehicletype,
          "partnername": partnername,
          "mobilenumber": mobilenumber
      };

      print('request data is : $requestData');

      final responseData = await apiService.postRequest(
          'ReservationMMt/AssigVehicleNumberandDriverNametoReservation',
          requestData,
          context
      );


      // Parse response into BookingResponse model
      assignDriverModel.value = AssignDriverModel.fromJson(responseData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text('Assigned Driver Successfully', style: CommonFonts.primaryButtonText),
          backgroundColor: Colors.green[300],
        ),
      );
      print('response is: ${assignDriverModel.value?.toJson()}');
    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }


}
