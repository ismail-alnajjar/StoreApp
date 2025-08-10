import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText, // أضفت labelText
    this.inputType,
    this.onChanged,
    this.obscureText = false,
    this.controller,
  });

  final Function(String)? onChanged;
  final String? hintText;
  final String? labelText; // إضافة labelText
  final TextInputType? inputType;
  final bool? obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText, // عرض النص الخاص بالـ label
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
