import 'package:flutter/material.dart';

/// Light color scheme for the app
final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1976D2), // Primary blue
  secondary: const Color(0xFF66BB6A), // Secondary green
  tertiary: const Color(0xFFFF8A65), // Tertiary orange
  brightness: Brightness.light,
);

/// Dark color scheme for the app
final darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1976D2), // Primary blue
  secondary: const Color(0xFF66BB6A), // Secondary green
  tertiary: const Color(0xFFFF8A65), // Tertiary orange
  brightness: Brightness.dark,
);
