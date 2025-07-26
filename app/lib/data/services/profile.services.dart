import 'dart:convert';
import 'package:app/data/models/profile.models.dart';
import 'package:dio/dio.dart';

class RemoteProfileService {
  final Dio _dio;
  RemoteProfileService({required Dio dio}) : _dio = dio;

  Future<Profile> getProfile() async {
    // The endpoint 'relationships' is now correct.
    final response = await _dio.get('http://10.0.2.2:8000/api/v1/me');

    if (response.statusCode == 200) {
      // Directly parse the decoded list from dio.
      final String json = jsonEncode(response.data);
      return profileFromJson(json);
    } else {
      // Use a specific error message.
      throw Exception("Failed to load family relationships");
    }
  }

  Future<Profile> putProfile(Profile data) async {
    // The endpoint 'relationships' is now correct.
    final response = await _dio.put(
      'http://10.0.2.2:8000/api/v1/me',
      data: {
        "name": data.name,
        "phone": data.phone,
        "gender": data.gender,
        "date_of_birth": data.dateOfBirth,
      },
    );

    if (response.statusCode == 200) {
      // Directly parse the decoded list from dio.
      final String json = jsonEncode(response.data);
      return profileFromJson(json);
    } else {
      // Use a specific error message.
      throw Exception("Failed to load family relationships");
    }
  }
}
