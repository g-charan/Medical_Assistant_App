// lib/data/routing/router_config.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:app/core/routing/app_routes.dart'; // Your route configurations
// import 'package:app/common/widgets/app_shell.dart'; // Your AppShell

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    // 1. ShellRoute for routes that need the drawer
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(child: child);
      },
      routes: appRouteConfigs
          .where(
            (config) => config.usesShell,
          ) // Filter for routes that use the shell
          .map((config) {
            return GoRoute(path: config.path, builder: config.builder);
          })
          .toList(),
    ),

    // 2. Direct GoRoutes for routes that DO NOT need the drawer
    ...appRouteConfigs
        .where(
          (config) => !config.usesShell,
        ) // Filter for routes that DO NOT use the shell
        .map((config) {
          return GoRoute(path: config.path, builder: config.builder);
        }),
  ],
);

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int index) => _onItemTapped(index, context),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          // These items now correspond to your routes
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined),
            activeIcon: Icon(Icons.medication),
            label: 'Vault',
          ), // Meds/Vault
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Metrics',
          ), // Reports/Metrics
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ), // Alerts
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Family',
          ), // Community/Family
        ],
      ),
    );
  }

  // This helper now checks your specific route paths.
  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    // The order is important, checking more specific routes first.
    if (location.startsWith('/vault')) return 1;
    if (location.startsWith('/metrics')) return 2;
    if (location.startsWith('/alerts')) return 3;
    if (location.startsWith('/family')) return 4;
    if (location.startsWith('/')) return 0;
    return 0; // Default
  }

  // This helper now navigates to your specific routes.
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/vault');
        break;
      case 2:
        context.go('/metrics');
        break;
      case 3:
        context.go('/alerts');
        break;
      case 4:
        context.go('/family');
        break;
    }
  }
}
