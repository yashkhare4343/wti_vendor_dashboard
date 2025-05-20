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
import 'package:wti_vendor_dashboard/common_widgets/loader/loader.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/edit_form_field/edit_form_field.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/search_form/search_input_field.dart';
import 'package:wti_vendor_dashboard/core/controller/driver/fetch_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/update_driver_controller/update_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';

import '../../core/controller/upload_driver_document/upload_driver_document_controller.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class AllDriver extends StatefulWidget {
  const AllDriver({super.key});

  @override
  State<AllDriver> createState() => _AllDriverState();
}

class _AllDriverState extends State<AllDriver>
    with SingleTickerProviderStateMixin {
  String? _selectedValue;
  final List<String> tabNames = ['All', 'Pending', 'Verify', 'Reject'];
  String status = 'All'; // Initialize with the first tab

  final List<String> _options = ['Driver Name'];
  late TabController _tabController;

  final TextEditingController driverController = TextEditingController();
  final FetchDriverController fetchDriverController =
      Get.put(FetchDriverController());
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
          fetchDriverController.fetchDriver(
            _selectedValue!,
            driverController.text,
            status,
            context,
          );
        }
        print('Selected tab: ${tabNames[_tabController.index]}');
      }
    });

    // Initial fetch
    fetchDriverController.fetchDriver(
        _selectedValue ?? '', driverController.text, status, context);
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel debounce timer
    _tabController.dispose();
    driverController.dispose();
    super.dispose();
  }

  // Debounce function for search
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_selectedValue != null && _selectedValue!.isNotEmpty) {
        fetchDriverController.fetchDriver(
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
            "All Drivers",
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
                                fetchDriverController.fetchDriver(
                                  newValue,
                                  driverController.text,
                                  status,
                                  context,
                                );
                              }
                              print('Selected: $newValue');
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: SearchInputField(
                            controller: driverController,
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
                      return PendingList(
                        selectedValued: _selectedValue ?? '',
                        searchedText: driverController.text,
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

class PendingList extends StatefulWidget {
  final String selectedValued;
  final String searchedText;
  final String status;
  final void Function()? onTap;

  const PendingList({
    super.key,
    required this.selectedValued,
    required this.searchedText,
    required this.status,
    this.onTap,
  });

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  final FetchDriverController fetchDriverController =
      Get.put(FetchDriverController());

  final UpdateDriverDocController updateDriverDocController = Get.put(UpdateDriverDocController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        fetchDriverController.fetchDriver(
            widget.selectedValued, widget.searchedText, widget.status, context);
      }
    });
  }

  void _pendingBottomSheet(BuildContext context, String name, String mobileNo, String licenseNo, String date, String driverPhoto, String driverLicenseFront, String driverLicenseBack, String driverLicenceExpire, String driverIdProofFront, String driverIdProofBack, String driverPccPhoto, String driverId) {

    final TextEditingController driverName = TextEditingController(text: name);
    final TextEditingController mobileNumber =
    TextEditingController(text: mobileNo);
    final TextEditingController licenseNumber =
    TextEditingController(text: licenseNo);
    final TextEditingController dateController = TextEditingController(text: date);
    final UploadDriverDocumentController uploadDriverDocumentController = Get.put(UploadDriverDocumentController());


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

                          /// Driver Name
                          EditFormField(
                            label: 'Driver Name',
                            controller: driverName,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Driver name is required';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          /// Driver Photograph
                          EditableImageCard(
                            label: 'Driver Photograph',
                            imageUrl: driverPhoto,
                            onEdit: () {}, imageKey: 'driverPhotograph',
                          ),

                          SizedBox(height: 16),

                          /// Mobile Number
                          EditFormField(
                            label: 'Mobile Number',
                            controller: mobileNumber,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Mobile number is required';
                              }
                              if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                                return 'Enter a valid mobile number';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          /// License Photo
                          EditableImageCard(
                            label: 'Driver Licence Photo (Front)',
                            imageUrl: driverLicenseFront,
                            onEdit: () {}, imageKey: 'driverLicenceFrontKey',
                          ),

                          SizedBox(height: 16),

                          /// License ID
                          EditFormField(
                            label: 'License Id Number',
                            controller: licenseNumber,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'License number is required';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),
                          EditableImageCard(
                            label: 'Driver Licence Photo (Back)',
                            imageUrl: driverLicenseBack,
                            onEdit: () {}, imageKey: 'driverLicenceBackKey',
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    labelText: 'Select Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  onTap: () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
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
                          SizedBox(height: 16),
                          EditableImageCard(
                            label: 'Driver Idproof Front Photo',
                            imageUrl: driverIdProofFront,
                            onEdit: () {}, imageKey: 'driverIdproofFront',
                          ),
                          SizedBox(height: 16),
                          EditableImageCard(
                            label: 'Driver Idproof Back Photo',
                            imageUrl: driverIdProofBack,
                            onEdit: () {}, imageKey: 'driverIdproofBack',
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Driver License Expiry Date', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(driverLicenceExpire,textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Driver Register Status', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('Pending',textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),

                          EditableImageCard(
                            label: 'Driver pcc Photo',
                            imageUrl: driverPccPhoto,
                            onEdit: () {}, imageKey: 'driverPcc',
                          ),
                          SizedBox(height: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Driver Idproof Type', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('ProofType',textAlign: TextAlign.start),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Message', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('',textAlign: TextAlign.start),
                            ],
                          ),

                          SizedBox(height: 24),

                          Spacer(),

                          /// Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'Submit',
                              onPressed: () async{
                                if (formKey.currentState!.validate()) {
                                  final driverPic =  await readData('driverPhotograph');
                                  final licencePicFront = await readData('driverLicenceFrontKey');
                                  final licencePicBack = await readData('driverLicenceBackKey');
                                  final driverIdProofFront = await readData('driverIdproofFront');
                                  final driveIdProofBack = await readData('driverIdproofBack');
                                  final drivePcc = await readData('driverPcc');

                                  updateDriverDocController.updateDriverDetails(driverName.text, mobileNumber.text, dateController.text, driverPic??'', licenseNumber.text, licencePicFront??'', licencePicBack??'', driverLicenceExpire, driverIdProofFront??'', driveIdProofBack??'', drivePcc??'', 'Pending', '', driverId, context).then((value){
                                    fetchDriverController.fetchDriver('', '', 'Pending', context);
                                  });

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
  void didUpdateWidget(covariant PendingList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.selectedValued != widget.selectedValued ||
        oldWidget.searchedText != widget.searchedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          fetchDriverController.fetchDriver(widget.selectedValued,
              widget.searchedText, widget.status, context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return fetchDriverController.isLoading.value == true
          ? Loader()
          : ListView.builder(
              itemCount:
                  fetchDriverController.driverResponse.value?.drivers.length ??
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
                                  fetchDriverController.driverResponse.value
                                          ?.drivers[index].driverName ??
                                      '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: pending(),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Phone number
                            Text(
                              fetchDriverController.driverResponse.value
                                      ?.drivers[index].mobileNumber ??
                                  '',
                              style: CommonFonts.bodyText3,
                            ),
                            SizedBox(height: 4),
                            // License number (partially masked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColors.bgGrey1,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'License no. - ${fetchDriverController.driverResponse.value?.drivers[index].licenseIdNumber ?? ''}',
                                style: CommonFonts.bodyText3,
                              ),
                            ),
                          ],
                        ),
                        // Right side: More options icon
                        GestureDetector(
                          onTap: () {
                            _pendingBottomSheet(context, fetchDriverController.driverResponse.value?.drivers[index].driverName??'', fetchDriverController.driverResponse.value?.drivers[index].mobileNumber??'', fetchDriverController.driverResponse.value?.drivers[index].licenseIdNumber??'', fetchDriverController.driverResponse.value?.drivers[index].dob??'',fetchDriverController.driverResponse.value?.drivers[index].driverPhoto??'', fetchDriverController.driverResponse.value?.drivers[index].licensePhotoFront??'', fetchDriverController.driverResponse.value?.drivers[index].licensePhotoBack??'', fetchDriverController.driverResponse.value?.drivers[index].licenseExpiryDate??'', fetchDriverController.driverResponse.value?.drivers[index].idProofFrontPhoto??'', fetchDriverController.driverResponse.value?.drivers[index].idProofBackPhoto??'', fetchDriverController.driverResponse.value?.drivers[index].pccPhoto??'' , fetchDriverController.driverResponse.value?.drivers[index].id??'');
                          },
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

Widget pending() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      'Verified',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}
