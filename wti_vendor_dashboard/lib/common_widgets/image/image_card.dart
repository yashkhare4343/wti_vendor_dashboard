import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/controller/upload_driver_document/upload_driver_document_controller.dart';

class ImageCard extends StatefulWidget {
  final String label;
  final String imageUrl;

  const ImageCard({
    super.key,
    required this.imageUrl,
    required this.label,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Card(
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
          ],
        ),
      ],
    );
  }
}
