// lib/models/family_member.dart
import 'package:flutter/material.dart';

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.lastUpdate,
    required this.status,
    this.statusColor = Colors.green, // Default status color
    this.iconData = Icons.person_rounded, // Default icon
    this.iconColor = Colors.white, // Default icon color
    this.iconBackgroundColor =
        Colors.deepPurple, // Default icon background color
  });

  final String id;
  final String name;
  final String lastUpdate; // e.g., "28/09/2024"
  final String status; // e.g., "All done for today", "Needs attention"
  final Color statusColor;
  final IconData iconData;
  final Color iconColor;
  final Color iconBackgroundColor;

  // Optional: copyWith for immutability
  FamilyMember copyWith({
    String? id,
    String? name,
    String? lastUpdate,
    String? status,
    Color? statusColor,
    IconData? iconData,
    Color? iconColor,
    Color? iconBackgroundColor,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      iconData: iconData ?? this.iconData,
      iconColor: iconColor ?? this.iconColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
    );
  }
}
