import 'package:app/data/presentation/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:async';
import 'dart:collection';

// Base URL configuration
const String BASE_URL = "http://10.0.2.2:8000/api/v1";

// Request limiter to prevent connection pool exhaustion
class RequestLimiter extends Interceptor {
  final int maxConcurrent;
  int _activeRequests = 0;
  final Queue<_PendingRequest> _queue = Queue();

  RequestLimiter({required this.maxConcurrent});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_activeRequests < maxConcurrent) {
      _activeRequests++;
      handler.next(options);
    } else {
      _queue.add(_PendingRequest(options, handler));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _activeRequests--;
    _processQueue();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _activeRequests--;
    _processQueue();
    handler.next(err);
  }

  void _processQueue() {
    if (_queue.isNotEmpty && _activeRequests < maxConcurrent) {
      final pending = _queue.removeFirst();
      _activeRequests++;
      pending.handler.next(pending.options);
    }
  }
}

class _PendingRequest {
  final RequestOptions options;
  final RequestInterceptorHandler handler;

  _PendingRequest(this.options, this.handler);
}

// Authenticated Dio Provider with proper connection management
final authenticatedDioProvider = Provider<Dio>((ref) {
  // 1. Watch your existing auth provider.
  // This will re-run when the user logs in or out.
  final authState = ref.watch(authStateChangeProvider).value;

  // 2. Check if the session is null. If so, the user is not logged in.
  if (authState?.session == null) {
    throw Exception('User is not authenticated.');
  }

  // 3. If a session exists, create and return the configured Dio instance.
  final dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      sendTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Configure HTTP client adapter for connection pooling
  try {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.maxConnectionsPerHost =
            3; // Limit concurrent connections per host
        client.connectionTimeout = Duration(seconds: 5);
        client.idleTimeout = Duration(seconds: 10);
        return client;
      },
    );
  } catch (e) {
    // Fallback if IOHttpClientAdapter is not available
    print('Warning: Could not configure HTTP client adapter: $e');
  }

  // Add request limiting interceptor
  dio.interceptors.add(RequestLimiter(maxConcurrent: 3));

  // Add authentication interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        try {
          // We know the session is not null here, so we can use the '!' operator safely.
          final session = Supabase.instance.client.auth.currentSession!;
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';

          // Log request for debugging (remove in production)
          print('🚀 ${options.method} ${options.path}');

          handler.next(options);
        } catch (e) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: 'Authentication error: $e',
              type: DioExceptionType.cancel,
            ),
          );
        }
      },
      onResponse: (response, handler) {
        // Log successful responses (remove in production)
        print('✅ ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        // Enhanced error logging and handling
        print(
          '❌ Error ${error.response?.statusCode} ${error.requestOptions.path}: ${error.message}',
        );

        // Handle specific authentication errors
        if (error.response?.statusCode == 401) {
          // Token might be expired, you might want to refresh or logout
          print('🔒 Authentication failed - token might be expired');
        }

        // Handle connection errors that might indicate pool exhaustion
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout) {
          print('🌐 Connection issue detected - possible server overload');
        }

        handler.next(error);
      },
    ),
  );

  // Add retry interceptor for failed requests
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        // Retry logic for specific errors
        if (_shouldRetry(error) &&
            error.requestOptions.extra['retryCount'] != null) {
          final retryCount = error.requestOptions.extra['retryCount'] as int;
          if (retryCount < 2) {
            // Max 2 retries
            error.requestOptions.extra['retryCount'] = retryCount + 1;

            // Exponential backoff
            await Future.delayed(Duration(seconds: (retryCount + 1) * 2));

            try {
              final response = await dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              handler.resolve(response);
              return;
            } catch (e) {
              // If retry fails, continue with original error
            }
          }
        }

        handler.next(error);
      },
    ),
  );

  // Set initial retry count for all requests
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['retryCount'] = 0;
        handler.next(options);
      },
    ),
  );

  return dio;
});

// Helper function to determine if a request should be retried
bool _shouldRetry(DioException error) {
  return error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError ||
      (error.response?.statusCode != null &&
          error.response!.statusCode! >= 500);
}
