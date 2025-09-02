import 'package:app/core/utils/provider.utils.dart';
import 'package:app/features/family/data/datasources/family_remote_datasource.dart';
import 'package:app/features/family/data/models/family_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;

// 1. Provider for the Dio instance (optional, but good for testing and global config)

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteServiceFamilyProvider = createServiceProvider<RemoteFamilyService>(
  (dio) => RemoteFamilyService(dio: dio),
);

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
final familyDataProvider = FutureProvider<List<Family>>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final service = ref.watch(remoteServiceFamilyProvider);
  return await service.getFamily(); // getWelcomeData returns Future<Welcome>
});
