// To parse this JSON data, do
//
//     final generalAi = generalAiFromJson(jsonString);

import 'dart:convert';

GeneralAi generalAiFromJson(String str) => GeneralAi.fromJson(json.decode(str));

String generalAiToJson(GeneralAi data) => json.encode(data.toJson());

class GeneralAi {
  List<History> history;

  GeneralAi({required this.history});

  factory GeneralAi.fromJson(Map<String, dynamic> json) => GeneralAi(
    history: List<History>.from(
      json["history"].map((x) => History.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "history": List<dynamic>.from(history.map((x) => x.toJson())),
  };
}

class History {
  String role;
  List<Part> parts;

  History({required this.role, required this.parts});

  factory History.fromJson(Map<String, dynamic> json) => History(
    role: json["role"],
    parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
  };
}

class Part {
  String text;

  Part({required this.text});

  factory Part.fromJson(Map<String, dynamic> json) => Part(text: json["text"]);

  Map<String, dynamic> toJson() => {"text": text};
}

// To parse this JSON data, do
//
//     final generalAiResponse = generalAiResponseFromJson(jsonString);

GeneralAiResponse generalAiResponseFromJson(String str) =>
    GeneralAiResponse.fromJson(json.decode(str));

String generalAiResponseToJson(GeneralAiResponse data) =>
    json.encode(data.toJson());

class GeneralAiResponse {
  String response;

  GeneralAiResponse({required this.response});

  factory GeneralAiResponse.fromJson(Map<String, dynamic> json) =>
      GeneralAiResponse(response: json["response"]);

  Map<String, dynamic> toJson() => {"response": response};
}

GeneralAiRequest generalAiRequestFromJson(String str) =>
    GeneralAiRequest.fromJson(json.decode(str));

String generalAiRequestToJson(GeneralAiRequest data) =>
    json.encode(data.toJson());

class GeneralAiRequest {
  String prompt;

  GeneralAiRequest({required this.prompt});

  factory GeneralAiRequest.fromJson(Map<String, dynamic> json) =>
      GeneralAiRequest(prompt: json["prompt"]);

  Map<String, dynamic> toJson() => {"prompt": prompt};
}
