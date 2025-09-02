// lib/data/routing/router_provider.dart

import 'package:app/core/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Your auth provider
import 'package:app/core/routing/app_routes.dart'; // Your route configurations
// import 'package:app/common/widgets/app_shell.dart'; // Your AppShell

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangeProvider);

  return GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      if (authState.isLoading || authState.hasError) {
        return null;
      }

      final isLoggedIn = authState.value?.session != null;

      // Define which routes are public (accessible without being logged in)
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';

      // If the user is not logged in and is trying to go to a page
      // that isn't the login or register page, redirect to login.
      if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }

      // If the user is logged in and tries to go to the login or register page,
      // redirect them to the home screen.
      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
        return '/';
      }

      // No redirect needed in all other cases.
      return null;
    },
    routes: <RouteBase>[
      // Your existing ShellRoute and GoRoutes remain the same
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppShell(child: child);
        },
        routes: appRouteConfigs
            .where((config) => config.usesShell)
            .map(
              (config) => GoRoute(path: config.path, builder: config.builder),
            )
            .toList(),
      ),
      ...appRouteConfigs
          .where((config) => !config.usesShell)
          .map((config) => GoRoute(path: config.path, builder: config.builder))
          .toList(),
    ],
  );
});

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FIX: Wrap the body with SafeArea to apply it to all screens in the shell.
      body: SafeArea(child: child),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/ai'),
        backgroundColor: Color(0xFF3A5B43),
        child: const FaIcon(
          FontAwesomeIcons.wandMagicSparkles,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int index) => _onItemTapped(index, context),
          selectedItemColor: Color(0xFF344E41),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Remove shadow
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_outlined),
              activeIcon: Icon(Icons.medication),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Metrics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Family',
            ),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/vault')) return 1;
    if (location.startsWith('/metrics')) return 2;
    if (location.startsWith('/alerts')) return 3;
    if (location.startsWith('/family')) return 4;
    if (location.startsWith('/')) return 0;
    return 0;
  }

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
