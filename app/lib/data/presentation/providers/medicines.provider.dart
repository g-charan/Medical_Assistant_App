import 'package:app/common/utils/provider.utils.dart';
import 'package:app/data/models/medicines.dart';
import 'package:app/data/services/medicines.services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider for the Dio instance (optional, but good for testing and global config)

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteServiceMedicinesProvider =
    createServiceProvider<RemoteServiceMedicines>(
      (dio) => RemoteServiceMedicines(dio: dio),
    );

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
final medicineDataProvider = FutureProvider<List<Medicines>>((ref) async {
  final service = ref.watch(remoteServiceMedicinesProvider);
  return await service.getMedicines(); // getWelcomeData returns Future<Welcome>
});

// In your providers file (e.g., vault.providers.dart)
final showAddMedicineDialogProvider = StateProvider<bool>((ref) => false);
