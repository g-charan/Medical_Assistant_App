// To parse this JSON data, do
//
//     final metrics = metricsFromJson(jsonString);

import 'dart:convert';

List<Metrics> metricsFromJson(String str) =>
    List<Metrics>.from(json.decode(str).map((x) => Metrics.fromJson(x)));

String metricsToJson(List<Metrics> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Metrics {
  String metricType;
  String value;
  String unit;
  DateTime timestamp;
  String metricId;
  String userId;

  Metrics({
    required this.metricType,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.metricId,
    required this.userId,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
    metricType: json["metric_type"],
    value: json["value"],
    unit: json["unit"],
    timestamp: DateTime.parse(json["timestamp"]),
    metricId: json["metric_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "metric_type": metricType,
    "value": value,
    "unit": unit,
    "timestamp": timestamp.toIso8601String(),
    "metric_id": metricId,
    "user_id": userId,
  };
}
