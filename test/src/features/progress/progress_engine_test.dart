import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/progress/domain/progress_engine.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProgressEngine', () {
    test('starts streak and consistency on first completion', () {
      final session = DailyProtocolSession.reset(
        dayNumber: 1,
        date: DateTime(2026, 4, 25),
      );

      final progress = const ProgressEngine().completeSession(
        ProgressSnapshot.initial(),
        session,
        completedAt: DateTime(2026, 4, 25, 9),
      );

      expect(progress.currentStreak, 1);
      expect(progress.longestStreak, 1);
      expect(progress.consistencyPercent, 100);
      expect(progress.totalSessionsCompleted, 1);
      expect(progress.nextMilestone.label, 'First Week');
    });

    test('does not double count a second completion on the same day', () {
      final session = DailyProtocolSession.reset(
        dayNumber: 1,
        date: DateTime(2026, 4, 25),
      );
      final engine = const ProgressEngine();

      final first = engine.completeSession(
        ProgressSnapshot.initial(),
        session,
        completedAt: DateTime(2026, 4, 25, 9),
      );
      final second = engine.completeSession(
        first,
        session,
        completedAt: DateTime(2026, 4, 25, 21),
      );

      expect(second.currentStreak, 1);
      expect(second.totalSessionsCompleted, 1);
      expect(second.completedSessionDates, ['2026-04-25']);
    });

    test(
      'restarts current streak after a missed day while keeping longest',
      () {
        final prior = ProgressSnapshot.initial().copyWith(
          currentStreak: 7,
          longestStreak: 7,
          totalSessionsCompleted: 7,
          firstSessionDate: '2026-04-18',
          lastSessionDate: '2026-04-24',
          completedSessionDates: const [
            '2026-04-18',
            '2026-04-19',
            '2026-04-20',
            '2026-04-21',
            '2026-04-22',
            '2026-04-23',
            '2026-04-24',
          ],
        );
        final session = DailyProtocolSession.reset(
          dayNumber: 8,
          date: DateTime(2026, 4, 26),
        );

        final progress = const ProgressEngine().completeSession(
          prior,
          session,
          completedAt: DateTime(2026, 4, 26, 8),
        );

        expect(progress.currentStreak, 1);
        expect(progress.longestStreak, 7);
        expect(progress.consistencyPercent, 89);
      },
    );
  });
}
