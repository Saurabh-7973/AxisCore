import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:axiscore/src/shared/domain/date_keys.dart';

class ProgressEngine {
  const ProgressEngine();

  ProgressSnapshot completeSession(
    ProgressSnapshot current,
    DailyProtocolSession session, {
    required DateTime completedAt,
  }) {
    final completedDate = dateKey(completedAt);
    if (current.completedSessionDates.contains(completedDate)) {
      return current;
    }

    final completedDates = [...current.completedSessionDates, completedDate]
      ..sort();
    final firstDate = current.firstSessionDate ?? completedDate;
    final lastDate = current.lastSessionDate;
    final nextStreak = _nextStreak(
      current.currentStreak,
      lastDate,
      completedDate,
    );
    final calendarDays = daysBetweenKeys(firstDate, completedDate) + 1;
    final consistency = ((completedDates.length / calendarDays) * 100).round();

    return current.copyWith(
      currentStreak: nextStreak,
      longestStreak: nextStreak > current.longestStreak
          ? nextStreak
          : current.longestStreak,
      consistencyPercent: consistency,
      totalSessionsCompleted: completedDates.length,
      completedSessionDates: List.unmodifiable(completedDates),
      firstSessionDate: firstDate,
      lastSessionDate: completedDate,
    );
  }

  int _nextStreak(int currentStreak, String? lastDate, String completedDate) {
    if (lastDate == null) {
      return 1;
    }
    final gap = daysBetweenKeys(lastDate, completedDate);
    if (gap == 1) {
      return currentStreak + 1;
    }
    if (gap == 0) {
      return currentStreak;
    }
    return 1;
  }
}
