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
import 'package:wti_vendor_dashboard/common_widgets/buttons/tertiary_button.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/editable_image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/loader/loader.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/edit_form_field/edit_form_field.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/search_form/search_input_field.dart';
import 'package:wti_vendor_dashboard/core/controller/driver/fetch_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/update_driver_controller/update_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle/update_vehicle_controller.dart';
import 'package:wti_vendor_dashboard/core/model/perticular_driver/perticular_driver_response.dart';

import '../../common_widgets/dropdown/dropdown_input_field.dart';
import '../../core/controller/pair_vehicle/pair_vehicle_list.dart';
import '../../core/controller/perticular_vehicle_detail/perticular_vehicle_detail_controller.dart';
import '../../core/controller/upload_driver_document/upload_driver_document_controller.dart';
import '../../core/controller/vacant_n_verified_driver/vacant_n_verified_driver_controller.dart';
import '../../core/model/pair_vehicle/pair_vehicle_list_response.dart';
import '../../core/model/vacant_n_verified_driver_response.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class PairVehicle extends StatefulWidget {
  const PairVehicle({super.key});

  @override
  State<PairVehicle> createState() => _PairVehicleState();
}

class _PairVehicleState extends State<PairVehicle>
    with SingleTickerProviderStateMixin {
  String? _selectedValue;
  final List<String> tabNames = ['All', 'Pending', 'Verify', 'Reject'];
  String status = 'All'; // Initialize with the first tab

  final List<String> _options = ['VehicleNumber'];
  late TabController _tabController;

  final TextEditingController vehicleController = TextEditingController();
  final PairVehicleListController fetchVehicleController =
  Get.put(PairVehicleListController());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Pair Vehicle",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card(
              //   color: Colors.white,
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: Row(
              //       children: [
              //         Flexible(
              //           child: DropdownButtonFormField<String>(
              //             autofocus: false,
              //             focusColor: AppColors.borderColor1,
              //             decoration: InputDecoration(
              //               labelText: 'Selected For',
              //               labelStyle: const TextStyle(color: Colors.black),
              //               border: OutlineInputBorder(
              //                 borderSide: const BorderSide(
              //                   color: AppColors.borderColor1,
              //                 ),
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(12),
              //                 borderSide: const BorderSide(
              //                   color: Colors.grey,
              //                   width: 1,
              //                 ),
              //               ),
              //               contentPadding: const EdgeInsets.symmetric(
              //                   horizontal: 12, vertical: 16),
              //             ),
              //             dropdownColor: Colors.white,
              //             value: _selectedValue,
              //             items: _options.map((String value) {
              //               return DropdownMenuItem<String>(
              //                 value: value,
              //                 child: Text(
              //                   value,
              //                   style: const TextStyle(color: Colors.black),
              //                 ),
              //               );
              //             }).toList(),
              //             onChanged: (String? newValue) {
              //               setState(() {
              //                 _selectedValue = newValue;
              //               });
              //               if (newValue != null && newValue.isNotEmpty) {
              //                 fetchVehicleController.fetchVehicle(
              //                   newValue,
              //                   vehicleController.text,
              //                   status,
              //                   context,
              //                 );
              //               }
              //               print('Selected: $newValue');
              //             },
              //           ),
              //         ),
              //         const SizedBox(width: 8),
              //         SizedBox(
              //           width: 150,
              //           child: SearchInputField(
              //             controller: vehicleController,
              //             hintText: 'Search...',
              //             onChanged: _onSearchChanged, // Use debounced search
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

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
  final PairVehicleListController fetchvehicleController =
  Get.put(PairVehicleListController());

  final PerticularVehicleDetailController perticularVehicleDetailController =
  Get.put(PerticularVehicleDetailController());

  final UpdateVehicleController updateVehicleController =
  Get.put(UpdateVehicleController());

  final VacantNVerifiedDriverController vacantNVerifiedDriverController =
  Get.put(VacantNVerifiedDriverController());

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

  void _navigateToVehicleDetails({
    required String activeDriver,
    required String vehicleNumber,
    required String modelType,
    required String driverName,
    required String driverPhone,
    required String fuelType,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailsScreen(
          activeDriver: activeDriver,
          vehicleNumber: vehicleNumber,
          modelType: modelType,
          driverName: driverName,
          driverPhone: driverPhone,
          fuelType: fuelType,
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
          ? const Loader()
          : ListView.builder(
        itemCount: fetchvehicleController
            .pairVehicleListResponse.value?.vehicles.length ??
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
                            fetchvehicleController
                                .pairVehicleListResponse
                                .value
                                ?.vehicles[index]
                                .vehicleNumber ??
                                '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Phone number
                      Text(
                        fetchvehicleController.pairVehicleListResponse
                            .value?.vehicles[index].vehicleCategory ??
                            '',
                        style: CommonFonts.bodyText3,
                      ),
                      const SizedBox(height: 8),
                      // License number (partially masked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgGrey1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Fuel Type. - ${fetchvehicleController.pairVehicleListResponse.value?.vehicles[index].fuelType ?? ''}',
                          style: CommonFonts.bodyText3,
                        ),
                      ),
                    ],
                  ),
                  // Right side: More options icon
                  GestureDetector(
                    onTap: () {
                      final vehicleItem = fetchvehicleController
                          .pairVehicleListResponse.value?.vehicles[index];

                      final vehicle = perticularVehicleDetailController
                          .particularVehicleResponse;
                      final driver = perticularVehicleDetailController
                          .perticularDriver;
                      perticularVehicleDetailController
                          .fetchPerticularVehicle(
                          vehicleItem?.id ?? '', context)
                          .then((value) {
                        perticularVehicleDetailController
                            .fetchPerticularDriver(
                            vehicle.value?.vehicle?.activeDriver ?? '',
                            context)
                            .then((value) {
                          _navigateToVehicleDetails(
                            activeDriver:
                            vehicle.value?.vehicle?.activeDriver ?? '',
                            vehicleNumber:
                            vehicle.value?.vehicle?.vehicleNumber ??
                                '',
                            modelType:
                            vehicle.value?.vehicle?.modelType ?? '',
                            driverName:
                            driver.value?.driver?.driverName ?? '',
                            driverPhone:
                            driver.value?.driver?.mobileNumber ?? '',
                            fuelType:
                            vehicle.value?.vehicle?.fuelType ?? '',
                            context: context,
                          );
                        });
                      });
                    },
                    child: const Icon(
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

class VehicleDetailsScreen extends StatefulWidget {
  final String activeDriver;
  final String vehicleNumber;
  final String modelType;
  final String driverName;
  final String driverPhone;
  final String fuelType;

  const VehicleDetailsScreen({
    super.key,
    required this.activeDriver,
    required this.vehicleNumber,
    required this.modelType,
    required this.driverName,
    required this.driverPhone,
    required this.fuelType,
  });

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late String currentActiveDriver;
  late String currentDriverName;
  late String currentDriverPhone;
  bool showDriverError = false; // Track validation error for dropdown

  @override
  void initState() {
    super.initState();
    // Initialize with widget values
    currentActiveDriver = widget.activeDriver;
    currentDriverName = widget.driverName;
    currentDriverPhone = widget.driverPhone;

    // Fetch vacant drivers on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<VacantNVerifiedDriverController>();
      controller.fetchVacantDriver(currentActiveDriver, context);
    });
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Flexible(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final VacantNVerifiedDriverController vacantNVerifiedDriverController =
    Get.find<VacantNVerifiedDriverController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Vehicle & Driver Details",
          style: CommonFonts.appBarText,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  child: TertiaryButton(
                    text: 'Pair Driver',
                    onPressed: () async {
                      vacantNVerifiedDriverController.selectedDriverId.value = '';
                      await vacantNVerifiedDriverController.fetchVacantDriver(
                          currentActiveDriver, context);
                      setState(() {
                        showDriverError = false; // Reset error on new fetch
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final controller = vacantNVerifiedDriverController;
                  final drivers = controller.filteredDrivers;

                  print(
                      'Dropdown drivers: ${drivers.map((d) => {"id": d.id, "name": d.driverName}).toList()}');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<String>(
                          hint: const Text("Select Driver"),
                          value: controller.selectedDriverId.value.isNotEmpty &&
                              drivers.any((driver) =>
                              driver.id == controller.selectedDriverId.value)
                              ? controller.selectedDriverId.value
                              : null,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Select Driver',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            errorText: showDriverError
                                ? 'Please select a driver'
                                : null, // Show error if validation fails
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null &&
                                drivers.any((driver) => driver.id == newValue)) {
                              controller.selectedDriverId.value = newValue;
                              setState(() {
                                showDriverError = false; // Hide error on valid selection
                              });
                            }
                          },
                          items: drivers.isNotEmpty
                              ? drivers.map((driver) {
                            return DropdownMenuItem<String>(
                              value: driver.id,
                              child: Text(driver.driverName ?? 'Unnamed Driver'),
                            );
                          }).toList()
                              : [
                            const DropdownMenuItem<String>(
                              value: null,
                              enabled: false,
                              child: Text('No drivers available'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: PrimaryButton(
                    text: 'Set Active Driver',
                  // Disable if no driver selected
                    onPressed: () {
                      final controller = vacantNVerifiedDriverController;
                      if (controller.selectedDriverId.value.isNotEmpty) {
                        // Find the selected driver
                        final selectedDriver = controller.filteredDrivers.firstWhere(
                              (driver) => driver.id == controller.selectedDriverId.value,
                          orElse: () => VacantDriver(id: '', driverName: ''),
                        );

                        // Update active driver details
                        setState(() {
                          currentActiveDriver = controller.selectedDriverId.value;
                          currentDriverName = selectedDriver.driverName ?? 'N/A';
                          currentDriverPhone = ''; // Phone not available in VacantDriver
                          showDriverError = false; // Reset error on success
                        });

                        // Refetch vacant drivers with new active driver
                        controller.fetchVacantDriver(currentActiveDriver, context);
                        GoRouter.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 500),
                            content: Text(
                              'Assigned Driver Successfully',
                              style: CommonFonts.primaryButtonText,
                            ),
                            backgroundColor: Colors.green[300],
                          ),
                        );
                      } else {
                        setState(() {
                          showDriverError = true; // Show error if no driver selected
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(milliseconds: 500),
                            content: Text(
                              'Please select a driver',
                              style: CommonFonts.primaryButtonText,
                            ),
                            backgroundColor: Colors.red[300],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Vehicle & Active Driver Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Vehicle Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _infoRow('Vehicle Number', widget.vehicleNumber),
                        _infoRow('Model Type', widget.modelType),
                        _infoRow('Fuel Type', widget.fuelType),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Active Driver Details',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _infoRow('Driver ID', currentActiveDriver),
                        _infoRow('Driver Name', currentDriverName),
                        _infoRow('Driver Phone', currentDriverPhone),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}// pending
Widget pending() {
  return Container(
    padding: const EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      color: Colors.blue[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Text(
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
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.green[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Text(
      'Verify',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}

// rejected
Widget highlight(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.red[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}