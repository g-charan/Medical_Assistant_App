import 'dart:convert';
import 'package:app/core/config/config.services.dart';
import 'package:app/features/settings/data/models/profile_model.dart';
import 'package:dio/dio.dart';

final _url = "/profiles/me";

class RemoteProfileService extends ConfigServices {
  RemoteProfileService({required Dio dio}) : super(dio: dio);

  Future<Profile> getProfile() async {
    try {
      final response = await dio.get(_url);

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return profileFromJson(json);
      } else {
        throw Exception("Failed to load profile: ${response.statusCode}");
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Connection timeout - server may be overloaded");
        case DioExceptionType.receiveTimeout:
          throw Exception("Server response timeout");
        case DioExceptionType.connectionError:
          throw Exception("Connection error - check your network");
        case DioExceptionType.badResponse:
          throw Exception("Server error: ${e.response?.statusCode}");
        default:
          throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error loading profile: $e");
    }
  }

  Future<Profile> putProfile(Profile data) async {
    try {
      final response = await dio.put(
        _url,
        data: {
          "name": data.name,
          "phone": data.phone,
          "gender": data.gender,
          "date_of_birth": data.dateOfBirth,
        },
      );

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return profileFromJson(json);
      } else {
        throw Exception("Failed to update profile: ${response.statusCode}");
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Connection timeout - server may be overloaded");
        case DioExceptionType.receiveTimeout:
          throw Exception("Server response timeout");
        case DioExceptionType.connectionError:
          throw Exception("Connection error - check your network");
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 400) {
            throw Exception("Invalid profile data provided");
          } else if (e.response?.statusCode == 404) {
            throw Exception("Profile not found");
          } else {
            throw Exception("Server error: ${e.response?.statusCode}");
          }
        case DioExceptionType.sendTimeout:
          throw Exception("Upload timeout - check your connection");
        default:
          throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error updating profile: $e");
    }
  }
}
