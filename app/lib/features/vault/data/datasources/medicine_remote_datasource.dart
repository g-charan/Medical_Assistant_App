import 'dart:convert';
import 'package:app/core/config/config.services.dart';
import 'package:app/features/auth/data/models/medicines.dart';
import 'package:dio/dio.dart';

final _url = "/medicines";

class RemoteServiceMedicines extends ConfigServices {
  RemoteServiceMedicines({required Dio dio}) : super(dio: dio);

  Future<List<Medicines>> getMedicines() async {
    try {
      final response = await dio.get(_url);

      if (response.statusCode == 200) {
        final String json = jsonEncode(response.data);
        return medicinesFromJson(json);
      } else {
        throw Exception("Failed to load medicines: ${response.statusCode}");
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
      throw Exception("Unexpected error loading medicines: $e");
    }
  }
}
