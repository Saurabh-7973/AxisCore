import 'dart:async';

import 'package:axiscore/src/features/auth/data/auth_repository.dart';
import 'package:axiscore/src/features/auth/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({required this.isLoading, this.user, this.errorMessage});

  final AppUser? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isSignedIn => user != null;

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  StreamSubscription<AppUser?>? _subscription;

  @override
  AuthState build() {
    final repository = ref.watch(authRepositoryProvider);
    _subscription?.cancel();
    _subscription = repository.authStateChanges.listen((user) {
      state = state.copyWith(user: user, clearUser: user == null);
    });
    ref.onDispose(() => _subscription?.cancel());

    return AuthState(isLoading: false, user: repository.currentUser);
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password),
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(
      () => ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthState(isLoading: false);
  }

  Future<void> _runAuthAction(Future<AppUser> Function() action) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await action();
      state = AuthState(isLoading: false, user: user);
    } catch (error) {
      state = AuthState(isLoading: false, errorMessage: error.toString());
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
