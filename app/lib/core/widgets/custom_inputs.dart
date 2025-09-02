import "package:flutter/material.dart";

class MinimalTextField extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  // 1. Add the missing properties
  final bool obscureText;
  final TextInputType? keyboardType;

  const MinimalTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.onChanged,
    // 2. Add them to the constructor with a default value for obscureText
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      // 3. Pass the properties to the underlying TextField
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14.0,
        color: Colors.black87, // Or a subtle grey
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600], // Subtle hint text color
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.grey[600], // Subtle icon color
              )
            : null,
        border: InputBorder.none, // Remove the default underline border
        focusedBorder: InputBorder.none, // Remove the border when focused
        enabledBorder: InputBorder.none, // Remove the border when enabled
        filled: true, // Enable background color
        fillColor: Colors.grey[200], // Light grey background
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ), // Adjust padding
      ),
    );
  }
}
