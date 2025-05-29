import 'package:flutter/material.dart';

class EditFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String status;

  const EditFormField({super.key, required this.label, required this.controller, this.onChanged, this.validator, required this.status});

  @override
  State<EditFormField> createState() => _EditFormFieldState();
}

class _EditFormFieldState extends State<EditFormField> {
  bool _isEditable = false;


  @override
  void initState() {
    super.initState();
  }

  void _toggleEdit() {
    setState(() {
      _isEditable = !_isEditable;
    });
    print('input text is : ${widget.controller.text}');
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
                 readOnly: widget.status=='Verify'? true: !_isEditable,
                validator: widget.status=='Verify'? null : widget.validator,
                decoration: InputDecoration(
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
            const SizedBox(width: 8),
            widget.status=='Verify'? SizedBox():  IconButton(
              icon: Icon(_isEditable ? Icons.check : Icons.edit),
              onPressed: _toggleEdit,
              tooltip: _isEditable ? 'Save' : 'Edit',
            ),
          ],
        ),
        // const SizedBox(height: 12),
        // Container(
        //   height: 1,
        //   color: Colors.grey[500],
        // )


      ],
    );
  }
}
