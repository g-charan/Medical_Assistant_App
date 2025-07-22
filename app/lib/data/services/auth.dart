// lib/data/services/auth_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // A stream to notify the app of authentication changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign In
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      // Re-throw a more user-friendly error
      throw Exception('Error signing in: ${e.message}');
    }
  }

  // Sign Up
  Future<void> signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      // FIX: Added the Supabase sign-up logic
      await _supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      // Re-throw a more user-friendly error
      throw Exception('Error signing up: ${e.message}');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
