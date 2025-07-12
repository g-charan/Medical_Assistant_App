import 'package:app/data/routing/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Flutter Routing Demo',
      theme: ThemeData(
        fontFamily: 'Manrope',
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
