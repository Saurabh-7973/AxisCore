import 'package:axiscore/src/core/storage/local_axiscore_store.dart';
import 'package:axiscore/src/features/daily_protocol/domain/protocol_engine.dart';
import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/onboarding/data/assessment_repository.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_input.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_result.dart';
import 'package:axiscore/src/features/panic/data/panic_repository.dart';
import 'package:axiscore/src/features/panic/domain/panic_protocol.dart';
import 'package:axiscore/src/features/progress/data/progress_repository.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSession {
  const AppSession({
    required this.progress,
    required this.panicEventCount,
    this.profile,
    this.assessmentResult,
  });

  final UserProfile? profile;
  final AssessmentResult? assessmentResult;
  final ProgressSnapshot progress;
  final int panicEventCount;

  bool get hasProfile => profile != null;

  AppSession copyWith({
    UserProfile? profile,
    AssessmentResult? assessmentResult,
    ProgressSnapshot? progress,
    int? panicEventCount,
  }) {
    return AppSession(
      profile: profile ?? this.profile,
      assessmentResult: assessmentResult ?? this.assessmentResult,
      progress: progress ?? this.progress,
      panicEventCount: panicEventCount ?? this.panicEventCount,
    );
  }
}

class AppSessionController extends Notifier<AppSession> {
  @override
  AppSession build() {
    final store = ref.watch(localAxisCoreStoreProvider);
    return AppSession(
      profile: store.readProfile(),
      assessmentResult: store.readAssessmentResult(),
      progress: store.readProgress(),
      panicEventCount: store.readPanicCount(),
    );
  }

  Future<AssessmentResult> submitAssessment(AssessmentInput input) async {
    final result = await ref
        .read(assessmentRepositoryProvider)
        .submitAssessment(input);
    state = state.copyWith(profile: result.profile, assessmentResult: result);
    return result;
  }

  Future<ProgressSnapshot> completeSession(DailyProtocolSession session) async {
    final progress = await ref
        .read(progressRepositoryProvider)
        .completeSession(session);
    state = state.copyWith(progress: progress);
    return progress;
  }

  Future<PanicProtocol> logPanicEvent() async {
    final protocol = await ref.read(panicRepositoryProvider).logPanicEvent();
    state = state.copyWith(panicEventCount: protocol.eventCount);
    return protocol;
  }
}

final appSessionControllerProvider =
    NotifierProvider<AppSessionController, AppSession>(
      AppSessionController.new,
    );

final todayProtocolProvider = Provider<DailyProtocolSession?>((ref) {
  final session = ref.watch(appSessionControllerProvider);
  final profile = session.profile;
  if (profile == null) {
    return null;
  }

  return const ProtocolEngine().sessionFor(
    profile: profile,
    progress: session.progress,
    now: DateTime.now(),
  );
});
