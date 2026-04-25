import 'package:axiscore/src/features/daily_protocol/domain/protocol_engine.dart';
import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ProtocolRepository {
  Future<DailyProtocolSession> getTodayProtocol(UserProfile profile);
}

class LocalProtocolRepository implements ProtocolRepository {
  LocalProtocolRepository({
    required ProgressReader readProgress,
    ProtocolEngine engine = const ProtocolEngine(),
  }) : _readProgress = readProgress,
       _engine = engine;

  final ProgressReader _readProgress;
  final ProtocolEngine _engine;

  @override
  Future<DailyProtocolSession> getTodayProtocol(UserProfile profile) async {
    return _engine.sessionFor(
      profile: profile,
      progress: _readProgress(),
      now: DateTime.now(),
    );
  }
}

typedef ProgressReader = ProgressSnapshot Function();

final protocolRepositoryProvider = Provider<ProtocolRepository>((ref) {
  return LocalProtocolRepository(
    readProgress: () => ref.read(appSessionControllerProvider).progress,
  );
});
