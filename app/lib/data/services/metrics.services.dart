import 'dart:convert';

import 'package:app/data/models/family.models.dart';
import 'package:app/data/models/metrics.model.dart';
import 'package:dio/dio.dart';

class RemoteMetricsService {
  final Dio _dio;
  RemoteMetricsService({required Dio dio}) : _dio = dio;

  Future<List<Metrics>> getMetrics() async {
    // The endpoint 'relationships' is now correct.
    final response = await _dio.get(
      'http://10.0.2.2:8000/api/v1/health_metrics',
    );

    if (response.statusCode == 200) {
      // Directly parse the decoded list from dio.
      final String json = jsonEncode(response.data);
      return metricsFromJson(json);
    } else {
      // Use a specific error message.
      throw Exception("Failed to load family relationships");
    }
  }
}
