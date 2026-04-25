import 'dart:convert';

import 'package:axiscore/src/features/onboarding/domain/assessment_result.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:axiscore/src/core/storage/shared_preferences_provider.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAxisCoreStore {
  LocalAxisCoreStore(this._preferences);

  static const _profileKey = 'axiscore.profile';
  static const _assessmentResultKey = 'axiscore.assessment_result';
  static const _progressKey = 'axiscore.progress';
  static const _panicCountKey = 'axiscore.panic_count';

  final SharedPreferences _preferences;

  UserProfile? readProfile() {
    final raw = _preferences.getString(_profileKey);
    if (raw == null) {
      return null;
    }
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  AssessmentResult? readAssessmentResult() {
    final raw = _preferences.getString(_assessmentResultKey);
    if (raw == null) {
      return null;
    }
    return AssessmentResult.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  ProgressSnapshot readProgress() {
    final raw = _preferences.getString(_progressKey);
    if (raw == null) {
      return ProgressSnapshot.initial();
    }
    return ProgressSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  int readPanicCount() => _preferences.getInt(_panicCountKey) ?? 0;

  Future<void> saveAssessmentResult(AssessmentResult result) async {
    await _preferences.setString(
      _assessmentResultKey,
      jsonEncode(result.toJson()),
    );
    await _preferences.setString(_profileKey, jsonEncode(result.profile));
  }

  Future<void> saveProgress(ProgressSnapshot progress) async {
    await _preferences.setString(_progressKey, jsonEncode(progress.toJson()));
  }

  Future<int> incrementPanicCount() async {
    final nextCount = readPanicCount() + 1;
    await _preferences.setInt(_panicCountKey, nextCount);
    return nextCount;
  }
}

final localAxisCoreStoreProvider = Provider<LocalAxisCoreStore>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  return LocalAxisCoreStore(preferences);
});
