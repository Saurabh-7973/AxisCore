import 'package:axiscore/src/features/onboarding/domain/assessment_input.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_result.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';

export 'assessment_result.dart' show AnxietyBand;

class AssessmentEngine {
  const AssessmentEngine();

  AssessmentResult evaluate(AssessmentInput input) {
    final profile = UserProfile(
      severityTier: _severityFor(input),
      goalType: input.goalType,
      relationshipStatus: input.relationshipStatus,
    );

    return AssessmentResult(
      profile: profile,
      timelineDays: 90,
      anxietyBand: _anxietyBandFor(input.gad7Score),
      primaryFocus: _primaryFocusFor(input.goalType),
      recommendedTrackLabel: _trackLabelFor(input.goalType),
    );
  }

  SeverityTier _severityFor(AssessmentInput input) {
    var score = 0;

    if (input.yearsOfUse >= 8) {
      score += 3;
    } else if (input.yearsOfUse >= 4) {
      score += 2;
    } else if (input.yearsOfUse >= 2) {
      score += 1;
    }

    if (input.hasEscalationPattern) {
      score += 2;
    }

    if (input.gad7Score >= 15) {
      score += 2;
    } else if (input.gad7Score >= 5) {
      score += 1;
    }

    if (input.averageIeltSeconds < 60) {
      score += 2;
    } else if (input.averageIeltSeconds < 180) {
      score += 1;
    }

    if (input.controlRating <= 1) {
      score += 2;
    } else if (input.controlRating <= 3) {
      score += 1;
    }

    if (score >= 7) {
      return SeverityTier.severe;
    }
    if (score >= 3) {
      return SeverityTier.moderate;
    }
    return SeverityTier.mild;
  }

  AnxietyBand _anxietyBandFor(int gad7Score) {
    if (gad7Score >= 15) {
      return AnxietyBand.high;
    }
    if (gad7Score >= 10) {
      return AnxietyBand.moderate;
    }
    if (gad7Score >= 5) {
      return AnxietyBand.mild;
    }
    return AnxietyBand.minimal;
  }

  String _primaryFocusFor(GoalType goalType) {
    switch (goalType) {
      case GoalType.recovery:
        return 'Reset foundation';
      case GoalType.control:
        return 'Control training';
      case GoalType.mastery:
        return 'Mastery progression';
    }
  }

  String _trackLabelFor(GoalType goalType) {
    switch (goalType) {
      case GoalType.recovery:
        return '90-day foundation';
      case GoalType.control:
        return '90-day Control progression';
      case GoalType.mastery:
        return '90-day Mastery progression';
    }
  }
}
