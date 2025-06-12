import 'dart:async'; // For debouncing
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/main.dart';
import 'package:wti_vendor_dashboard/common_widgets/buttons/primary_button.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/editable_image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/image/image_card.dart';
import 'package:wti_vendor_dashboard/common_widgets/loader/loader.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/edit_form_field/edit_form_field.dart';
import 'package:wti_vendor_dashboard/common_widgets/textformfield/search_form/search_input_field.dart';
import 'package:wti_vendor_dashboard/core/controller/active_driver_controller/active_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/assign_driver_controller/assign_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/booking/fetch_booking_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/driver/fetch_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/update_driver_controller/update_driver_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle/fetch_vehicle_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle/update_vehicle_controller.dart';
import 'package:wti_vendor_dashboard/core/controller/vehicle_list/vehicle_list_controller.dart';
import 'package:wti_vendor_dashboard/core/model/vehicle_list/vehicle_list_response.dart';

import '../../common_widgets/buttons/tertiary_button.dart';
import '../../common_widgets/dropdown/dropdown_input_field.dart';
import '../../core/controller/reassign_driver_controller/reassign_driver_controller.dart';
import '../../core/controller/upload_driver_document/upload_driver_document_controller.dart';
import '../../core/model/booking/all_booking_response.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class AllBooking extends StatefulWidget {
  const AllBooking({super.key});

  @override
  State<AllBooking> createState() => _AllBookingState();
}

class _AllBookingState extends State<AllBooking> with SingleTickerProviderStateMixin {
  String? _selectedValue;
  String? _selectedByValue;

  final List<String> tabNames = ['Assigned', 'Unassigned'];
  String status = 'Assigned'; // Initialize with the first tab

  final List<String> _options = [
    'Booking Status',
    'Trip State',
    'Trip Type',
    'Basic Trip Type'
  ];
  final List<String> _bookingStatusOptions = ['CONFIRMED', 'CANCELLED'];
  final List<String> _tripStateOptions = [
    'NOT_STARTED',
    'STARTED',
    'ARRIVED',
    'BOARDED',
    'ALIGHT',
    'NOT_BOARDED'
  ];
  final List<String> _tripTypeOptions = ['PICKUP', 'DROP'];
  final List<String> _basicTripTypeOptions = [
    'ONE_WAY',
    'ROUND_TRIP',
    'LOCAL_RENTAL'
  ];

