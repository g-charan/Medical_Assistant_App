import 'dart:convert';
import 'package:app/data/models/ai.models.dart';
import 'package:app/data/services/config.services.dart';
import 'package:dio/dio.dart';

final _url = "/ai";

class RemoteServiceAi extends ConfigServices {
  RemoteServiceAi({required Dio dio}) : super(dio: dio);

  Future<AiChat> getAi() async {
    try {
      final response = await dio.get("$_url/chat");

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return aiChatFromJson(json);
      } else {
        throw Exception("Failed to load Ai: ${response.statusCode}");
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
      throw Exception("Unexpected error loading Ai: $e");
    }
  }

  Future<AiResponse> postChat(AiChat data) async {
    try {
      final response = await dio.post(
        "$_url/chat",
        data: {"medicine_id": data.medicineId, "prompt": data.prompt},
      );

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return aiResponseFromJson(json);
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

  Future<OcrResponse> postOcr(Ocr data) async {
    try {
      final response = await dio.post(
        "$_url/ocr-analyze",
        data: {"text": data.text},
      );

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return ocrResponseFromJson(json);
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
