import 'package:app/core/auth/app_startup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/routing/router_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://vqizlywojeyrqafztcst.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxaXpseXdvamV5cnFhZnp0Y3N0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTgwMTksImV4cCI6MjA2ODc3NDAxOX0.AViEF_5qVqC5jB824_tX4FGyweDuLYljhgam93TXuwM",
  );
  runApp(const ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the startup state and the router config
    final appStartupState = ref.watch(appStartupProvider);
    final router = ref.watch(routerProvider);

    // Return a SINGLE MaterialApp.router at the top level
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Flutter Routing Demo',
      theme: ThemeData(
        fontFamily: 'Manrope',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      // Use the builder to wrap your app and handle startup states
      builder: (context, child) {
        // The `child` here is the widget provided by the GoRouter.
        // We wrap it with the RefreshConfiguration.
        return RefreshConfiguration(
          headerBuilder: () => const ClassicHeader(),
          footerBuilder: () => const ClassicFooter(),
          headerTriggerDistance: 80.0,
          maxOverScrollExtent: 100,
          hideFooterWhenNotFull: true,
          // Now, decide what to show based on the startup state
          child: appStartupState.when(
            // If data is loaded, show the router's screen (`child`)
            data: (_) => child!,
            // Otherwise, show a full-screen error/loading UI.
            // These are now simple Scaffolds, not MaterialApps.
            error: (e, s) => Scaffold(
              body: Center(child: Text('Error initializing app: $e')),
            ),
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}
