import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widgets/buttons/secondary_button.dart';
import '../../common_widgets/buttons/primary_button.dart';
import '../../core/controller/accept_booking_controller/accept_booking_controller.dart';
import '../../core/route_management/app_routes.dart';
import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class BookingConfirmation extends StatefulWidget {
  final Map<String, String> bookingDetails;

  const BookingConfirmation({super.key, required this.bookingDetails});

  static BookingConfirmation create(Map<String, dynamic> data) {
    // Convert dynamic map to Map<String, String>
    final parsed = data.map((key, value) => MapEntry(key.toString(), value.toString()));

    return BookingConfirmation(bookingDetails: parsed);
  }

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  late List<MapEntry<String, String>> parsedData;
  String? notificationType;
  String? bookingId;

  final AcceptBookingController acceptBookingController =
  Get.put(AcceptBookingController());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    parsedData = widget.bookingDetails.entries.toList();

    // Normalize keys to lowercase for safety
    Map<String, String> lowerCaseMap = {
      for (var entry in widget.bookingDetails.entries)
        entry.key.toLowerCase(): entry.value
    };

    notificationType = lowerCaseMap['notificationtype'];
    bookingId = lowerCaseMap['bookingid'];

    print("notificationType: $notificationType");
    print("bookingId: $bookingId");
  }

  void onAccept() {
    // Use bookingId and accept booking logic
    acceptBookingController.verifyAcceptBooking(bookingId ?? '', context);
  }

  void onReject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking Rejected"),
        backgroundColor: Colors.red,
      ),
    );
    GoRouter.of(context).pushReplacement(AppRoutes.dashboard);
  }

  void onGoToBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navigating to Booking..."), backgroundColor: Colors.blueAccent,),
    );
    GoRouter.of(context).pushReplacement(AppRoutes.allBooking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Confirm Booking",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
      ),
      body: parsedData.isEmpty
          ? const Center(child: Text("No booking details available."))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                border: TableBorder.all(color: Colors.grey.shade300),
                defaultVerticalAlignment:
                TableCellVerticalAlignment.middle,
                children: [
                  for (var entry in parsedData)
                    TableRow(
                      decoration: BoxDecoration(
                        color: parsedData.indexOf(entry) % 2 == 0
                            ? Colors.grey.shade100
                            : Colors.white,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          /// Bottom Buttons Based on Type
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: notificationType == 'flashing'
                ? Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                      text: 'Reject',
                      backgroundColor: Colors.red,
                      onPressed: onReject),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                      text: 'Accept',
                      backgroundColor: Colors.green,
                      onPressed: onAccept),
                ),
              ],
            )
                : PrimaryButton(
                text: 'Go to Booking',
                backgroundColor: AppColors.primary,
                onPressed: onGoToBooking),
          ),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}
