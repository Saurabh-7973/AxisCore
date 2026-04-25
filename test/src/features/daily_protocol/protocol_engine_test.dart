import 'package:axiscore/src/features/daily_protocol/domain/protocol_engine.dart';
import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProtocolEngine', () {
    test('builds the phase 1 reset session for a new user', () {
      final session = const ProtocolEngine().sessionFor(
        profile: UserProfile(
          severityTier: SeverityTier.moderate,
          goalType: GoalType.recovery,
          relationshipStatus: RelationshipStatus.solo,
        ),
        progress: ProgressSnapshot.initial(),
        now: DateTime(2026, 4, 25),
      );

      expect(session.phase, ProtocolPhase.reset);
      expect(session.title, 'Day 1 Reset Protocol');
      expect(session.totalMinutes, 15);
      expect(session.blocks.map((block) => block.kind), [
        ProtocolBlockKind.education,
        ProtocolBlockKind.mobility,
        ProtocolBlockKind.breathwork,
      ]);
    });

    test('moves to control phase after eight completed weeks', () {
      final progress = ProgressSnapshot.initial().copyWith(
        currentStreak: 64,
        longestStreak: 64,
        totalSessionsCompleted: 64,
      );

      final session = const ProtocolEngine().sessionFor(
        profile: UserProfile(
          severityTier: SeverityTier.severe,
          goalType: GoalType.control,
          relationshipStatus: RelationshipStatus.partnered,
        ),
        progress: progress,
        now: DateTime(2026, 4, 25),
      );

      expect(session.phase, ProtocolPhase.control);
      expect(session.title, 'Day 65 Control Protocol');
      expect(session.blocks.last.title, 'Stop-start awareness');
    });
  });
}
