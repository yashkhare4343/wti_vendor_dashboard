import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle/add_vehicle_controller.dart';

import '../../common_widgets/buttons/primary_button.dart';
import '../../common_widgets/dropdown/dropdown_input_field.dart';
import '../../common_widgets/image/image_card.dart';
import '../../common_widgets/image/upload_image_card.dart';
import '../../common_widgets/textformfield/border_form_field/edit_form_field.dart';
import '../../common_widgets/textformfield/edit_form_field/edit_form_field.dart';
import '../../core/controller/upload_driver_document/upload_driver_document_controller.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController vehicleNo = TextEditingController();
  final TextEditingController insuranceValid =
  TextEditingController();
  final TextEditingController registerationDateController =
  TextEditingController();
  final TextEditingController vehicleCategory =
  TextEditingController();
  final TextEditingController brand =
  TextEditingController();
  final TextEditingController modelType =
  TextEditingController();
  final TextEditingController fuelType =
  TextEditingController();
  final TextEditingController vehicleOwnerShip =
  TextEditingController();

  final UploadDriverDocumentController uploadDriverDocumentController =
  Get.put(UploadDriverDocumentController());

  final AddVehicleController addVehicleController = Get.put(AddVehicleController());


  final GlobalKey<FormFieldState<File?>> carNoKey =
  GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> insuranceCopyKey  =
  GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> registerCertificateFront =
  GlobalKey<FormFieldState<File?>>();
  final GlobalKey<FormFieldState<File?>> registerCertificateBack =
  GlobalKey<FormFieldState<File?>>();


  Future<String?> readData(String key) async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return await secureStorage.read(key: key);
    }
  }

  Future<void> clearSpecificKeys(List<String> keys) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      for (String key in keys) {
        await prefs.remove(key);
      }
    } else {
      final secureStorage = FlutterSecureStorage();
      for (String key in keys) {
        await secureStorage.delete(key: key);
      }
    }

    print("✅ Selected keys cleared from local storage");
  }

  final List<String> _fuelOptions = ['CNG', 'PETROL', 'DIESEL', 'ELECTRIC'];
  String selectedFuelValue = 'CNG';

  final List<String> _vehicleCategory = ['Sedan', 'SUV', 'hatchback'];
  String selectedVehicleCategory = 'Sedan';


  final List<String> _brandOption = ['Maruti', 'Hyundai', 'Honda', 'Toyota', 'KIA', 'Tata', 'BYD', 'MG'];
  String selectedbrand = 'Maruti';

  final List<String> _vehicleOwnerShip = ['Own', 'Lease'];
  String selectedVehicleOwner ='Own';

  final List<String> _modelOptions = ['Xcent', 'Aura', 'i10', 'i20'];
  String selectedModel ='Xcent';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Vehicles",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(key: formKey, child: SingleChildScrollView(
          child: Column(
            children: [
              /// Drag handle
              BorderFormField(
                label: 'Vehicle Number',
                controller: vehicleNo,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vehicle number is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Id Proof',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownInputField(
                    value: selectedVehicleCategory,
                    items: _vehicleCategory,
                    labelText: '',
                    hintText: 'Select Id Proof Type',
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVehicleCategory = newValue??'';
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
              SizedBox(height: 16),
              DropdownInputField(
                value: selectedbrand,
                items: _brandOption,
                labelText: 'Brand',
                hintText: 'Brand',
                onChanged: (String? newValue) {
                  setState(() {
                    selectedbrand = newValue??'';
                  });
                  print('Selected: $newValue');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a brand';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
            DropdownInputField(
              value: selectedModel,
              items: _modelOptions,
              labelText: 'Model type',
              hintText: 'Model type',
              onChanged: (String? newValue) {
                setState(() {
                  selectedModel = newValue??'';
                });
                print('Selected: $newValue');
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a model type';
                }
                return null;
              },
            ),
              SizedBox(height: 16),
              DropdownInputField(
                value: selectedFuelValue??'',
                items: _fuelOptions,
                labelText: 'Fuel Type',
                hintText: 'Fuel Type',
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFuelValue = newValue??'';
                  });
                  print('Selected: $newValue');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a fuel type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownInputField(
                value: selectedVehicleOwner??'',
                items: _vehicleOwnerShip,
                labelText: 'Vehicle OwnerShip',
                hintText: 'Vehicle OwnerShip',
                onChanged: (String? newValue) {
                  setState(() {
                    selectedVehicleOwner = newValue??'';
                  });
                  print('Selected: $newValue');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vehicle category type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: insuranceValid,
                      decoration: InputDecoration(
                        labelText: 'Insurance valid upto',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final DateTime? picked =
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          insuranceValid.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              UploadImageCard(
                label: 'Insurance Copy',
                imageKey: 'insurenceCopy',
                key: insuranceCopyKey,
              ),
              SizedBox(height: 16),

              UploadImageCard(
                label: 'Register Certificate Front',
                imageKey: 'registerCertificateFront',
                key: registerCertificateFront,
              ),
              SizedBox(height: 16),
              UploadImageCard(
                label: 'Register Certificate Back',
                imageKey: 'registerCertificateBack',
                key: registerCertificateBack,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: registerationDateController,
                      decoration: InputDecoration(
                        labelText: 'Registration Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final DateTime? picked =
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          registerationDateController.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              UploadImageCard(
                label: 'Car Number Photo',
                imageKey: 'carNoPhoto',
                key: carNoKey,
              ),
              SizedBox(height: 16),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Submit',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Access the selected image files via keys
                      final File? insurenceCopy = insuranceCopyKey.currentState?.value;
                      final File? registerCertificateF = registerCertificateFront.currentState?.value;
                      final File? registerCertificateB = registerCertificateBack.currentState?.value;
                      final File? carNoPhoto = carNoKey.currentState?.value;

                      // You can decide whether to read stored data or use current selection here.
                      // Example: Use selected images if available, else fallback to stored data:
                      final String insurancePicPath =
                          insurenceCopy?.path ?? '';
                      final String registerCertificatFPath =
                          registerCertificateF?.path ??  '';
                      final String registerCertificateBPath =
                          registerCertificateB?.path ??  '';
                      final String carNoPicPath =
                          carNoPhoto?.path ??  '';

                      addVehicleController.addVehicleDetails(vehicleNo.text.trim(), selectedbrand??'', selectedFuelValue??'', insuranceValid.text.trim(), registerationDateController.text.trim(), carNoPicPath, selectedVehicleCategory, selectedModel, selectedVehicleOwner, insurancePicPath, registerCertificatFPath, registerCertificateBPath, context);


                    }                  },
                ),
              )
            ],
          ),
        )),
      )),
    );
  }
}
