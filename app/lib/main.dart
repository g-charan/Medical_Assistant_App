import 'package:app/data/presentation/screens/home_screen.dart';
import 'package:app/data/routing/app_routes.dart';
import 'package:app/data/routing/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:app/data/presentation/screens/registration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Routing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}