  late TabController _tabController;
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController bookingDateFilterController = TextEditingController(); // Moved to class level
  final FetchBookingController fetchBookingController = Get.put(FetchBookingController());
  Timer? _debounce;

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the date controller with the current date
    bookingDateFilterController.text = getCurrentDate();
    _tabController = TabController(length: tabNames.length, vsync: this);
    _selectedValue = _options.isNotEmpty ? _options.first : null;
    _selectedByValue = _getDefaultSelectedByValue();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          status = tabNames[_tabController.index];
        });

        // Fetch bookings with the preserved date
        if (_selectedValue != null && _selectedByValue != null) {
          fetchBookingController.fetchBooking(
            _selectedValue!,
            _selectedByValue!,
            bookingDateFilterController.text.trim(),
            status,
            context,
          );
        }
        print('Selected tab: ${tabNames[_tabController.index]}');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.dispose();
    vehicleController.dispose();
    bookingDateFilterController.dispose(); // Dispose the controller
    super.dispose();
  }

  String? _getDefaultSelectedByValue() {
    if (_selectedValue == 'Booking Status' && _bookingStatusOptions.isNotEmpty) {
      return _bookingStatusOptions.first;
    } else if (_selectedValue == 'Trip State' && _tripStateOptions.isNotEmpty) {
      return _tripStateOptions.first;
    } else if (_selectedValue == 'Trip Type' && _tripTypeOptions.isNotEmpty) {
      return _tripTypeOptions.first;
    } else if (_selectedValue == 'Basic Trip Type' && _basicTripTypeOptions.isNotEmpty) {
      return _basicTripTypeOptions.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      floatingActionButton: SizedBox(
        width: 110,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedValue = null;
              _selectedByValue = null;
            });
          },
          child: Text(
            'Reset Filters',
            style: CommonFonts.primaryButtonText,
          ),
          tooltip: 'Clear Filters',
          backgroundColor: Colors.blueAccent,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "All Bookings",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      indicator: CustomTabIndicator(),
                      labelColor: AppColors.blueAccent,
                      unselectedLabelColor: Colors.black.withOpacity(0.8),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: tabNames.map((name) => Tab(text: name)).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 64,
                    child: TextFormField(
                      controller: bookingDateFilterController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: getCurrentDate(),
                        labelText: 'Search Booking by Date',
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
                          bookingDateFilterController.text =
                          "${picked.year}/${picked.month}/${picked.day}";
                          fetchBookingController.fetchBooking(
                            _selectedValue ?? '',
                            _selectedByValue ?? '',
                            bookingDateFilterController.text.trim(),
                            status,
                            context,
                          );
                        }
                      },
                    ),
                  ),
                ],
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
                      SizedBox(
                        width: 160,
                        child: DropdownButtonFormField<String>(
                          autofocus: false,
                          focusColor: AppColors.borderColor1,
                          decoration: InputDecoration(
                            labelText: 'Selected For',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.borderColor1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey, width: 1),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          dropdownColor: Colors.white,
                          value: _selectedValue,
                          hint: Text('Select filter'),
                          items: _options.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue = newValue;
                              _selectedByValue = _getDefaultSelectedByValue();
                            });
                            if (_selectedValue != null && _selectedByValue != null) {
                              fetchBookingController.fetchBooking(
                                _selectedValue!,
                                _selectedByValue!,
                                bookingDateFilterController.text.trim(),
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
                        child: Builder(
                          builder: (context) {
                            if (_selectedValue == 'Booking Status') {
                              return DropdownButtonFormField<String>(
                                autofocus: false,
                                focusColor: AppColors.borderColor1,
                                decoration: InputDecoration(
                                  labelText: 'Selected By',
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.borderColor1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                dropdownColor: Colors.white,
                                value: _selectedByValue,
                                items: _bookingStatusOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(color: Colors.black, fontSize: 12),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedByValue = newValue;
                                  });
                                  if (newValue != null) {
                                    fetchBookingController.fetchBooking(
                                      _selectedValue!,
                                      _selectedByValue!,
                                      bookingDateFilterController.text.trim(),
                                      status,
                                      context,
                                    );
                                  }
                                  print('Selected By: $newValue');
                                },
                              );
                            } else if (_selectedValue == 'Trip State') {
                              return DropdownButtonFormField<String>(
                                autofocus: false,
                                focusColor: AppColors.borderColor1,
                                decoration: InputDecoration(
                                  labelText: 'Selected By',
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.borderColor1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                dropdownColor: Colors.white,
                                value: _selectedByValue,
                                items: _tripStateOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedByValue = newValue;
                                  });
                                  if (newValue != null) {
                                    fetchBookingController.fetchBooking(
                                      _selectedValue!,
                                      _selectedByValue!,
                                      bookingDateFilterController.text.trim(),
                                      status,
                                      context,
                                    );
                                  }
                                  print('Selected By: $newValue');
                                },
                              );
                            } else if (_selectedValue == 'Trip Type') {
                              return DropdownButtonFormField<String>(
                                autofocus: false,
                                focusColor: AppColors.borderColor1,
                                decoration: InputDecoration(
                                  labelText: 'Selected By',
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.borderColor1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                dropdownColor: Colors.white,
                                value: _selectedByValue,
                                items: _tripTypeOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedByValue = newValue;
                                  });
                                  if (newValue != null) {
                                    fetchBookingController.fetchBooking(
                                      _selectedValue!,
                                      _selectedByValue!,
                                      bookingDateFilterController.text.trim(),
                                      status,
                                      context,
                                    );
                                  }
                                  print('Selected By: $newValue');
                                },
                              );
                            } else if (_selectedValue == 'Basic Trip Type') {
                              return DropdownButtonFormField<String>(
                                autofocus: false,
                                focusColor: AppColors.borderColor1,
                                decoration: InputDecoration(
                                  labelText: 'Selected By',
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.borderColor1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                dropdownColor: Colors.white,
                                value: _selectedByValue,
                                items: _basicTripTypeOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedByValue = newValue;
                                  });
                                  if (newValue != null) {
                                    fetchBookingController.fetchBooking(
                                      _selectedValue!,
                                      _selectedByValue!,
                                      bookingDateFilterController.text.trim(),
                                      status,
                                      context,
                                    );
                                  }
                                  print('Selected By: $newValue');
                                },
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabNames.map((tabName) {
                    return BookingList(
                      selectedValued: _selectedValue ?? '',
                      selectedByValue: _selectedByValue ?? '',
                      date: bookingDateFilterController.text.trim(),
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

class BookingList extends StatefulWidget {
  final String selectedValued;
  final String selectedByValue;
  final String date;
  final String status;
  final void Function()? onTap;

  const BookingList({
    super.key,
    required this.selectedValued,
    required this.selectedByValue,
    required this.date,
    required this.status,
    this.onTap,
  });

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final FetchBookingController fetchBookingController =
      Get.put(FetchBookingController());

  final VehicleListController vehicleListController =
      Get.put(VehicleListController());

  bool isAssignContainer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.selectedValued != null && widget.selectedByValue != null) {
          fetchBookingController.fetchBooking(
            widget.selectedValued!,
            widget.selectedByValue!,
            widget.date,
            widget.status, // ← Assuming status is defined
            context,
          );
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant BookingList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.selectedValued != widget.selectedValued ||
        oldWidget.selectedByValue != widget.selectedByValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.selectedValued != null && widget.selectedByValue != null) {
            fetchBookingController.fetchBooking(
              widget.selectedValued!,
              widget.selectedByValue!,
              widget.date,
              widget.status, // ← Assuming status is defined
              context,
            );
          }
        }
      });
    }
  }

  void _bookingDetailsBottomSheet(BuildContext context, final Booking booking, String status) {
    showModalBottomSheet(
      backgroundColor: AppColors.scaffoldBgPrimary,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool isAssignContainer = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 16,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Column(
                          children: [
                          SizedBox(
                              width: 120,
                              child: TertiaryButton(
                                text:  status != 'Assigned'? 'Assign': 'Reassign',
                                onPressed: () {
                                  vehicleListController
                                      .fetchVehiclesList(
                                    booking.startTime.toIso8601String(),
                                    booking.endTime.toIso8601String(),
                                    context,
                                  )
                                      .then((value) {
                                    setModalState(() {
                                      isAssignContainer = true;
                                    });
                                  });
                                }
                              ),
                            ),
                            SizedBox(height: 16),
                            if (isAssignContainer) Column(children: [VehicleDropdown(bookingId: booking.id, vehicleType: booking.vehicleType, partnerName: booking.partnerName,status: widget.status,)])
                          ],
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    AccordionCard(booking: booking),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return fetchBookingController.isLoading.value == true
          ? Loader()
          : ListView.builder(
              itemCount: fetchBookingController
                      .allBookingsResponse.value?.bookings.length ??
                  0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final booking = fetchBookingController
                        .allBookingsResponse.value?.bookings[index];
                    if (booking != null) {
                      _bookingDetailsBottomSheet(context, booking, widget.status);
                    }
                  },
                  child: Card(
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Source - ${fetchBookingController.allBookingsResponse.value?.bookings[index].source.address ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width * 0.7,
                                      child: Text(
                                        'Destination - ${fetchBookingController.allBookingsResponse.value?.bookings[index].destination.address ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 2),
                                      child: tripStatus(fetchBookingController
                                              .allBookingsResponse
                                              .value
                                              ?.bookings[index]
                                              .tripState ??
                                          ''),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 2),
                              // Phone number
                              Text(
                                'Booking ID - ${fetchBookingController.allBookingsResponse.value?.bookings[index].id ?? ''}',
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
                                  'Amount - ₹ ${fetchBookingController.allBookingsResponse.value?.bookings[index].totalFare ?? ''}',
                                  style: CommonFonts.bodyText3,
                                ),
                              ),
                            ],
                          ),
                          // Right side: More options icon
                          GestureDetector(
                            onTap: () {
                              final booking = fetchBookingController
                                  .allBookingsResponse.value?.bookings[index];
                              if (booking != null) {
                                _bookingDetailsBottomSheet(context, booking, widget.status);
                              }
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }
}

// pending

//verify
Widget tripStatus(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.green[300],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    ),
  );
}

