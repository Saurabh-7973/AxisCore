import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';

class ProtocolEngine {
  const ProtocolEngine();

  DailyProtocolSession sessionFor({
    required UserProfile profile,
    required ProgressSnapshot progress,
    required DateTime now,
  }) {
    final dayNumber = progress.totalSessionsCompleted + 1;
    final phase = _phaseFor(dayNumber);

    return DailyProtocolSession(
      dayNumber: dayNumber,
      date: now,
      phase: phase,
      title: 'Day $dayNumber ${phase.label} Protocol',
      blocks: _blocksFor(phase, profile.goalType),
    );
  }

  ProtocolPhase _phaseFor(int dayNumber) {
    if (dayNumber <= 28) {
      return ProtocolPhase.reset;
    }
    if (dayNumber <= 56) {
      return ProtocolPhase.awareness;
    }
    if (dayNumber <= 84) {
      return ProtocolPhase.control;
    }
    return ProtocolPhase.integration;
  }

  List<ProtocolBlock> _blocksFor(ProtocolPhase phase, GoalType goalType) {
    switch (phase) {
      case ProtocolPhase.reset:
        return const [
          ProtocolBlock(
            kind: ProtocolBlockKind.education,
            title: 'Training principle',
            description: 'A short lesson to frame today as practice.',
            minutes: 5,
          ),
          ProtocolBlock(
            kind: ProtocolBlockKind.mobility,
            title: 'Reverse Kegel release',
            description: 'Pelvic-floor downtraining with calm body awareness.',
            minutes: 5,
          ),
          ProtocolBlock(
            kind: ProtocolBlockKind.breathwork,
            title: '4-7-8 breathwork',
            description: 'A nervous-system reset to finish the session.',
            minutes: 5,
          ),
        ];
      case ProtocolPhase.awareness:
        return const [
          ProtocolBlock(
            kind: ProtocolBlockKind.education,
            title: 'Body signal check',
            description: 'Notice tension without forcing a change.',
            minutes: 3,
          ),
          ProtocolBlock(
            kind: ProtocolBlockKind.awareness,
            title: 'Awareness holds',
            description: 'Gentle holds focused on control and release.',
            minutes: 7,
          ),
          ProtocolBlock(
            kind: ProtocolBlockKind.breathwork,
            title: 'Recovery breathing',
            description: 'Downshift before returning to the day.',
            minutes: 5,
          ),
        ];
      case ProtocolPhase.control:
        return const [
          ProtocolBlock(
            kind: ProtocolBlockKind.strengthening,
            title: 'Control holds',
            description: 'Structured strengthening with full release.',
            minutes: 8,
          ),
          ProtocolBlock(
            kind: ProtocolBlockKind.practice,
            title: 'Stop-start awareness',
            description: 'Practice noticing intensity before it spikes.',
            minutes: 7,
          ),
        ];
      case ProtocolPhase.integration:
        return [
          ProtocolBlock(
            kind: ProtocolBlockKind.education,
            title: goalType == GoalType.mastery
                ? 'Mastery integration'
                : 'Confidence integration',
            description: 'Connect the training habit to real-world confidence.',
            minutes: 5,
          ),
          const ProtocolBlock(
            kind: ProtocolBlockKind.practice,
            title: 'Integrated control sequence',
            description: 'A balanced practice block for control and calm.',
            minutes: 10,
          ),
        ];
    }
  }
}
