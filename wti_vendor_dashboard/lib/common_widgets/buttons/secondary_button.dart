import 'package:flutter/material.dart';
import '../../utility/constants/fonts/common_fonts.dart';

import '../../utility/constants/colors/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final bool? isIcon;
  final IconData? icon;

  // Constructor with default values for backgroundColor and borderRadius
  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.secondary,  // Default to blue if no color is provided
    this.borderRadius = 8.0, this.isIcon, this.icon,  // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,  // Set background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),  // Set border radius
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),  // Adjust padding
      ),
      child:isIcon== true?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(text, style: CommonFonts.primaryButtonText,),
          Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),

        ],
      ): Text(text, style: CommonFonts.primaryButtonText,)
    );
  }
}
