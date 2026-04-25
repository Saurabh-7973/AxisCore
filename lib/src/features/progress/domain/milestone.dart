class Milestone {
  const Milestone({
    required this.day,
    required this.label,
    required this.reward,
  });

  final int day;
  final String label;
  final String reward;

  static const milestones = [
    Milestone(day: 7, label: 'First Week', reward: 'Science explainer unlock'),
    Milestone(
      day: 21,
      label: 'Flatline Support',
      reward: 'Normalizing guidance sequence',
    ),
    Milestone(day: 60, label: 'Becoming', reward: 'Identity milestone'),
    Milestone(day: 90, label: 'The Reset', reward: 'Full reassessment'),
    Milestone(day: 180, label: 'Master', reward: 'Advanced preview'),
  ];

  static Milestone nextFor(int completedSessions) {
    return milestones.firstWhere(
      (milestone) => completedSessions < milestone.day,
      orElse: () => milestones.last,
    );
  }
}
