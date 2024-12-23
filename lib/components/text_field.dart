import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextStyle? labelStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    required this.controller,
    this.labelStyle,
    this.inputTextStyle,
    this.hintStyle,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.labelStyle ??
              const TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscured,
            keyboardType: widget.keyboardType,
            style:
                widget.inputTextStyle ?? const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ?? const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFF613EEA),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFF613EEA),
                  width: 2,
                ),
              ),
              fillColor: const Color(0xFFFBF9FE),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
            ),
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
