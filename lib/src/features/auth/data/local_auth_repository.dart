import 'dart:async';
import 'dart:convert';

import 'package:axiscore/src/features/auth/data/auth_repository.dart';
import 'package:axiscore/src/features/auth/domain/app_user.dart';
import 'package:axiscore/src/features/auth/domain/auth_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._preferences) {
    _controller = StreamController<AppUser?>.broadcast(
      onListen: () => _controller.add(currentUser),
    );
  }

  static const _userKey = 'axiscore.auth.user';

  final SharedPreferences _preferences;
  late final StreamController<AppUser?> _controller;

  @override
  AppUser? get currentUser {
    final raw = _preferences.getString(_userKey);
    if (raw == null) {
      return null;
    }
    return AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Stream<AppUser?> get authStateChanges => _controller.stream;

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _authenticate(email: email, password: password);
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _authenticate(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _preferences.remove(_userKey);
    _controller.add(null);
  }

  Future<AppUser> _authenticate({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_looksLikeEmail(normalizedEmail)) {
      throw const AuthFailure('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw const AuthFailure('Password must be at least 6 characters.');
    }

    final user = AppUser(id: 'local:$normalizedEmail', email: normalizedEmail);
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
    _controller.add(user);
    return user;
  }

  bool _looksLikeEmail(String value) {
    return value.contains('@') && value.contains('.');
  }
}
