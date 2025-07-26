import 'package:app/data/models/profile.models.dart';
import 'package:app/data/presentation/providers/dio.provider.dart';
import 'package:app/data/models/family.models.dart';
import 'package:app/data/services/family.services.dart';
import 'package:app/data/services/profile.services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;

// 1. Provider for the Dio instance (optional, but good for testing and global config)

// 2. Provider for your RemoteServiceMedicines instance
// It depends on dioProvider, so Riverpod manages the creation order.
final remoteProfileProvider = Provider<RemoteProfileService>((ref) {
  final dioInstance = ref.watch(authenticatedDioProvider);
  return RemoteProfileService(dio: dioInstance); // Pass it to your service
});

// 3. FutureProvider for fetching the Welcome data
// It depends on remoteServiceMedicinesProvider to get the service instance.
final profileDataProvider = FutureProvider<Profile>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final service = ref.watch(remoteProfileProvider);
  return await service.getProfile(); // getWelcomeData returns Future<Welcome>
});

class ProfileUpdateNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial work needed for a mutation.
    return;
  }

  // This is the public method you will call from your UI.
  // It accepts the data from the screen.
  Future<void> updateProfile(Profile data) async {
    // Set the state to loading.
    state = const AsyncLoading();

    try {
      // 2. Await the future from the service.
      await ref.read(remoteProfileProvider).putProfile(data);
      // 3. If successful, set the state to data. For a void type, the data is null.
      state = const AsyncData(null);
    } catch (err, stack) {
      // 4. If an error occurs, set the state to error.
      state = AsyncError(err, stack);
    }
  }
}

final profileUpdateNotifierProvider =
    AsyncNotifierProvider.autoDispose<ProfileUpdateNotifier, void>(() {
      return ProfileUpdateNotifier();
    });
