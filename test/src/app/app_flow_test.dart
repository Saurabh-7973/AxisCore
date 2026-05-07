import 'package:axiscore/main.dart';
import 'package:axiscore/src/core/storage/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpAxisCoreApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const AxisCoreApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> signInLocally(WidgetTester tester) async {
  expect(find.text('Sign in to AxisCore'), findsOneWidget);
  await tester.enterText(
    find.byKey(const Key('auth-email-field')),
    'user@test.com',
  );
  await tester.enterText(
    find.byKey(const Key('auth-password-field')),
    'control90',
  );
  await tester.tap(find.text('Sign in'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('unauthenticated users start on the auth screen', (tester) async {
    await pumpAxisCoreApp(tester);

    expect(find.text('Sign in to AxisCore'), findsOneWidget);
    expect(find.text('Build your 90-day foundation'), findsNothing);
  });

  testWidgets('onboarding result leads into the home dashboard', (
    tester,
  ) async {
    await pumpAxisCoreApp(tester);
    await signInLocally(tester);

    expect(find.text('AxisCore'), findsWidgets);
    expect(find.text('Build your 90-day foundation'), findsOneWidget);

    await tester.tap(find.text('Build my plan'));
    await tester.pumpAndSettle();

    expect(find.text('Your starting plan'), findsOneWidget);
    expect(find.text('90-day foundation'), findsOneWidget);

    await tester.tap(find.text('Enter dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Reset foundation'), findsOneWidget);
  });

  testWidgets('daily protocol completion updates progress', (tester) async {
    await pumpAxisCoreApp(tester);
    await signInLocally(tester);
    await tester.tap(find.text('Build my plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter dashboard'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.play_circle_fill_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Day 1 Reset Protocol'), findsOneWidget);

    await tester.tap(find.text('Complete session'));
    await tester.pumpAndSettle();

    expect(find.text('Session logged'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.show_chart_rounded));
    await tester.pumpAndSettle();

    expect(find.text('1 day'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('panic flow logs a breathing reset event', (tester) async {
    await pumpAxisCoreApp(tester);
    await signInLocally(tester);
    await tester.tap(find.text('Build my plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter dashboard'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.health_and_safety_rounded));
    await tester.pumpAndSettle();

    expect(find.text('4-7-8 reset'), findsOneWidget);

    await tester.tap(find.text('Start reset'));
    await tester.pumpAndSettle();

    expect(find.text('Reset started'), findsOneWidget);
    expect(find.text('Events logged: 1'), findsOneWidget);
  });

  testWidgets('sign out returns to the auth screen', (tester) async {
    await pumpAxisCoreApp(tester);
    await signInLocally(tester);
    await tester.tap(find.text('Build my plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter dashboard'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to AxisCore'), findsOneWidget);
  });
}
