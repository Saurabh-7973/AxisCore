import 'package:axiscore/src/features/auth/application/auth_controller.dart';
import 'package:axiscore/src/features/auth/presentation/auth_screen.dart';
import 'package:axiscore/src/features/app_shell/presentation/axis_shell.dart';
import 'package:axiscore/src/features/daily_protocol/presentation/protocol_screen.dart';
import 'package:axiscore/src/features/home/presentation/home_screen.dart';
import 'package:axiscore/src/features/onboarding/presentation/assessment_result_screen.dart';
import 'package:axiscore/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:axiscore/src/features/panic/presentation/panic_screen.dart';
import 'package:axiscore/src/features/progress/presentation/progress_screen.dart';
import 'package:axiscore/src/features/session/application/app_session_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.read(authControllerProvider);
  final appSession = ref.read(appSessionControllerProvider);
  final hasUser = authState.isSignedIn;
  final hasProfile = appSession.hasProfile;

  return GoRouter(
    initialLocation: !hasUser
        ? '/auth'
        : hasProfile
        ? '/app/home'
        : '/onboarding',
    redirect: (context, state) {
      final path = state.uri.path;
      final hasCurrentUser = ref.read(authControllerProvider).isSignedIn;
      final hasCurrentProfile = ref
          .read(appSessionControllerProvider)
          .hasProfile;

      if (!hasCurrentUser && path != '/auth') {
        return '/auth';
      }
      if (hasCurrentUser && path == '/auth') {
        return hasCurrentProfile ? '/app/home' : '/onboarding';
      }
      if (hasCurrentUser && !hasCurrentProfile && path.startsWith('/app')) {
        return '/onboarding';
      }
      if (hasCurrentUser && hasCurrentProfile && path == '/onboarding') {
        return '/app/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding/result',
        builder: (context, state) => const AssessmentResultScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AxisShell(child: child),
        routes: [
          GoRoute(
            path: '/app/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/app/protocol',
            builder: (context, state) => const ProtocolScreen(),
          ),
          GoRoute(
            path: '/app/progress',
            builder: (context, state) => const ProgressScreen(),
          ),
          GoRoute(
            path: '/app/panic',
            builder: (context, state) => const PanicScreen(),
          ),
        ],
      ),
    ],
  );
});
