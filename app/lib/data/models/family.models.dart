// To parse this JSON data, do
//
//     final family = familyFromJson(jsonString);

import 'dart:convert';

List<Family> familyFromJson(String str) =>
    List<Family>.from(json.decode(str).map((x) => Family.fromJson(x)));

String familyToJson(List<Family> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Family {
  String relationshipId;
  String relation;
  String permission;
  RelatedUser relatedUser;

  Family({
    required this.relationshipId,
    required this.relation,
    required this.permission,
    required this.relatedUser,
  });

  factory Family.fromJson(Map<String, dynamic> json) => Family(
    relationshipId: json["relationship_id"],
    relation: json["relation"],
    permission: json["permission"],
    relatedUser: RelatedUser.fromJson(json["related_user"]),
  );

  Map<String, dynamic> toJson() => {
    "relationship_id": relationshipId,
    "relation": relation,
    "permission": permission,
    "related_user": relatedUser.toJson(),
  };
}

class RelatedUser {
  String? name;
  dynamic phone;
  dynamic gender;
  dynamic dateOfBirth;
  String id;
  DateTime updatedAt;

  RelatedUser({
    required this.name,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.id,
    required this.updatedAt,
  });

  factory RelatedUser.fromJson(Map<String, dynamic> json) => RelatedUser(
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
    "updated_at": updatedAt.toIso8601String(),
  };
}
