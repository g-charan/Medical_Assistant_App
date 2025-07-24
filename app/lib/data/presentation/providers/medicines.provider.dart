import 'package:app/data/models/medicines.dart';
import 'package:app/data/services/medicines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. Provider for the Dio instance (optional, but good for testing and global config)
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // 1. Get the current user session from Supabase
        final session = Supabase.instance.client.auth.currentSession;

        // 2. If a session exists, add the auth token to the header
        if (session != null) {
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        }

        // 3. Continue with the request
        return handler.next(options);
      },
    ),
  );

  return dio;
});

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteServiceMedicinesProvider = Provider<RemoteServiceMedicines>((ref) {
  final dioInstance = ref.watch(dioProvider);
  return RemoteServiceMedicines(dio: dioInstance); // Pass it to your service
});

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
final medicineDataProvider = FutureProvider<List<Medicines>>((ref) async {
  final service = ref.watch(remoteServiceMedicinesProvider);
  return await service.getMedicines(); // getWelcomeData returns Future<Welcome>
});
