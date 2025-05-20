import 'package:flutter/material.dart';

import '../../utility/constants/fonts/common_fonts.dart';

class BookingList extends StatelessWidget {
  final String? title;
  final String source;
  final String destination;
  final String subtitle;
  final void Function() onTap;

  const BookingList({
    required this.subtitle, required this.onTap, required this.source, required this.destination, this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.directions_car, color: Colors.blue),
        title: Text(
          '$source - $destination',
          style: CommonFonts.h3TextHeading,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle, style: CommonFonts.greytext2,),
        trailing: GestureDetector(
            onTap: onTap,
            child: Icon(Icons.arrow_forward_ios, size: 16)),
      ),
    );
  }
}