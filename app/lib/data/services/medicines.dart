import 'dart:convert';

import 'package:app/data/models/welcomeJson.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteServiceMedicines {
  final Dio _dio;
  RemoteServiceMedicines({required Dio dio}) : _dio = dio;
  // This class is intended to handle remote service interactions for medicines.
  // Currently, it does not contain any methods or properties.

  // Future methods for fetching, updating, or deleting medicine data can be added here.
  Future<Welcome> getWelcomeData() async {
    // This method is a placeholder for fetching welcome data.
    // It should be implemented to return a list of Welcome objects.

    var response = await _dio.get(
      'http://10.0.2.2:8000/medicine?name=dolo%20650',
    );
    if (response.statusCode == 200) {
      final String json = jsonEncode(response.data);
      // If the server returns an OK response, parse the JSON.
      return welcomeFromJson(json);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load welcome data');
    }
  }
}
