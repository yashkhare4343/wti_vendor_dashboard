import 'dart:async'; // For debouncing
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/main.dart';
import 'package:wti_vendor_dashboard/common_widgets/buttons/primary_button.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/editable_image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/loader/loader.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/edit_form_field/edit_form_field.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/search_form/search_input_field.dart';
import 'package:wti_vendor_dashboard/core/controller/driver/fetch_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/update_driver_controller/update_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle/fetch_vehicle_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle/update_vehicle_controller.dart';

import '../../common_widgets/dropdown/dropdown_input_field.dart';
import '../../core/controller/upload_driver_document/upload_driver_document_controller.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class AllVehicle extends StatefulWidget {
  const AllVehicle({super.key});

  @override
  State<AllVehicle> createState() => _AllVehicleState();
}

class _AllVehicleState extends State<AllVehicle>
    with SingleTickerProviderStateMixin {
  String? _selectedValue;
  final List<String> tabNames = ['All', 'Pending', 'Verify', 'Reject'];
  String status = 'All'; // Initialize with the first tab

  final List<String> _options = ['VehicleNumber'];
  late TabController _tabController;

  final TextEditingController vehicleController = TextEditingController();
  final FetchVehicleController fetchVehicleController =
      Get.put(FetchVehicleController());
  Timer? _debounce; // For debouncing search

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabNames.length, vsync: this);

    // Update status immediately when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          status = tabNames[_tabController.index];
        });
        // Trigger fetch with updated status
        if (_selectedValue != null && _selectedValue!.isNotEmpty) {
          fetchVehicleController.fetchVehicle(
            _selectedValue!,
            vehicleController.text,
            status,
            context,
          );
        }
        print('Selected tab: ${tabNames[_tabController.index]}');
      }
    });

    // Initial fetch
    fetchVehicleController.fetchVehicle(
        _selectedValue ?? '', vehicleController.text, status, context);
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce timer
    _tabController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  // Debounce function for search
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_selectedValue != null && _selectedValue!.isNotEmpty) {
        fetchVehicleController.fetchVehicle(
            _selectedValue!, value, status, context);
      }
    });
  }

  // pending bottom sheet

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgPrimary1,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "All Vehicles",
            style: CommonFonts.appBarText,
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// TabBar (with custom underline)
                TabBar(
                  controller: _tabController,
                  indicator: CustomTabIndicator(),
                  labelColor: AppColors.blueAccent,
                  unselectedLabelColor: Colors.black.withOpacity(0.8),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: tabNames.map((name) => Tab(text: name)).toList(),
                ),

                const SizedBox(height: 12),

                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: DropdownButtonFormField<String>(
                            autofocus: false,
                            focusColor: AppColors.borderColor1,
                            decoration: InputDecoration(
                              labelText: 'Selected For',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderColor1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                            ),
                            dropdownColor: Colors.white,
                            value: _selectedValue,
                            items: _options.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedValue = newValue;
                              });
                              if (newValue != null && newValue.isNotEmpty) {
                                fetchVehicleController.fetchVehicle(
                                  newValue,
                                  vehicleController.text,
                                  status,
                                  context,
                                );
                              }
                              print('Selected: $newValue');
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 150,
                          child: SearchInputField(
                            controller: vehicleController,
                            hintText: 'Search...',
                            onChanged: _onSearchChanged, // Use debounced search
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// TabBarView must be wrapped in Expanded
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: tabNames.map((tabName) {
                      return VehicleList(
                        selectedValued: _selectedValue ?? '',
                        searchedText: vehicleController.text,
                        status: status,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = AppColors.blueAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double tabWidth = configuration.size!.width;
    final double xCenter = offset.dx + tabWidth / 2;
    final double yBottom = offset.dy + configuration.size!.height;

    final double lineWidth = 95.0;
    final double halfLineWidth = lineWidth / 2;

    canvas.drawLine(
      Offset(xCenter - halfLineWidth, yBottom),
      Offset(xCenter + halfLineWidth, yBottom),
      paint,
    );
  }
}

class VehicleList extends StatefulWidget {
  final String selectedValued;
  final String searchedText;
  final String status;
  final void Function()? onTap;

  const VehicleList({
    super.key,
    required this.selectedValued,
    required this.searchedText,
    required this.status,
    this.onTap,
  });

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  final FetchVehicleController fetchvehicleController =
      Get.put(FetchVehicleController());

  final UpdateVehicleController updateVehicleController = Get.put(UpdateVehicleController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchvehicleController.fetchVehicle(
            widget.selectedValued, widget.searchedText, widget.status, context);
      }
    });
  }


  void _vehicleDetailsBottomSheet(
      BuildContext context,
      String vehicleNumber,
      String carNophoto,
      String brand,
      String insurencePhoto,
      String fuelType,
      String registerFrontLink,
      String insuranceValidUpto,
      String registerBackLink,
      String registrationDate,
      String leaseCertificate,
      String category,
      String modelType,
      String vehicleOwnerShip,
      String status,
      String message,
      ) {
    final TextEditingController vehicleNo = TextEditingController(text: vehicleNumber);
    final TextEditingController insuranceValid =
        TextEditingController(text: insuranceValidUpto);
    final TextEditingController registerationDateController =
        TextEditingController(text: registrationDate);

    final UploadDriverDocumentController uploadDriverDocumentController =
        Get.put(UploadDriverDocumentController());

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

    final List<String> _fuelOptions = ['CNG', 'PETROL'];
    String? _selectedFuelValue = fuelType;

    final List<String> _vehicleCategoryOptions = ['SUV', 'Sedan'];
    String? _selectedVehicleCategoryValue = category;

    showModalBottomSheet(
      backgroundColor: AppColors.scaffoldBgPrimary,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.7, // slightly more space
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
          ),
          child: Form(
            key: formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          /// Drag handle
                          Container(
                            height: 5,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: AppColors.greyText1,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            margin: EdgeInsets.only(bottom: 16),
                          ),

                          EditFormField(
                            label: 'Vehicle Number',
                            controller: vehicleNo,
                            onChanged: (value) {},
                            status: status,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vehicle number is required';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          status == 'Verify' ? ImageCard(imageUrl: carNophoto, label: 'Car Number Photo') : EditableImageCard(
                            label: 'Car Number Photo',
                            imageUrl: carNophoto,
                            onEdit: () {},
                            imageKey: 'carNophoto',
                          ),

                          SizedBox(height: 16),

                          status =='Verify'? ImageCard(imageUrl: insurencePhoto, label: 'Insurance Photo') : EditableImageCard(
                            label: 'Insurance Photo',
                            imageUrl: insurencePhoto,
                            onEdit: () {},
                            imageKey: 'insurancePhoto',
                          ),

                          SizedBox(height: 16),

                          status == 'Verify' ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Fuel Option',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(fuelType, textAlign: TextAlign.start),
                            ],
                          ) :   DropdownInputField(
                            value: _selectedFuelValue??'',
                            items: _fuelOptions,
                            labelText: 'Fuel Option',
                            hintText: 'Select Fuel Type',
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFuelValue = newValue;
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

                          status == 'Verify' ? ImageCard(imageUrl: registerBackLink, label: 'Register Certificate Back Link') : EditableImageCard(
                            label: 'Register Certificate Back Link',
                            imageUrl: registerBackLink,
                            onEdit: () {},
                            imageKey: 'registerBackLink',
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
                          status =='Verify'? ImageCard(imageUrl: leaseCertificate, label: 'Lease Certificate') :  EditableImageCard(
                            label: 'Lease Certificate',
                            imageUrl: leaseCertificate,
                            onEdit: () {},
                            imageKey: 'leaseCertificate',
                          ),
                          SizedBox(height: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Driver Register Status',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('Pending', textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),

                          status == 'Verify' ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Select Vehicle Category',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(category, textAlign: TextAlign.start),
                            ],
                          ) : DropdownInputField(
                            value: _selectedVehicleCategoryValue??'',
                            items: _vehicleCategoryOptions,
                            labelText: 'Select Vehicle Category',
                            hintText: 'Select Vehicle Category',
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedVehicleCategoryValue = newValue;
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Brand',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(brand, textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Model Type',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(modelType, textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Vehicle Owner Ship',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('Own', textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Driver Register Status',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(status, textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Message',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('', textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 24),

                          Spacer(),

                          /// Submit Button
                         status =='Verify'? SizedBox() : SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'Submit',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  // Check each image key and decide whether to use uploaded or fetched image
                                  final carNumberPhoto =
                                      await readData('carNophoto') ??
                                          carNophoto;

                                  final insurencePhoto =
                                      await readData('carNophoto') ??
                                          carNophoto;

                                  final carBrand =
                                      await readData('brand') ??
                                          brand;

                                  final registerCertificateFront =
                                      await readData('registerFrontLink') ??
                                          registerFrontLink;

                                  final registerCertificateBack =
                                      await readData('registerBackLink') ??
                                          registerBackLink;

                                  final carleaseCertificate =
                                      await readData('leaseCertificate') ??
                                          leaseCertificate;

                                  await updateVehicleController.updateVehicleDetails(vehicleNumber, carNumberPhoto, carBrand, insurencePhoto, _selectedFuelValue??'', registerCertificateFront, insuranceValidUpto, registerCertificateBack, registrationDate, carleaseCertificate, _selectedVehicleCategoryValue??'', modelType, message, vehicleOwnerShip, status, '', context)
                                .then((value) {
                                    fetchvehicleController.fetchVehicle(
                                        '', '', status, context).then((value) async{
                                      await clearSpecificKeys([
                                        'carNophoto',
                                        'brand',
                                        'insurancePhoto',
                                        'registerFrontLink',
                                        'registerBackLink',
                                        'leaseCertificate',
                                      ]);
                                    });
                                  }).then((value){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 500),
                                        content: Text('Driver Added Successfully', style: CommonFonts.primaryButtonText),
                                        backgroundColor: Colors.green[300],
                                      ),
                                    );
                                  });
                                  Future.delayed(Duration(seconds: 1));

                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant VehicleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.selectedValued != widget.selectedValued ||
        oldWidget.searchedText != widget.searchedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          fetchvehicleController.fetchVehicle(widget.selectedValued,
              widget.searchedText, widget.status, context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return fetchvehicleController.isLoading.value == true
          ? Loader()
          : ListView.builder(
              itemCount:
                  fetchvehicleController.vehicleResponse.value?.vehicles.length ??
                      0,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side: Name, verification, phone, and license
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and verification badge
                            Row(
                              children: [
                                Text(
                                  fetchvehicleController.vehicleResponse.value
                                          ?.vehicles[index].vehicleNumber ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                widget.status == 'Pending'?  Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  child: pending(),
                                ): widget.status == 'Verify'? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  child: verify(),
                                ): Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  child: reject(),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            // Phone number
                            Text(
                              fetchvehicleController.vehicleResponse.value
                                      ?.vehicles[index].vehicleCategory ??
                                  '',
                              style: CommonFonts.bodyText3,
                            ),
                            SizedBox(height: 8),
                            // License number (partially masked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.bgGrey1,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Fuel Type. - ${fetchvehicleController.vehicleResponse.value?.vehicles[index].fuelType ?? ''}',
                                style: CommonFonts.bodyText3,
                              ),
                            ),
                          ],
                        ),
                        // Right side: More options icon
                        GestureDetector(
                          onTap: (){
                            final vehicle = fetchvehicleController.vehicleResponse.value?.vehicles[index];
                            _vehicleDetailsBottomSheet(context, vehicle?.vehicleNumber??'', vehicle?.carNumberPhoto??'', vehicle?.brand??'', vehicle?.insurancePhoto??'', vehicle?.fuelType??'', vehicle?.registercertificateFrontLink??'', vehicle?.insuranceValidUpto??'', vehicle?.registercertificateBackLink??'', vehicle?.registerationDate??'', vehicle?.leasecertificate??'', vehicle?.vehicleCategory??'', vehicle?.modelType??'', vehicle?.vehicleOwnership??'', widget.status, vehicle?.message??'');
                          },
                          // onTap: () {
                          //   _vehicleDetailsBottomSheet(
                          //       context,
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].driverName ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].mobileNumber ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].licenseIdNumber ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].dob ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].driverPhoto ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].licensePhotoFront ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].licensePhotoBack ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].licenseExpiryDate ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].idProofFrontPhoto ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value
                          //               ?.drivers[index].idProofBackPhoto ??
                          //           '',
                          //       fetchvehicleController.driverResponse.value?.drivers[index].pccPhoto ?? '',
                          //       fetchvehicleController.driverResponse.value?.drivers[index].id ?? '', widget.status);
                          // },
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }
}

// pending
Widget pending() {
  return Container(
    padding: EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      color: Colors.blue[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      'Pending',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}

//verify
Widget verify() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.green[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      'Verify',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}

// rejected

Widget reject() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.red[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      'Reject',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}


