import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AxisShell extends StatelessWidget {
  const AxisShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexFor(path),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/app/home');
            case 1:
              context.go('/app/protocol');
            case 2:
              context.go('/app/progress');
            case 3:
              context.go('/app/panic');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today_rounded), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.format_list_bulleted_rounded),
            label: 'Protocol',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_rounded),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_rounded),
            label: 'Reset',
          ),
        ],
      ),
    );
  }

  int _indexFor(String path) {
    if (path.contains('/protocol')) {
      return 1;
    }
    if (path.contains('/progress')) {
      return 2;
    }
    if (path.contains('/panic')) {
      return 3;
    }
    return 0;
  }
}
