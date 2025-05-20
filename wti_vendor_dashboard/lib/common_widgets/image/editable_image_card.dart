import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';

class EditableImageCard extends StatefulWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onEdit;
  final String imageKey;

  const EditableImageCard({
    super.key,
    required this.imageUrl,
    required this.onEdit,
    required this.label,
    required this.imageKey,
  });

  @override
  State<EditableImageCard> createState() => _EditableImageCardState();
}

class _EditableImageCardState extends State<EditableImageCard> {
  final UploadDriverDocumentController uploadDriverDocumentController =
      Get.put(UploadDriverDocumentController());
  bool _isEditable = false;
  File? _selectedImage;

  void _toggleEdit() {
    setState(() {
      _isEditable = !_isEditable;
    });
   // if(uploadDriverDocumentController.isUploading.value == true) {
   //
   // }
  }

  Future<String?> readData(String key) async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Show bottom sheet for user choice
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
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        uploadDriverDocumentController.isUploading.value = true;

        await uploadDriverDocumentController
            .uploadImage(_selectedImage!, widget.imageKey)
            .then((value) async {});
        uploadDriverDocumentController.isUploading.value = false;

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            if (_isEditable)
              (uploadDriverDocumentController.isUploading.value)
                  ? Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  )
                  : Expanded(
                      child: InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.upload_file,
                                  size: 30, color: Colors.blueGrey),
                              SizedBox(height: 12),
                              Text(
                                'Upload Image',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
            else
              Expanded(
                child: _selectedImage == null
                    ? Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.imageUrl,
                            width: 240,
                            height: 140,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 140,
                              color: Colors.grey[300],
                              child:
                                  Center(child: Text('Failed to load image')),
                            ),
                          ),
                        ),
                      )
                    : Obx(() {
                        print(
                            'Obx rebuilding, isUploading: ${uploadDriverDocumentController.isUploading.value}');
                        if (uploadDriverDocumentController.isUploading.value) {
                          return Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[200]?.withOpacity(
                                  0.8), // Semi-transparent background
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent),
                                strokeWidth: 4, // Thicker stroke for visibility
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
              ),
            const SizedBox(width: 8),
            uploadDriverDocumentController.isUploading.value?
            IconButton(
              icon: Icon(_isEditable ? Icons.cancel : Icons.edit),
              onPressed: (){
                setState(() {
                  uploadDriverDocumentController.isUploading.value = false;
                });
              },
              tooltip: _isEditable ? 'Cancel' : 'Edit',
            ): SizedBox(),
            const SizedBox(width: 8),

            IconButton(
              icon: Icon(_isEditable ? Icons.check : Icons.edit),
              onPressed:  _toggleEdit,
              tooltip: _isEditable ? 'Save' : 'Edit',
            ),
          ],
        ),
      ],
    );
  }
}
