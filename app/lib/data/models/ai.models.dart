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