class AccordionCard extends StatefulWidget {
  final Booking booking;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const AccordionCard({
    super.key,
    required this.booking,
    this.isExpanded = false,
    this.onToggle,
  });

  @override
  _AccordionCardState createState() => _AccordionCardState();
}

class _AccordionCardState extends State<AccordionCard> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Header
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              'Booking ID- ${widget.booking.referenceNumber}',
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Status: ${widget.booking.bookingStatus}',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                widget.onToggle?.call();
              },
            ),
          ),
          // Expanded Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fare Details
                  _buildSectionTitle('Fare Details'),
                  _buildDetailRow(
                      'Base Fare', '₹${widget.booking.fareDetails.baseFare}'),
                  _buildDetailRow(
                      'Total Fare', '₹${widget.booking.fareDetails.totalFare}'),
                  _buildDetailRow(
                      'Platform Fee', '₹${widget.booking.platformFee}'),
                  _buildDetailRow(
                      'Booking GST', '₹${widget.booking.bookingGst}'),
                  const SizedBox(height: 8),
                  // Vehicle Details
                  _buildSectionTitle('Vehicle Details'),
                  _buildDetailRow('Type', widget.booking.vehicleDetails.type),
                  _buildDetailRow(
                      'Subcategory', widget.booking.vehicleDetails.subcategory),
                  _buildDetailRow('Model', widget.booking.vehicleDetails.model),
                  const SizedBox(height: 8),
                  // Passenger Details
                  _buildSectionTitle('Passenger Details'),
                  _buildDetailRow('Name', widget.booking.passenger.name),
                  _buildDetailRow('Email', widget.booking.passenger.email),
                  _buildDetailRow('Phone',
                      '+${widget.booking.passenger.countryCode} ${widget.booking.passenger.phoneNumber}'),
                  const SizedBox(height: 8),
                  // Trip Details
                  _buildSectionTitle('Trip Details'),
                  _buildDetailRow('Source', widget.booking.source.address),
                  _buildDetailRow(
                      'Destination', widget.booking.destination.address),
                  _buildDetailRow('Trip Type',
                      widget.booking.tripTypeDetails.tripTypeCamel),
                  _buildDetailRow(
                      'Start Time', widget.booking.startTime.toIso8601String()),
                  if (widget.booking.stopovers.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildSectionTitle('Stopovers'),
                    ...widget.booking.stopovers.map((stopover) =>
                        _buildDetailRow('Stopover', stopover.address)),
                  ],
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Adjust import path accordingly

 // update path as needed

