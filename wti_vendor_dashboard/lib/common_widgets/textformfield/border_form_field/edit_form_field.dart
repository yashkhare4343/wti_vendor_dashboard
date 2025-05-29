import 'package:flutter/material.dart';

class BorderFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const BorderFormField({super.key, required this.label, required this.controller, this.onChanged, this.validator});

  @override
  State<BorderFormField> createState() => _BorderFormFieldState();
}

class _BorderFormFieldState extends State<BorderFormField> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                validator: widget.validator,
                decoration: InputDecoration(
                  hintText: widget.label,
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
