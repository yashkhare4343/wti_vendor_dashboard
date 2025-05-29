import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/driver/driver_response.dart';
import 'package:wti_vendor_dashboard/core/model/login_responsed.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle/update_vehicle_response.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../../utility/constants/fonts/common_fonts.dart';
import '../../api/api_services.dart';
import '../../model/update_driver_doc_responce/update_driver_doc_response.dart';

// Update with the correct path

class UpdateVehicleController extends GetxController {
  var updateVehicleResponse = Rxn<UpdateVehicleResponse>(); // Holds API response
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

  Future<void> updateVehicleDetails(String vehicleNo, String carNoPic, String brand, String insurencePic, String fuelType, String registerCertificateFrontlink, String insuranceValidUpto, String registerbacklink, String registrationDate, String leaseCertificate, String vehicleCategory, String modelType, String message, String vehicleOwner, String status, String Message, BuildContext context) async {
    try {
      isLoading.value = true;
      final apiService = ApiService();
      final vendorId = await readData('userid');



      Map<String, dynamic> requestData = {
        "VehicleNumber": vehicleNo,
        "CarNumberPhoto": carNoPic,
        "Brand": brand,
        "FuelType": fuelType,
        "InsuranceValidUpto": insuranceValidUpto,
        "RegisterationDate": registrationDate,
        "CarStatus": "Vacant",
        "RegisterStatus": status,
        "DriverId": null,
        "ActiveDriver": null,
        "DriverArray": [],
        "Leasecertificate": leaseCertificate,
        "InsurancePhoto": insurencePic,
        "RegistercertificateFrontLink": registerCertificateFrontlink,
        "RegistercertificateBackLink":registerbacklink,
        "vehicleCategory": vehicleCategory,
        "ModelType": modelType,
        "VehicleOwnership": vehicleOwner,
        "vehiclecurrentstatus": 1,
        "currentBookingid": "WAV789123",
        "message": ""
      };

      print('request data is : $requestData');

      final responseData = await apiService.putRequest(
        'Vehicle/updateOtherDocumentwithoutLink',
        requestData,
      );

      // Parse response into BookingResponse model
      updateVehicleResponse.value = UpdateVehicleResponse.fromJson(responseData);
      print('response is: ${updateVehicleResponse.value?.toJson()}');


    } catch (error) {
      // print("Error fetching booking data: $error");
      // errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
