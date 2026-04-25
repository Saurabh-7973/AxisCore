import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PanicScreen extends ConsumerWidget {
  const PanicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventCount = ref.watch(appSessionControllerProvider).panicEventCount;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '4-7-8 reset',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        const Text('A short breathing protocol for urge and stress moments.'),
        const SizedBox(height: 20),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Inhale for 4 seconds'),
                SizedBox(height: 8),
                Text('2. Hold for 7 seconds'),
                SizedBox(height: 8),
                Text('3. Exhale for 8 seconds'),
                SizedBox(height: 8),
                Text('4. Repeat four rounds'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Events logged: $eventCount'),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _startReset(context, ref),
          icon: const Icon(Icons.spa_rounded),
          label: const Text('Start reset'),
        ),
      ],
    );
  }

  Future<void> _startReset(BuildContext context, WidgetRef ref) async {
    await ref.read(appSessionControllerProvider.notifier).logPanicEvent();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reset started')));
    }
  }
}
