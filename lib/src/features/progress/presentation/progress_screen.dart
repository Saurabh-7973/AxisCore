import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:axiscore/src/shared/ui/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(appSessionControllerProvider).progress;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Progress',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Current streak',
                value: '${progress.currentStreak} day',
                icon: Icons.local_fire_department_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Consistency',
                value: '${progress.consistencyPercent}%',
                icon: Icons.verified_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.military_tech_rounded),
            title: Text(progress.nextMilestone.label),
            subtitle: Text(progress.nextMilestone.reward),
            trailing: Text('Day ${progress.nextMilestone.day}'),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Sessions completed: ${progress.totalSessionsCompleted}',
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
