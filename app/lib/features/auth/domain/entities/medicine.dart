// app/data/models/medicine.dart
import 'package:flutter/material.dart';

class Medicine {
  final String id;
  final String name;
  final String description;
  final Color iconColor;
  final IconData iconData;

  Color get backgroundColor => iconColor.withOpacity(0.2);

  const Medicine({
    required this.id,
    required this.name,
    required this.description,
    this.iconColor = Colors.grey, // Default color
    this.iconData = Icons.medication, // Default icon
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? description,
    Color? iconColor,
    IconData? iconData,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconColor: iconColor ?? this.iconColor,
      iconData: iconData ?? this.iconData,
    );
  }

  // Helper to generate a simple unique ID for new entries
  static String generateUniqueId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
