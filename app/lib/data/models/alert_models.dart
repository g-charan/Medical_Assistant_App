// lib/data/models/alert_models.dart
import 'package:flutter/material.dart';

@immutable
abstract class AppAlert {
  const AppAlert({
    required this.id,
    required this.medicineName,
    required this.details,
  });
  final String id;
  final String medicineName;
  final String details;

  // Add a generic copyWith if needed for abstract class
  AppAlert copyWith({String? id, String? medicineName, String? details});
}

@immutable
// lib/data/models/upcoming_dose_alert.dart
class UpcomingDoseAlert extends AppAlert {
  final String patientName;
  final String time;

  const UpcomingDoseAlert({
    required super.id,
    required super.medicineName,
    required this.patientName,
    required this.time,
    required super.details,
  });

  factory UpcomingDoseAlert.fromMap(Map<String, String> map) {
    return UpcomingDoseAlert(
      id: map['id'] ?? '',
      medicineName: map['medicineName'] ?? '',
      patientName: map['patientName'] ?? '',
      time: map['time'] ?? '',
      details: map['details'] ?? '',
    );
  }

  @override
  UpcomingDoseAlert copyWith({
    String? id,
    String? medicineName,
    String? patientName,
    String? time,
    String? details,
  }) {
    return UpcomingDoseAlert(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      patientName: patientName ?? this.patientName,
      time: time ?? this.time,
      details: details ?? this.details,
    );
  }
}

@immutable
class MissedDoseAlert extends AppAlert {
  const MissedDoseAlert({
    required super.id,
    required super.medicineName,
    required this.patientName,
    required this.time,
    required super.details, // This would be the expanded content
  });

  final String patientName;
  final String time;

  @override
  MissedDoseAlert copyWith({
    String? id,
    String? medicineName,
    String? patientName,
    String? time,
    String? details,
  }) {
    return MissedDoseAlert(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      patientName: patientName ?? this.patientName,
      time: time ?? this.time,
      details: details ?? this.details,
    );
  }
}

@immutable
class RefillAlert extends AppAlert {
  const RefillAlert({
    required super.id,
    required super.medicineName,
    required this.shortDetail, // This is what shows on the unexpanded card
    required super.details, // This is the expanded content
  });

  final String shortDetail;

  @override
  RefillAlert copyWith({
    String? id,
    String? medicineName,
    String? shortDetail,
    String? details,
  }) {
    return RefillAlert(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      shortDetail: shortDetail ?? this.shortDetail,
      details: details ?? this.details,
    );
  }
}

@immutable
class ExpiryWarningAlert extends AppAlert {
  const ExpiryWarningAlert({
    required super.id,
    required super.medicineName,
    required this.expiresIn, // e.g., "expires in 3 days"
    required super.details, // This is the expanded content
  });

  final String expiresIn;

  @override
  ExpiryWarningAlert copyWith({
    String? id,
    String? medicineName,
    String? expiresIn,
    String? details,
  }) {
    return ExpiryWarningAlert(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      expiresIn: expiresIn ?? this.expiresIn,
      details: details ?? this.details,
    );
  }
}
