import 'package:app/data/models/medicines.dart';
import 'package:app/data/presentation/providers/dio.provider.dart';
import 'package:app/data/services/medicines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider for the Dio instance (optional, but good for testing and global config)

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteServiceMedicinesProvider = Provider<RemoteServiceMedicines>((ref) {
  final dioInstance = ref.watch(authenticatedDioProvider);
  return RemoteServiceMedicines(dio: dioInstance); // Pass it to your service
});

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
final medicineDataProvider = FutureProvider<List<Medicines>>((ref) async {
  final service = ref.watch(remoteServiceMedicinesProvider);
  return await service.getMedicines(); // getWelcomeData returns Future<Welcome>
});
