// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  dynamic name;
  dynamic phone;
  dynamic gender;
  dynamic dateOfBirth;
  String? id;
  DateTime? updatedAt;

  Profile({
    required this.name,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    this.id,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    name: json["name"],
    phone: json["phone"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    id: json["id"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "gender": gender,
    "date_of_birth": dateOfBirth,
    "id": id,
    "updated_at": updatedAt?.toIso8601String(),
  };
}
