import 'package:app/data/models/medicines.dart';
import 'package:app/data/models/metrics.model.dart';
import 'package:app/data/presentation/providers/dio.provider.dart';
import 'package:app/data/services/medicines.dart';
import 'package:app/data/services/metrics.services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider for the Dio instance (optional, but good for testing and global config)

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteMetricsProvider = Provider<RemoteMetricsService>((ref) {
  final dioInstance = ref.watch(authenticatedDioProvider);
  return RemoteMetricsService(dio: dioInstance); // Pass it to your service
});

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteMetricsProvider to get the service instance.
final metricsDataProvider = FutureProvider<List<Metrics>>((ref) async {
  final service = ref.watch(remoteMetricsProvider);
  await Future.delayed(const Duration(seconds: 2));
  return await service.getMetrics(); // getWelcomeData returns Future<Welcome>
});
