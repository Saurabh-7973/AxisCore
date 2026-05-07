import 'package:axiscore/src/features/auth/data/auth_repository.dart';
import 'package:axiscore/src/features/auth/domain/app_user.dart';
import 'package:axiscore/src/features/auth/domain/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final supabase.SupabaseClient _client;

  @override
  AppUser? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Stream<AppUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map(
      (event) => _mapUser(event.session?.user),
    );
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = _mapUser(response.user);
      if (user == null) {
        throw const AuthFailure('Could not sign in with those credentials.');
      }
      return user;
    } on supabase.AuthException catch (error) {
      throw AuthFailure(error.message);
    }
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      final user = _mapUser(response.user);
      if (user == null) {
        throw const AuthFailure(
          'Check your email to finish creating the account.',
        );
      }
      return user;
    } on supabase.AuthException catch (error) {
      throw AuthFailure(error.message);
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  AppUser? _mapUser(supabase.User? user) {
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      return null;
    }
    return AppUser(id: user.id, email: email);
  }
}
