import 'package:axiscore/src/features/onboarding/domain/assessment_engine.dart';
import 'package:axiscore/src/features/onboarding/domain/assessment_input.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssessmentEngine', () {
    test('classifies a low-risk starter profile as mild', () {
      final input = AssessmentInput(
        yearsOfUse: 1,
        hasEscalationPattern: false,
        gad7Score: 3,
        averageIeltSeconds: 360,
        controlRating: 4,
        relationshipStatus: RelationshipStatus.solo,
        goalType: GoalType.recovery,
      );

      final result = const AssessmentEngine().evaluate(input);

      expect(result.profile.severityTier, SeverityTier.mild);
      expect(result.timelineDays, 90);
      expect(result.anxietyBand, AnxietyBand.minimal);
      expect(result.primaryFocus, 'Reset foundation');
    });

    test('weights anxiety, short IELT, and low control into severe tier', () {
      final input = AssessmentInput(
        yearsOfUse: 9,
        hasEscalationPattern: true,
        gad7Score: 17,
        averageIeltSeconds: 45,
        controlRating: 1,
        relationshipStatus: RelationshipStatus.partnered,
        goalType: GoalType.control,
      );

      final result = const AssessmentEngine().evaluate(input);

      expect(result.profile.severityTier, SeverityTier.severe);
      expect(result.anxietyBand, AnxietyBand.high);
      expect(result.primaryFocus, 'Control training');
      expect(result.profile.goalType, GoalType.control);
    });

    test('keeps mastery-oriented users in an optimization frame', () {
      final input = AssessmentInput(
        yearsOfUse: 3,
        hasEscalationPattern: false,
        gad7Score: 6,
        averageIeltSeconds: 240,
        controlRating: 3,
        relationshipStatus: RelationshipStatus.solo,
        goalType: GoalType.mastery,
      );

      final result = const AssessmentEngine().evaluate(input);

      expect(result.profile.severityTier, SeverityTier.moderate);
      expect(result.anxietyBand, AnxietyBand.mild);
      expect(result.primaryFocus, 'Mastery progression');
      expect(result.recommendedTrackLabel, '90-day Mastery progression');
    });
  });
}
