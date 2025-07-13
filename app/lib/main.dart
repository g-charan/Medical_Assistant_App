import 'package:app/data/routing/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
