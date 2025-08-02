import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/data/presentation/providers/dio.provider.dart';
// Make sure authenticatedDioProvider is defined and accessible here.
// final authenticatedDioProvider = Provider<Dio>((ref) => ...);

/// A factory for creating an API service provider.
/// It automatically uses the 'authenticatedDioProvider'.
///
/// - [T] is the type of the service to be created.
/// - [create] is the constructor of the service (e.g., `RemoteMetricsService.new`).
Provider<T> createServiceProvider<T>(T Function(Dio dio) create) {
  return Provider<T>((ref) {
    final dio = ref.watch(authenticatedDioProvider);
    return create(dio);
  });
}
