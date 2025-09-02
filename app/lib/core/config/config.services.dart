import 'package:dio/dio.dart';

class ConfigServices {
  final Dio _dio;

  ConfigServices({required Dio dio}) : _dio = dio;

  Dio get dio => _dio;
}

// Create a single, well-configured Dio provider
