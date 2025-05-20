import 'package:flutter/material.dart';
import 'package:wti_vendor_dashboard/utility/constants/fonts/common_fonts.dart';

class SearchInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;

  const SearchInputField({
    Key? key,
    required this.controller,
    this.hintText = 'Search...', this.onChanged,
  }) : super(key: key);

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: widget.hintText,
        hintStyle: CommonFonts.inputTextAuth,
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}