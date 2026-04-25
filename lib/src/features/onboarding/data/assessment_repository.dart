import 'package:axiscore/src/core/storage/local_axiscore_store.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_engine.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_input.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AssessmentRepository {
  Future<AssessmentResult> submitAssessment(AssessmentInput input);
}

class LocalAssessmentRepository implements AssessmentRepository {
  LocalAssessmentRepository({
    required LocalAxisCoreStore store,
    AssessmentEngine engine = const AssessmentEngine(),
  }) : _store = store,
       _engine = engine;

  final LocalAxisCoreStore _store;
  final AssessmentEngine _engine;

  @override
  Future<AssessmentResult> submitAssessment(AssessmentInput input) async {
    final result = _engine.evaluate(input);
    await _store.saveAssessmentResult(result);
    return result;
  }
}

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return LocalAssessmentRepository(
    store: ref.watch(localAxisCoreStoreProvider),
  );
});
