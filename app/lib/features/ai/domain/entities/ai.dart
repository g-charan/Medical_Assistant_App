// To parse this JSON data, do
//
//     final aiChat = aiChatFromJson(jsonString);

import 'dart:convert';

AiChat aiChatFromJson(String str) => AiChat.fromJson(json.decode(str));

String aiChatToJson(AiChat data) => json.encode(data.toJson());

class AiChat {
  String medicineId;
  String prompt;

  AiChat({required this.medicineId, required this.prompt});

  AiChat copyWith({String? medicineId, String? prompt}) => AiChat(
    medicineId: medicineId ?? this.medicineId,
    prompt: prompt ?? this.prompt,
  );

  factory AiChat.fromJson(Map<String, dynamic> json) =>
      AiChat(medicineId: json["medicine_id"], prompt: json["prompt"]);

  Map<String, dynamic> toJson() => {
    "medicine_id": medicineId,
    "prompt": prompt,
  };
}

AiResponse aiResponseFromJson(String str) =>
    AiResponse.fromJson(json.decode(str));

String aiResponseToJson(AiResponse data) => json.encode(data.toJson());

class AiResponse {
  String response;

  AiResponse({required this.response});

  AiResponse copyWith({String? response}) =>
      AiResponse(response: response ?? this.response);

  factory AiResponse.fromJson(Map<String, dynamic> json) =>
      AiResponse(response: json["response"]);

  Map<String, dynamic> toJson() => {"response": response};
}

// OCR Model
Ocr ocrFromJson(String str) => Ocr.fromJson(json.decode(str));

String ocrToJson(Ocr data) => json.encode(data.toJson());

class Ocr {
  String text;

  Ocr({required this.text});

  Ocr copyWith({String? text}) => Ocr(text: text ?? this.text);

  factory Ocr.fromJson(Map<String, dynamic> json) => Ocr(text: json["text"]);

  Map<String, dynamic> toJson() => {"text": text};
}

OcrResponse ocrResponseFromJson(String str) =>
    OcrResponse.fromJson(json.decode(str));

String ocrResponseToJson(OcrResponse data) => json.encode(data.toJson());

class OcrResponse {
  String name;
  String description;

  OcrResponse({required this.name, required this.description});

  OcrResponse copyWith({String? name, String? description}) => OcrResponse(
    name: name ?? this.name,
    description: description ?? this.description,
  );

  factory OcrResponse.fromJson(Map<String, dynamic> json) =>
      OcrResponse(name: json["name"], description: json["description"]);

  Map<String, dynamic> toJson() => {"name": name, "description": description};
}

HistoryResponse historyResponseFromJson(String str) =>
    HistoryResponse.fromJson(json.decode(str));

String historyResponseToJson(HistoryResponse data) =>
    json.encode(data.toJson());

class HistoryResponse {
  List<History> history;

  HistoryResponse({required this.history});

  HistoryResponse copyWith({List<History>? history}) =>
      HistoryResponse(history: history ?? this.history);

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      HistoryResponse(
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

  History copyWith({String? role, List<Part>? parts}) =>
      History(role: role ?? this.role, parts: parts ?? this.parts);

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

  Part copyWith({String? text}) => Part(text: text ?? this.text);

  factory Part.fromJson(Map<String, dynamic> json) => Part(text: json["text"]);

  Map<String, dynamic> toJson() => {"text": text};
}
