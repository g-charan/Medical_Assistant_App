// To parse this JSON data, do
//
//     final medicines = medicinesFromJson(jsonString);

import 'dart:convert';

List<Medicines> medicinesFromJson(String str) =>
    List<Medicines>.from(json.decode(str).map((x) => Medicines.fromJson(x)));

String medicinesToJson(List<Medicines> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Medicines {
  DateTime startDate;
  DateTime endDate;
  String notes;
  bool isActive;
  String id;
  String userId;
  Medicine medicine;

  Medicines({
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.isActive,
    required this.id,
    required this.userId,
    required this.medicine,
  });

  factory Medicines.fromJson(Map<String, dynamic> json) => Medicines(
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    notes: json["notes"],
    isActive: json["is_active"],
    id: json["id"],
    userId: json["user_id"],
    medicine: Medicine.fromJson(json["medicine"]),
  );

  Map<String, dynamic> toJson() => {
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "notes": notes,
    "is_active": isActive,
    "id": id,
    "user_id": userId,
    "medicine": medicine.toJson(),
  };
  Medicines copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
    String? id,
    String? userId,
    Medicine? medicine,
  }) {
    return Medicines(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      medicine: medicine ?? this.medicine,
    );
  }
}

class Medicine {
  String name;
  String? genericName;
  String manufacturer;
  String medicineId;

  Medicine({
    required this.name,
    this.genericName,
    required this.manufacturer,
    required this.medicineId,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    name: json["name"],
    genericName: json["generic_name"],
    manufacturer: json["manufacturer"],
    medicineId: json["medicine_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "generic_name": genericName,
    "manufacturer": manufacturer,
    "medicine_id": medicineId,
  };
  Medicine copyWith({
    String? name,
    String? genericName,
    String? manufacturer,
    String? medicineId,
  }) {
    return Medicine(
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      manufacturer: manufacturer ?? this.manufacturer,
      medicineId: medicineId ?? this.medicineId,
    );
  }
}
