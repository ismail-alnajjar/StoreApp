import 'package:flutter/material.dart';

class CustomTextField96 extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onToggleObscure;

  const CustomTextField96({
    Key? key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    required this.onChanged,
    this.onToggleObscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword ? obscureText : false,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
