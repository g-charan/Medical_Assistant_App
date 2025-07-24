import 'package:app/data/presentation/providers/app_startup.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/data/routing/router_provider.dart';

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
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      data: (_) {
        final router = ref.watch(routerProvider);
        return RefreshConfiguration(
          headerBuilder: () =>
              const ClassicHeader(), // Explicitly provide a default header
          footerBuilder: () =>
              const ClassicFooter(), // Also provide a default footer if you might use pull-up
          headerTriggerDistance: 80.0, // Default is fine, but ensures it's set
          maxOverScrollExtent: 100, // Example, ensures it's set
          hideFooterWhenNotFull: true,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            title: 'Flutter Routing Demo',
            theme: ThemeData(
              fontFamily: 'Manrope',
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      },
      error: (e, s) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app: $e'))),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
