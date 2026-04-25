import 'package:axiscore/src/shared/domain/user_profile.dart';

enum AnxietyBand {
  minimal,
  mild,
  moderate,
  high;

  String get label {
    switch (this) {
      case AnxietyBand.minimal:
        return 'Minimal';
      case AnxietyBand.mild:
        return 'Mild';
      case AnxietyBand.moderate:
        return 'Moderate';
      case AnxietyBand.high:
        return 'High';
    }
  }
}

class AssessmentResult {
  const AssessmentResult({
    required this.profile,
    required this.timelineDays,
    required this.anxietyBand,
    required this.primaryFocus,
    required this.recommendedTrackLabel,
  });

  final UserProfile profile;
  final int timelineDays;
  final AnxietyBand anxietyBand;
  final String primaryFocus;
  final String recommendedTrackLabel;

  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'timelineDays': timelineDays,
      'anxietyBand': anxietyBand.name,
      'primaryFocus': primaryFocus,
      'recommendedTrackLabel': recommendedTrackLabel,
    };
  }

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      timelineDays: json['timelineDays'] as int,
      anxietyBand: AnxietyBand.values.byName(json['anxietyBand'] as String),
      primaryFocus: json['primaryFocus'] as String,
      recommendedTrackLabel: json['recommendedTrackLabel'] as String,
    );
  }
}
