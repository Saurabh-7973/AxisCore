import 'package:axiscore/src/features/onboarding/domain/assessment_input.dart';
import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:axiscore/src/shared/domain/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _yearsOfUse = 4;
  bool _hasEscalationPattern = true;
  int _gad7Score = 8;
  int _averageIeltSeconds = 150;
  int _controlRating = 3;
  RelationshipStatus _relationshipStatus = RelationshipStatus.solo;
  GoalType _goalType = GoalType.recovery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AxisCore')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('Build my plan'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Build your 90-day foundation',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A structured training plan for reset, control, and confidence.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _NumberMenu(
              label: 'High-stimulation years',
              value: _yearsOfUse,
              values: const [1, 3, 4, 8, 10],
              suffix: 'years',
              onChanged: (value) => setState(() => _yearsOfUse = value),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Escalation pattern'),
              subtitle: const Text('Intensity or novelty increased over time'),
              value: _hasEscalationPattern,
              onChanged: (value) {
                setState(() => _hasEscalationPattern = value);
              },
            ),
            _NumberMenu(
              label: 'Anxiety screen score',
              value: _gad7Score,
              values: const [3, 6, 8, 12, 17],
              suffix: 'points',
              onChanged: (value) => setState(() => _gad7Score = value),
            ),
            _NumberMenu(
              label: 'Average control window',
              value: _averageIeltSeconds,
              values: const [45, 90, 150, 240, 360],
              suffix: 'seconds',
              onChanged: (value) => setState(() => _averageIeltSeconds = value),
            ),
            _NumberMenu(
              label: 'Control rating',
              value: _controlRating,
              values: const [1, 2, 3, 4, 5],
              suffix: '/5',
              onChanged: (value) => setState(() => _controlRating = value),
            ),
            _EnumMenu<RelationshipStatus>(
              label: 'Relationship context',
              value: _relationshipStatus,
              values: RelationshipStatus.values,
              labelFor: (status) => status.label,
              onChanged: (value) => setState(() => _relationshipStatus = value),
            ),
            _EnumMenu<GoalType>(
              label: 'Primary goal',
              value: _goalType,
              values: GoalType.values,
              labelFor: (goal) => goal.label,
              onChanged: (value) => setState(() => _goalType = value),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final input = AssessmentInput(
      yearsOfUse: _yearsOfUse,
      hasEscalationPattern: _hasEscalationPattern,
      gad7Score: _gad7Score,
      averageIeltSeconds: _averageIeltSeconds,
      controlRating: _controlRating,
      relationshipStatus: _relationshipStatus,
      goalType: _goalType,
    );
    await ref
        .read(appSessionControllerProvider.notifier)
        .submitAssessment(input);
    if (mounted) {
      context.go('/onboarding/result');
    }
  }
}

class _NumberMenu extends StatelessWidget {
  const _NumberMenu({
    required this.label,
    required this.value,
    required this.values,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final int value;
  final List<int> values;
  final String suffix;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final option in values)
          DropdownMenuItem(value: option, child: Text('$option $suffix')),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _EnumMenu<T> extends StatelessWidget {
  const _EnumMenu({
    required this.label,
    required this.value,
    required this.values,
    required this.labelFor,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) labelFor;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final option in values)
          DropdownMenuItem(value: option, child: Text(labelFor(option))),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
