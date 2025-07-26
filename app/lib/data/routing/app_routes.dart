import 'package:app/data/presentation/screens/alerts_screen.dart';
import 'package:app/data/presentation/screens/artificial_intelligence_screen.dart';
import 'package:app/data/presentation/screens/family_details_screen.dart';
import 'package:app/data/presentation/screens/family_screen.dart';
import 'package:app/data/presentation/screens/login_screen.dart';
import 'package:app/data/presentation/screens/medicine_details_screen.dart';
import 'package:app/data/presentation/screens/metrics_screen.dart';
import 'package:app/data/presentation/screens/settings_screen.dart';
import 'package:app/data/presentation/screens/updateprofile.screen.dart';
import 'package:app/data/presentation/screens/vault_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/registration_screen.dart';

class AppRouteConfig {
  final String path;
  // The builder should always be defined to return the generic 'Widget' type.
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
  '/settings': 'Settings',
  '/profile': 'Profile',
  '/alerts': 'Alerts',
};

final List<AppRouteConfig> appRouteConfigs = [
  AppRouteConfig(
    path: '/register',
    usesShell: false,
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const RegistrationWidget();
    },
  ),
  AppRouteConfig(
    path: '/login',
    usesShell: false,
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const LoginWidget();
    },
  ),
  AppRouteConfig(
    path: '/',
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const HomeScreen();
    },
  ),
  AppRouteConfig(
    path: '/vault',
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const VaultScreen();
    },
  ),
  AppRouteConfig(
    path: '/family',
    // FIX: Explicitly define the return type as Widget. This allows it to accept
    // ConsumerWidget, ConsumerStatefulWidget, or any other widget type.
    builder: (BuildContext context, GoRouterState state) {
      return const FamilyScreen();
    },
  ),
  AppRouteConfig(
    path: '/ai',
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const ArtificialIntelligenceScreen();
    },
  ),
  AppRouteConfig(
    path: '/metrics',
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return MetricsScreen();
    },
  ),
  AppRouteConfig(
    path: '/settings',
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const SettingsScreen();
    },
  ),
  AppRouteConfig(
    path: '/vault/:medicineId',
    usesShell: false,
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      final String? medicineId = state.pathParameters['medicineId'];
      return MedicineDetailsScreen(medicineId: "$medicineId");
    },
  ),
  AppRouteConfig(
    path: '/family/:familyId',
    usesShell: false,
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      final String? familyId = state.pathParameters['familyId'];
      return FamilyDetailsScreen(familyMemberId: "$familyId");
    },
  ),
  AppRouteConfig(
    path: "/alerts",
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const AlertsScreen();
    },
  ),
  AppRouteConfig(
    path: "/settings/edit-profile",
    usesShell: false,
    // FIX: Explicitly define the return type as Widget.
    builder: (BuildContext context, GoRouterState state) {
      return const UpdateProfileScreen();
    },
  ),
];
