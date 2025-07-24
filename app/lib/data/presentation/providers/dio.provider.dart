import 'package:app/data/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import your existing auth provider

final authenticatedDioProvider = Provider<Dio>((ref) {
  // 1. Watch your existing auth provider.
  // This will re-run when the user logs in or out.
  final authState = ref.watch(authStateChangeProvider).value;

  // 2. Check if the session is null. If so, the user is not logged in.
  if (authState?.session == null) {
    throw Exception('User is not authenticated.');
  }

  // 3. If a session exists, create and return the configured Dio instance.
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // We know the session is not null here, so we can use the '!' operator safely.
        final session = Supabase.instance.client.auth.currentSession!;
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        return handler.next(options);
      },
    ),
  );
  return dio;
});
