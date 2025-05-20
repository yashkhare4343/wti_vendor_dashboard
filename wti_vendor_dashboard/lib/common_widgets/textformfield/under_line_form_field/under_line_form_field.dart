import 'package:flutter/material.dart';

class UnderlineTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String?)? onChanged;


  const UnderlineTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text, this.onChanged,
  });

  @override
  State<UnderlineTextFormField> createState() => _UnderlineTextFormFieldState();
}

class _UnderlineTextFormFieldState extends State<UnderlineTextFormField> {
  late FocusNode _focusNode;
  late bool _isFocused;
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      });
    _isFocused = false;
    _obscure = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscure,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon != null
            ? IconButton(
          icon: widget.suffixIcon??SizedBox(),
          onPressed: widget.onSuffixTap ??
                  () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
        )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
