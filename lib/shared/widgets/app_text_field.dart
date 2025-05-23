import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app text field
class AppTextField extends StatelessWidget {
  /// Controller
  final TextEditingController? controller;
  
  /// Hint text
  final String? hintText;
  
  /// Label text
  final String? labelText;
  
  /// Error text
  final String? errorText;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Suffix icon
  final IconData? suffixIcon;
  
  /// Suffix icon button
  final VoidCallback? onSuffixIconTap;
  
  /// On changed callback
  final ValueChanged<String>? onChanged;
  
  /// On submitted callback
  final ValueChanged<String>? onSubmitted;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Is obscure text
  final bool obscureText;
  
  /// Is enabled
  final bool enabled;
  
  /// Max lines
  final int? maxLines;
  
  /// Min lines
  final int? minLines;
  
  /// Focus node
  final FocusNode? focusNode;

  /// Constructor
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconTap,
              )
            : null,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
