import 'package:axiscore/src/features/auth/data/local_auth_repository.dart';
import 'package:axiscore/src/features/auth/domain/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalAuthRepository', () {
    test('signs up and persists the current user locally', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalAuthRepository(preferences);

      final user = await repository.signUpWithEmail(
        email: 'marcus@example.com',
        password: 'control90',
      );

      expect(user.email, 'marcus@example.com');
      expect(repository.currentUser?.email, 'marcus@example.com');

      final restoredRepository = LocalAuthRepository(preferences);
      expect(restoredRepository.currentUser?.email, 'marcus@example.com');
    });

    test('rejects invalid local email credentials', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalAuthRepository(preferences);

      expect(
        () => repository.signInWithEmail(
          email: 'not-an-email',
          password: 'control90',
        ),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('clears the current user on sign out', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalAuthRepository(preferences);

      await repository.signInWithEmail(
        email: 'jay@example.com',
        password: 'control90',
      );
      await repository.signOut();

      expect(repository.currentUser, isNull);
    });
  });
}
