import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  String name;
  String purpose;
  String usage;
  bool? prescriptionRequired;

  Welcome({
    required this.name,
    required this.purpose,
    required this.usage,
    this.prescriptionRequired,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    name: json["name"],
    purpose: json["purpose"],
    usage: json["usage"],
    prescriptionRequired: json["prescription_required"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "purpose": purpose,
    "usage": usage,
    "prescription_required": prescriptionRequired,
  };
}
