// lib/data/routing/router_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/data/presentation/providers/auth_provider.dart'; // Your auth provider
import 'package:app/data/routing/app_routes.dart'; // Your route configurations
import 'package:app/common/widgets/app_shell.dart'; // Your AppShell

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
          return AppShell(state: state, child: child);
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
