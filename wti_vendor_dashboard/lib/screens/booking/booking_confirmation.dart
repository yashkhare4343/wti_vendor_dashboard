import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/common_widgets/buttons/primary_button.dart';
import 'package:wti_vendor_dashboard/common_widgets/buttons/secondary_button.dart';

import '../../utility/constants/colors/app_colors.dart';
import '../../utility/constants/fonts/common_fonts.dart';

class BookingConfirmation extends StatefulWidget {
  const BookingConfirmation({super.key});

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  List<MapEntry<String, String>> parsedData = [];

  @override
  void initState() {
    super.initState();
    loadNotificationPayload();
  }

  Future<void> loadNotificationPayload() async {
    final payload = await readData('notification_payload');
    print("📦 Raw Payload: $payload");

    if (payload != null) {
      final lines = payload.split('\n');
      final entries = lines.map((line) {
        final parts = line.split(':');
        final key = parts[0].trim();
        final value = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';
        return MapEntry(key, value);
      }).toList();

      setState(() {
        parsedData = entries;
      });
    }
  }

  Future<String?> readData(String key) async {
    if (Platform.isIOS) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      const secureStorage = FlutterSecureStorage();
      return await secureStorage.read(key: key);
    }
  }

  void onAccept() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Accepted")),
    );
    // Trigger backend call here if needed
  }

  void onReject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Rejected")),
    );
    // Trigger backend call here if needed
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
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: SecondaryButton(text: 'Reject', backgroundColor: Colors.red, onPressed: (){}),
                ),
                const SizedBox(width: 16),
                Expanded(child: PrimaryButton(text: 'Accept', backgroundColor: Colors.green, onPressed: (){}))
              ],
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
