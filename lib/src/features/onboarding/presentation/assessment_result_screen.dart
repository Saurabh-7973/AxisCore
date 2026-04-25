import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AssessmentResultScreen extends ConsumerWidget {
  const AssessmentResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(appSessionControllerProvider).assessmentResult;
    final theme = Theme.of(context);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('AxisCore')),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/onboarding'),
            child: const Text('Start assessment'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AxisCore')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Your starting plan',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.recommendedTrackLabel,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Focus: ${result.primaryFocus}'),
                  Text('Intensity: ${result.profile.severityTier.label}'),
                  Text('Anxiety band: ${result.anxietyBand.label}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/app/home'),
            icon: const Icon(Icons.dashboard_rounded),
            label: const Text('Enter dashboard'),
          ),
        ],
      ),
    );
  }
}
