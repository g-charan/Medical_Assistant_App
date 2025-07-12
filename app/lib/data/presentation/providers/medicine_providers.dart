import 'package:app/data/services/medicines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:app/data/models/welcomeJson.dart';

// 1. Provider for the Dio instance (optional, but good for testing and global config)
final dioProvider = Provider<Dio>((ref) => Dio());

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteServiceMedicinesProvider = Provider<RemoteServiceMedicines>((ref) {
  final dioInstance = ref.watch(dioProvider);
  return RemoteServiceMedicines(dio: dioInstance); // Pass it to your service
});

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
final welcomeDataProvider = FutureProvider<Welcome>((ref) async {
  final service = ref.watch(remoteServiceMedicinesProvider);
  return await service
      .getWelcomeData(); // getWelcomeData returns Future<Welcome>
});
