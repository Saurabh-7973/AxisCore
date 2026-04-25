import 'package:axiscore/src/core/storage/local_axiscore_store.dart';
import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/progress/domain/progress_engine.dart';
import 'package:axiscore/src/features/progress/domain/progress_snapshot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ProgressRepository {
  Future<ProgressSnapshot> getProgress();

  Future<ProgressSnapshot> completeSession(DailyProtocolSession session);
}

class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository({
    required LocalAxisCoreStore store,
    ProgressEngine engine = const ProgressEngine(),
  }) : _store = store,
       _engine = engine;

  final LocalAxisCoreStore _store;
  final ProgressEngine _engine;

  @override
  Future<ProgressSnapshot> getProgress() async {
    return _store.readProgress();
  }

  @override
  Future<ProgressSnapshot> completeSession(DailyProtocolSession session) async {
    final progress = _engine.completeSession(
      _store.readProgress(),
      session,
      completedAt: DateTime.now(),
    );
    await _store.saveProgress(progress);
    return progress;
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return LocalProgressRepository(store: ref.watch(localAxisCoreStoreProvider));
});
