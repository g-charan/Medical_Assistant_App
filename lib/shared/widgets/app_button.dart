import 'package:flutter/material.dart';

/// Button types
enum AppButtonType {
  /// Primary button
  primary,
  
  /// Secondary button
  secondary,
  
  /// Text button
  text,
}

/// Custom app button
class AppButton extends StatelessWidget {
  /// Button text
  final String text;
  
  /// Button type
  final AppButtonType type;
  
  /// Button icon
  final IconData? icon;
  
  /// On tap callback
  final VoidCallback? onTap;
  
  /// Is button loading
  final bool isLoading;
  
  /// Is button full width
  final bool isFullWidth;
  
  /// Button padding
  final EdgeInsets? padding;

  /// Constructor
  const AppButton({
    super.key,
    required this.text,
    this.type = AppButtonType.primary,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (type) {
      case AppButtonType.primary:
        return _buildElevatedButton(theme);
      case AppButtonType.secondary:
        return _buildOutlinedButton(theme);
      case AppButtonType.text:
        return _buildTextButton(theme);
    }
  }

  Widget _buildElevatedButton(ThemeData theme) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          padding: padding,
        ),
        child: _buildButtonContent(theme),
      ),
    );
  }

  Widget _buildOutlinedButton(ThemeData theme) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          padding: padding,
        ),
        child: _buildButtonContent(theme),
      ),
    );
  }

  Widget _buildTextButton(ThemeData theme) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: TextButton(
        onPressed: isLoading ? null : onTap,
        style: TextButton.styleFrom(
          padding: padding,
        ),
        child: _buildButtonContent(theme),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}