class VehicleDropdown extends StatelessWidget {
  final String? bookingId;
  final String? vehicleType;
  final String? partnerName;
  final String? status;


  final VehicleListController controller = Get.put(VehicleListController());
  final ActiveDriverController activeDriverController = Get.put(ActiveDriverController());
  final AssignDriverController assignDriverController = Get.put(AssignDriverController());
  final ReassignDriverController reassignDriverController = Get.put(ReassignDriverController());


  VehicleDropdown({super.key, this.bookingId, this.vehicleType, this.partnerName, this.status});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final vehicles = controller.vehicleListResponse.value?.vehicles ?? [];

      if (vehicles.isEmpty) {
        return const Text("No vehicles found");
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: controller.selectedVehicleId.value.isNotEmpty &&
                vehicles.any((v) => v.id == controller.selectedVehicleId.value)
                ? controller.selectedVehicleId.value
                : null,
            decoration: const InputDecoration(
              labelText: 'Select Vehicle',
              border: OutlineInputBorder(),
            ),
            items: vehicles
                .where((v) => v.id != null)
                .map((vehicle) {
              return DropdownMenuItem<String>(
                value: vehicle.id!,
                child: Text(vehicle.vehicleNumber ?? 'Unknown Vehicle'),
              );
            }).toList(),
            onChanged: (String? selectedId) {
              if (selectedId != null) {
                controller.selectedVehicleId.value = selectedId;
                final selectedVehicle = vehicles.firstWhere((v) => v.id == selectedId);
                controller.selectedVehicle.value = selectedVehicle;
                activeDriverController.fetchActiveDriver(selectedId, context);
              }
            },
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assign booking to driver', ),
              SizedBox(height: 8,),
            activeDriverController.activeDriverModel.value?.activeDriver != null?  Column(
                children: [
                  Text(activeDriverController.driverDetailsResponse.value?.driverName??'', ),
                  SizedBox(height: 4,),
                  Text(activeDriverController.driverDetailsResponse.value?.mobileNumber??''),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        child: status!= 'Assigned'? PrimaryButton(text: 'Assign Driver', onPressed: (){
                          final selectedVehicle = controller.selectedVehicle.value;
                          final vehicleId = selectedVehicle?.id;
                          final vehicleNumber = selectedVehicle?.vehicleNumber;
                          assignDriverController.submitAssignDriver(bookingId??'',vehicleId??'' , activeDriverController.driverDetailsResponse.value?.id??'', activeDriverController.driverDetailsResponse.value?.driverName??'', vehicleNumber??'', vehicleType??'', partnerName??'', activeDriverController.driverDetailsResponse.value?.mobileNumber??'', context).then((value){
                            GoRouter.of(context).pop();
                          });
                        }): PrimaryButton(text: 'Reassign Driver', onPressed: (){
                          final selectedVehicle = controller.selectedVehicle.value;
                          final vehicleId = selectedVehicle?.id;
                          final vehicleNumber = selectedVehicle?.vehicleNumber;
                          reassignDriverController.submitReassignDriver(bookingId??'',vehicleId??'' , activeDriverController.driverDetailsResponse.value?.id??'', activeDriverController.driverDetailsResponse.value?.driverName??'', vehicleNumber??'', vehicleType??'', partnerName??'', activeDriverController.driverDetailsResponse.value?.mobileNumber??'', context).then((value){
                            GoRouter.of(context).pop();
                          });
                        }),
                      ),
                    ],
                  )
                ],
              ) : Text('Please pair vehicle first to assign',style: CommonFonts.errorTextStatus,),
            
            ],
          )
        ],
      );
    });
  }
}
