import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import your existing auth provider
import 'package:app/data/presentation/providers/auth_provider.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // By watching the .future, this provider will not complete until the
  // first value from the authStateChangeProvider is received.
  await ref.watch(authStateChangeProvider.future);
});
