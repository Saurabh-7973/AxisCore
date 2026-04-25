enum SeverityTier {
  mild,
  moderate,
  severe;

  String get label {
    switch (this) {
      case SeverityTier.mild:
        return 'Mild';
      case SeverityTier.moderate:
        return 'Moderate';
      case SeverityTier.severe:
        return 'Intensive';
    }
  }
}

enum GoalType {
  recovery,
  control,
  mastery;

  String get label {
    switch (this) {
      case GoalType.recovery:
        return 'Recovery';
      case GoalType.control:
        return 'Control';
      case GoalType.mastery:
        return 'Mastery';
    }
  }
}

enum RelationshipStatus {
  solo,
  partnered,
  complicated;

  String get label {
    switch (this) {
      case RelationshipStatus.solo:
        return 'Solo';
      case RelationshipStatus.partnered:
        return 'Partnered';
      case RelationshipStatus.complicated:
        return 'Complicated';
    }
  }
}

class UserProfile {
  const UserProfile({
    required this.severityTier,
    required this.goalType,
    required this.relationshipStatus,
  });

  final SeverityTier severityTier;
  final GoalType goalType;
  final RelationshipStatus relationshipStatus;

  Map<String, dynamic> toJson() {
    return {
      'severityTier': severityTier.name,
      'goalType': goalType.name,
      'relationshipStatus': relationshipStatus.name,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      severityTier: SeverityTier.values.byName(json['severityTier'] as String),
      goalType: GoalType.values.byName(json['goalType'] as String),
      relationshipStatus: RelationshipStatus.values.byName(
        json['relationshipStatus'] as String,
      ),
    );
  }
}
