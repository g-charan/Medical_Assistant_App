// lib/providers/refresh_controller_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

final refreshControllerProvider = Provider.autoDispose<RefreshController>((
  ref,
) {
  final controller = RefreshController(initialRefresh: false);
  // Ensure the controller is disposed when the provider is no longer used
  ref.onDispose(() => controller.dispose());
  return controller;
});
