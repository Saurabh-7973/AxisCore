import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:axiscore/src/features/auth/application/auth_controller.dart';
import 'package:axiscore/src/shared/ui/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSession = ref.watch(appSessionControllerProvider);
    final result = appSession.assessmentResult;
    final protocol = ref.watch(todayProtocolProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Today',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/auth');
              }
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          result?.primaryFocus ?? 'Reset foundation',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Current streak',
                value: '${appSession.progress.currentStreak} days',
                icon: Icons.local_fire_department_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                label: 'Consistency',
                value: '${appSession.progress.consistencyPercent}%',
                icon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  protocol?.title ?? 'Daily Protocol',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${protocol?.totalMinutes ?? 15} minutes · '
                  '${protocol?.phase.label ?? 'Reset'} phase',
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.go('/app/protocol'),
                  icon: const Icon(Icons.play_circle_fill_rounded),
                  label: const Text('Start daily protocol'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.flag_rounded),
            title: Text(appSession.progress.nextMilestone.label),
            subtitle: Text(appSession.progress.nextMilestone.reward),
            trailing: Text('Day ${appSession.progress.nextMilestone.day}'),
          ),
        ),
      ],
    );
  }
}
