// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services//auth.dart';

// This will generate the necessary providers for us
part 'auth_provider.g.dart';

// 1. The provider for the authentication service
@riverpod
AuthService authService(Ref ref) {
  final supabaseClient = Supabase.instance.client;
  return AuthService(supabaseClient);
}

// 2. The provider that listens to auth state changes
@riverpod
Stream<AuthState> authStateChange(Ref ref) {
  // Watch the service provider and return the stream
  return ref.watch(authServiceProvider).authStateChanges;
}
