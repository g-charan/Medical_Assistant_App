import 'package:app/core/utils/provider.utils.dart';
import 'package:app/features/stats/data/datasources/metrics_remote_datasource.dart';
import 'package:app/features/stats/data/models/metrics_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider for the Dio instance (optional, but good for testing and global config)

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteMetricsProvider = createServiceProvider<RemoteMetricsService>(
  (dio) => RemoteMetricsService(dio: dio),
);

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteMetricsProvider to get the service instance.
final metricsDataProvider = FutureProvider<List<Metrics>>((ref) async {
  final service = ref.watch(remoteMetricsProvider);
  await Future.delayed(const Duration(seconds: 2));
  return await service.getMetrics(); // getWelcomeData returns Future<Welcome>
});
