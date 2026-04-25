import 'package:axiscore/src/core/storage/local_axiscore_store.dart';
import 'package:axiscore/src/features/panic/domain/panic_protocol.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PanicRepository {
  Future<PanicProtocol> logPanicEvent();
}

class LocalPanicRepository implements PanicRepository {
  LocalPanicRepository(this._store);

  final LocalAxisCoreStore _store;

  @override
  Future<PanicProtocol> logPanicEvent() async {
    final eventCount = await _store.incrementPanicCount();
    return PanicProtocol(
      title: '4-7-8 reset',
      eventCount: eventCount,
      steps: const [
        'Inhale quietly for 4 seconds.',
        'Hold the breath for 7 seconds.',
        'Exhale slowly for 8 seconds.',
        'Repeat four rounds, then choose the next calm action.',
      ],
    );
  }
}

final panicRepositoryProvider = Provider<PanicRepository>((ref) {
  return LocalPanicRepository(ref.watch(localAxisCoreStoreProvider));
});
