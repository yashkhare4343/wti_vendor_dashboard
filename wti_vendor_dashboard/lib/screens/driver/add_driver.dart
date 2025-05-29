import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/upload_image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/border_form_field/edit_form_field.dart';
import 'package:wti_vendor_dashboard/core/controller/driver/add_driver_controller.dart';

import '../../common_widgets/buttons/primary_button.dart';
import '../../common_widgets/dropdown/dropdown_input_field.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  final TextEditingController driverName = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController licenseExpire = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<File?>> driverPhotoKey =
      GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> licenceFrontKey =
      GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> licenceBackKey =
      GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> idProofFrontKey =
      GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> idProofBackKey =
      GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> pccPhotoKey =
      GlobalKey<FormFieldState<File?>>();

  final List<String> _options = ['Aadhar Card', 'Driving Licence', 'Voter Id'];
  String? _selectedValue;

  final AddDriverController addDriverController =
      Get.put(AddDriverController());

  Future<String?> readData(String key) async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Driver",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                BorderFormField(
                  label: 'Driver Name',
                  controller: driverName,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mobile number is required';
                    }
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                BorderFormField(
                    label: 'Mobile No',
                    controller: mobileNumber,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Mobile number is required';
                      } else if (!RegExp(r'^[0-9]{10}$')
                          .hasMatch(value.trim())) {
                        return 'Enter a valid 10-digit mobile number';
                      }
                    }),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }

                          try {
                            final parts = value.split('/');
                            final day = int.parse(parts[0]);
                            final month = int.parse(parts[1]);
                            final year = int.parse(parts[2]);
                            final birthDate = DateTime(year, month, day);
                            final today = DateTime.now();
                            final age = today.year -
                                birthDate.year -
                                ((today.month < birthDate.month ||
                                        (today.month == birthDate.month &&
                                            today.day < birthDate.day))
                                    ? 1
                                    : 0);

                            if (age < 18) {
                              return 'Age must be at least 18 years';
                            }
                          } catch (e) {
                            return 'Invalid date format';
                          }

                          return null;
                        },
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            dateController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                UploadImageCard(
                  label: 'Driver Photo',
                  imageKey: 'driverPhotograph',
                  key: driverPhotoKey,
                ),
                SizedBox(
                  height: 8,
                ),
                BorderFormField(
                    label: 'License Id Number', controller: licenseNumber,   validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                }
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: licenseExpire,
                          decoration: InputDecoration(
                            labelText: 'Select Date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              licenseExpire.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            }
                          },
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                UploadImageCard(
                  label: 'Licence Front Photo',
                  imageKey: 'driverLicenceFrontKey',
                  key: licenceFrontKey,
                ),
                SizedBox(
                  height: 8,
                ),
                UploadImageCard(
                  label: 'Licence Back Photo',
                  imageKey: 'driverLicenceBackKey',
                  key: licenceBackKey,
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Id Proof',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownInputField(
                      value: _selectedValue,
                      items: _options,
                      labelText: '',
                      hintText: 'Select Id Proof Type',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue = newValue;
                        });
                        print('Selected: $newValue');
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a value';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                UploadImageCard(
                  label: 'IdProof Front Photo',
                  imageKey: 'driverIdproofFront',
                  key: idProofFrontKey,
                ),
                SizedBox(
                  height: 8,
                ),
                UploadImageCard(
                  label: 'IdProof Back Photo',
                  imageKey: 'driverIdproofBack',
                  key: idProofBackKey,
                ),
                SizedBox(
                  height: 8,
                ),
                UploadImageCard(
                  label: 'Pcc',
                  imageKey: 'driverPcc',
                  key: pccPhotoKey,
                ),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Submit',
                    onPressed: () async {
                      // Validate entire form once
                      if (formKey.currentState!.validate()) {
                        // Access the selected image files via keys
                        final File? driverPic = driverPhotoKey.currentState?.value;
                        final File? licencePicFront = licenceFrontKey.currentState?.value;
                        final File? licencePicBack = licenceBackKey.currentState?.value;
                        final File? driverIdProofFrontPic = idProofFrontKey.currentState?.value;
                        final File? driverIdProofBackPic = idProofBackKey.currentState?.value;
                        final File? driverPccPic = pccPhotoKey.currentState?.value;

                        // You can decide whether to read stored data or use current selection here.
                        // Example: Use selected images if available, else fallback to stored data:
                        final String driverPicPath =
                            driverPic?.path ?? (await readData('driverPhotograph')) ?? '';
                        final String licencePicFrontPath =
                            licencePicFront?.path ?? (await readData('driverLicenceFrontKey')) ?? '';
                        final String licencePicBackPath =
                            licencePicBack?.path ?? (await readData('driverLicenceBackKey')) ?? '';
                        final String driverIdProofFrontPicPath =
                            driverIdProofFrontPic?.path ?? (await readData('driverIdproofFront')) ?? '';
                        final String driverIdProofBackPicPath =
                            driverIdProofBackPic?.path ?? (await readData('driverIdproofBack')) ?? '';
                        final String driverPccPicPath =
                            driverPccPic?.path ?? (await readData('driverPcc')) ?? '';

                        // Now call the controller with these paths
                        addDriverController.addDriverDetails(
                          driverName.text.trim(),
                          mobileNumber.text.trim(),
                          dateController.text.trim(),
                          driverPicPath,
                          licenseNumber.text.trim(),
                          licencePicFrontPath,
                          licencePicBackPath,
                          licenseExpire.text.trim(),
                          _selectedValue ?? '',
                          driverIdProofFrontPicPath,
                          driverIdProofBackPicPath,
                          driverPccPicPath,
                          context,
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
