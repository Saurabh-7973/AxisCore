enum ProtocolPhase {
  reset,
  awareness,
  control,
  integration;

  String get label {
    switch (this) {
      case ProtocolPhase.reset:
        return 'Reset';
      case ProtocolPhase.awareness:
        return 'Awareness';
      case ProtocolPhase.control:
        return 'Control';
      case ProtocolPhase.integration:
        return 'Integration';
    }
  }
}

enum ProtocolBlockKind {
  education,
  mobility,
  breathwork,
  awareness,
  strengthening,
  practice,
}

class ProtocolBlock {
  const ProtocolBlock({
    required this.kind,
    required this.title,
    required this.description,
    required this.minutes,
  });

  final ProtocolBlockKind kind;
  final String title;
  final String description;
  final int minutes;
}

class DailyProtocolSession {
  const DailyProtocolSession({
    required this.dayNumber,
    required this.date,
    required this.phase,
    required this.title,
    required this.blocks,
  });

  final int dayNumber;
  final DateTime date;
  final ProtocolPhase phase;
  final String title;
  final List<ProtocolBlock> blocks;

  int get totalMinutes {
    return blocks.fold(0, (total, block) => total + block.minutes);
  }

  factory DailyProtocolSession.reset({
    required int dayNumber,
    required DateTime date,
  }) {
    return DailyProtocolSession(
      dayNumber: dayNumber,
      date: date,
      phase: ProtocolPhase.reset,
      title: 'Day $dayNumber Reset Protocol',
      blocks: const [
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
      ],
    );
  }
}
