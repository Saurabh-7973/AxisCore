import 'package:axiscore/src/core/config/app_config.dart';
import 'package:axiscore/src/core/storage/shared_preferences_provider.dart';
import 'package:axiscore/src/core/supabase/supabase_client_provider.dart';
import 'package:axiscore/src/features/auth/data/local_auth_repository.dart';
import 'package:axiscore/src/features/auth/data/supabase_auth_repository.dart';
import 'package:axiscore/src/features/auth/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  AppUser? get currentUser;

  Stream<AppUser?> get authStateChanges;

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);

  if (config.hasSupabase) {
    final client = ref.watch(supabaseClientProvider);
    if (client == null) {
      return LocalAuthRepository(ref.watch(sharedPreferencesProvider));
    }
    return SupabaseAuthRepository(client);
  }

  return LocalAuthRepository(ref.watch(sharedPreferencesProvider));
});
