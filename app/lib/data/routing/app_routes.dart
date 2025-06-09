import 'package:app/data/presentation/screens/alerts_screen.dart';
import 'package:app/data/presentation/screens/artificial_intelligence_screen.dart';
import 'package:app/data/presentation/screens/family_details_screen.dart';
import 'package:app/data/presentation/screens/family_screen.dart';
import 'package:app/data/presentation/screens/login_screen.dart';
import 'package:app/data/presentation/screens/medicine_details_screen.dart';
import 'package:app/data/presentation/screens/metrics_screen.dart';
import 'package:app/data/presentation/screens/settings_screen.dart';
import 'package:app/data/presentation/screens/vault_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/registration_screen.dart';

class AppRouteConfig {
  final String path;
  final Widget Function(BuildContext, GoRouterState) builder;
  final bool usesShell;

  AppRouteConfig({
    required this.path,
    required this.builder,
    this.usesShell = true,
  });
}

const Map<String, String> appRouteTitles = {
  '/': 'Home',
  '/vault': 'Vault',
  '/ai': 'AI',
  '/metrics': 'Stats',
  '/family': 'Family',
  '/settings': 'Settings', // Example
  '/profile': 'Profile', // Example
  '/alerts': 'Alerts',
  // Add titles for all your main routes here
};

final List<AppRouteConfig> appRouteConfigs = [
  AppRouteConfig(
    path: '/second',
    usesShell: false,
    builder: (BuildContext context, GoRouterState state) {
      return InputBoxExample();
    },
  ),
  AppRouteConfig(
    path: '/login',
    usesShell: false,
    builder: (BuildContext context, GoRouterState state) {
      return LoginWidget();
    },
  ),
  AppRouteConfig(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return HomeScreen();
    },
  ),
  AppRouteConfig(
    path: '/vault', // Example of adding another route
    builder: (BuildContext context, GoRouterState state) {
      return VaultScreen();
    },
  ),
  AppRouteConfig(
    path: '/family', // Example of adding another route
    builder: (BuildContext context, GoRouterState state) {
      return FamilyScreen();
    },
  ),
  AppRouteConfig(
    path: '/ai', // Example of adding another route
    builder: (BuildContext context, GoRouterState state) {
      return ArtificialIntelligenceScreen();
    },
  ),
  AppRouteConfig(
    path: '/metrics', // Example of adding another route
    builder: (BuildContext context, GoRouterState state) {
      return MetricsScreen();
    },
  ),
  AppRouteConfig(
    path: '/settings', // Example of adding another route
    builder: (BuildContext context, GoRouterState state) {
      return SettingsScreen();
    },
  ),
  AppRouteConfig(
    path: '/vault/:medicineId',
    usesShell: false,
    builder: (BuildContext context, GoRouterState state) {
      // Extract the medicineId from the state parameters
      final String? medicineId = state.pathParameters['medicineId'];
      // You can use the medicineId to fetch details or pass it to the screen
      return MedicineDetailsScreen(medicineId: "$medicineId");
    },
  ),
  AppRouteConfig(
    path: '/family/:familyId',
    usesShell: false,
    builder: (BuildContext context, GoRouterState state) {
      // Extract the familyId from the state parameters
      final String? familyId = state.pathParameters['familyId'];
      // You can use the familyId to fetch details or pass it to the screen
      return FamilyDetailsScreen(familyMemberId: "$familyId");
    },
  ),
  AppRouteConfig(
    path: "/alerts",
    builder: (BuildContext context, GoRouterState state) {
      return AlertsScreen();
    },
  ),
];
