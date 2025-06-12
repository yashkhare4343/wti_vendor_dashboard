import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_services.dart';
import '../../model/upload_image/upload_image_response.dart';

class UploadDriverDocumentController extends GetxController{
  var isUploading = false.obs;
  File? _selectedImage;

  Future<void> writeData(String key, String value) async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await secureStorage.write(key: key, value: value);
    }
  }

  Future<UploadImageResponse?> uploadImage(File imageFile, String imageKey) async {
    final ApiService apiService = ApiService();

    try {
      final uploadResponse = await apiService.postMultipart(imageFile);
      if (uploadResponse != null && uploadResponse.fileUploaded) {
        writeData(imageKey, '${uploadResponse.name}');
        print("Image Uploaded Successfully: ${uploadResponse.name}");
        return uploadResponse;
      }

    } catch (e) {
      // print("Image Upload Error: $e");
    }
    return null;
  }


}