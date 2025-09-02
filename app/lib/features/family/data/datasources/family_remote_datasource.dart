import 'dart:convert';
import 'package:app/core/config/config.services.dart';
import 'package:app/features/family/data/models/family_model.dart';
import 'package:dio/dio.dart';

final _url = "/relationships/";

class RemoteFamilyService extends ConfigServices {
  RemoteFamilyService({required Dio dio}) : super(dio: dio);

  Future<List<Family>> getFamily() async {
    try {
      final response = await dio.get(_url);

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return familyFromJson(json);
      } else {
        throw Exception(
          "Failed to load family relationships: ${response.statusCode}",
        );
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
      throw Exception("Unexpected error loading family relationships: $e");
    }
  }
}
