// lib/data/routing/router_config.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:app/data/routing/app_routes.dart'; // Your route configurations
import 'package:app/common/widgets/app_shell.dart'; // Your AppShell

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    // 1. ShellRoute for routes that need the drawer
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AppShell(state: state, child: child);
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
        })
        .toList(),
  ],
);
