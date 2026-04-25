import 'package:axiscore/src/features/daily_protocol/domain/protocol_models.dart';
import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProtocolScreen extends ConsumerWidget {
  const ProtocolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocol = ref.watch(todayProtocolProvider);
    final theme = Theme.of(context);

    if (protocol == null) {
      return const Center(child: Text('Complete onboarding to begin.'));
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          protocol.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${protocol.totalMinutes} minutes · ${protocol.phase.label} phase',
        ),
        const SizedBox(height: 20),
        for (final block in protocol.blocks) ...[
          _ProtocolBlockTile(block: block),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => _complete(context, ref, protocol),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Complete session'),
        ),
      ],
    );
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
    DailyProtocolSession protocol,
  ) async {
    await ref
        .read(appSessionControllerProvider.notifier)
        .completeSession(protocol);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Session logged')));
    }
  }
}

class _ProtocolBlockTile extends StatelessWidget {
  const _ProtocolBlockTile({required this.block});

  final ProtocolBlock block;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${block.minutes}')),
        title: Text(block.title),
        subtitle: Text(block.description),
      ),
    );
  }
}
