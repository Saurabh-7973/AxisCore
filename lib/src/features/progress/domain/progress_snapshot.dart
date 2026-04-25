import 'package:axiscore/src/features/progress/domain/milestone.dart';

class ProgressSnapshot {
  const ProgressSnapshot({
    required this.currentStreak,
    required this.longestStreak,
    required this.consistencyPercent,
    required this.totalSessionsCompleted,
    required this.completedSessionDates,
    this.firstSessionDate,
    this.lastSessionDate,
  });

  final int currentStreak;
  final int longestStreak;
  final int consistencyPercent;
  final int totalSessionsCompleted;
  final List<String> completedSessionDates;
  final String? firstSessionDate;
  final String? lastSessionDate;

  Milestone get nextMilestone => Milestone.nextFor(totalSessionsCompleted);

  factory ProgressSnapshot.initial() {
    return const ProgressSnapshot(
      currentStreak: 0,
      longestStreak: 0,
      consistencyPercent: 0,
      totalSessionsCompleted: 0,
      completedSessionDates: [],
    );
  }

  ProgressSnapshot copyWith({
    int? currentStreak,
    int? longestStreak,
    int? consistencyPercent,
    int? totalSessionsCompleted,
    List<String>? completedSessionDates,
    String? firstSessionDate,
    String? lastSessionDate,
  }) {
    return ProgressSnapshot(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      consistencyPercent: consistencyPercent ?? this.consistencyPercent,
      totalSessionsCompleted:
          totalSessionsCompleted ?? this.totalSessionsCompleted,
      completedSessionDates:
          completedSessionDates ??
          List.unmodifiable(this.completedSessionDates),
      firstSessionDate: firstSessionDate ?? this.firstSessionDate,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'consistencyPercent': consistencyPercent,
      'totalSessionsCompleted': totalSessionsCompleted,
      'completedSessionDates': completedSessionDates,
      'firstSessionDate': firstSessionDate,
      'lastSessionDate': lastSessionDate,
    };
  }

  factory ProgressSnapshot.fromJson(Map<String, dynamic> json) {
    return ProgressSnapshot(
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      consistencyPercent: json['consistencyPercent'] as int,
      totalSessionsCompleted: json['totalSessionsCompleted'] as int,
      completedSessionDates: List<String>.from(
        json['completedSessionDates'] as List<dynamic>,
      ),
      firstSessionDate: json['firstSessionDate'] as String?,
      lastSessionDate: json['lastSessionDate'] as String?,
    );
  }
}
