import 'package:app/core/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import your existing auth provider

final appStartupProvider = FutureProvider<void>((ref) async {
  // By watching the .future, this provider will not complete until the
  // first value from the authStateChangeProvider is received.
  await ref.watch(authStateChangeProvider.future);
});
