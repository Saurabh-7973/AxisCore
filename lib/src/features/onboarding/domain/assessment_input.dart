import 'package:axiscore/src/shared/domain/user_profile.dart';

class AssessmentInput {
  const AssessmentInput({
    required this.yearsOfUse,
    required this.hasEscalationPattern,
    required this.gad7Score,
    required this.averageIeltSeconds,
    required this.controlRating,
    required this.relationshipStatus,
    required this.goalType,
  });

  final int yearsOfUse;
  final bool hasEscalationPattern;
  final int gad7Score;
  final int averageIeltSeconds;
  final int controlRating;
  final RelationshipStatus relationshipStatus;
  final GoalType goalType;
}
