import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/medicine/screens/add_medicine_screen.dart';
import '../features/medicine/screens/medicine_details_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/reminders/screens/reminders_screen.dart';
import '../features/reminders/screens/reorder_options_screen.dart';
import '../features/scan/screens/scan_screen.dart';
import 'app_routes.dart';
import 'scaffold_with_nav_bar.dart';

/// App router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // Initial routes
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // Main app shell with bottom navigation
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        // Scan tab
        GoRoute(
          path: AppRoutes.scan,
          builder: (context, state) => const ScanScreen(),
          routes: [
            // Nested routes for scan tab
            GoRoute(
              path: AppRoutes.addMedicineRelative,
              builder: (context, state) => const AddMedicineScreen(),
            ),
          ],
        ),

        // Medicines tab
        GoRoute(
          path: AppRoutes.medicines,
          builder: (context, state) => const MedicineListScreen(),
          routes: [
            // Nested routes for medicines tab
            GoRoute(
              path: AppRoutes.medicineDetailsRelative,
              builder: (context, state) {
                final medicineId = state.pathParameters['id'] ?? '';
                return MedicineDetailsScreen(medicineId: medicineId);
              },
            ),
            GoRoute(
              path: AppRoutes.addMedicineRelative,
              builder: (context, state) => const AddMedicineScreen(),
            ),
            GoRoute(
              path: AppRoutes.reorderOptionsRelative,
              builder: (context, state) {
                final medicineId = state.pathParameters['id'] ?? '';
                return ReorderOptionsScreen(medicineId: medicineId);
              },
            ),
          ],
        ),

        // Profile tab
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            // Nested routes for profile tab
            GoRoute(
              path: AppRoutes.settingsRelative,
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: AppRoutes.remindersRelative,
              builder: (context, state) => const RemindersScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Medicine list screen placeholder
class MedicineListScreen extends StatelessWidget {
  /// Constructor
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Medicine List Screen')));
  }
}
