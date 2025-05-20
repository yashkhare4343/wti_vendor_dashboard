import 'package:flutter/material.dart';

class BoardedOtp extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool showDropdown;

  BoardedOtp({
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.number,
    this.obscureText = false,
    this.maxLength,
    this.onChanged,
    this.showDropdown = false,
  });

  @override
  _BoardedOtpState createState() => _BoardedOtpState();
}

class _BoardedOtpState extends State<BoardedOtp> {
  String _selectedUnit = "KM";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0.0),
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: widget.showDropdown
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUnit,
              dropdownColor: Colors.blueGrey[50],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                  _convertValue();
                });
              },
              items: ["KM", "Miles"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                    ),
                  ),
                );
              }).toList(),
              icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
            ),
          ),
        )
            : null,
      ),
      maxLength: widget.maxLength,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }

  void _convertValue() {
    if (_selectedUnit == "Miles" && widget.controller.text.isNotEmpty) {
      double? kmValue = double.tryParse(widget.controller.text);
      if (kmValue != null) {
        double milesValue = kmValue * 1.6;
        widget.controller.text = milesValue.toStringAsFixed(2);
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
      }
    }
  }
}
