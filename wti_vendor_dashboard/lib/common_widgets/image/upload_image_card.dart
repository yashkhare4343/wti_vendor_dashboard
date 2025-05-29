import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';

class UploadImageCard extends StatefulWidget {
  final String label;
  final String imageKey;

  const UploadImageCard({
    required this.label,
    required this.imageKey,
    Key? key,
  }) : super(key: key);

  @override
  State<UploadImageCard> createState() => _UploadImageCardState();
}

class _UploadImageCardState extends State<UploadImageCard> {
  final UploadDriverDocumentController uploadDriverDocumentController =
  Get.put(UploadDriverDocumentController());

  Future<String?> readData(String key) async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  Future<File?> _pickImage(BuildContext context, FormFieldState<File?> field) async {
    final ImagePicker picker = ImagePicker();
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        // Update form field state
        field.didChange(imageFile);

        // Upload image
        uploadDriverDocumentController.isUploading.value = true;
        await uploadDriverDocumentController.uploadImage(imageFile, widget.imageKey);
        uploadDriverDocumentController.isUploading.value = false;

        return imageFile;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File?>(
      validator: (file) {
        if (file == null) {
          return 'Please upload an image';
        }
        return null;
      },
      builder: (FormFieldState<File?> field) {
        final bool hasImage = field.value != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _pickImage(context, field),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[100],
                  border: field.hasError
                      ? Border.all(color: Colors.red)
                      : Border.all(color: Colors.transparent),
                ),
                child: hasImage
                    ? Image.file(field.value!, fit: BoxFit.cover)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload_file, size: 30, color: Colors.blueGrey),
                    SizedBox(height: 12),
                    Text(
                      'Upload Image',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
