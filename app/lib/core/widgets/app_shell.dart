// lib/common/widgets/app_shell.dart
import 'package:app/core/widgets/cutom_navbar.dart';
import 'package:app/core/widgets/custom_drawer.dart'; // Your custom drawer
import 'package:flutter/material.dart';
import 'package:app/core/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final GoRouterState
  state; // This child will be the content of the current route

  const AppShell({Key? key, required this.child, required this.state})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentTitle =
        appRouteTitles[state.fullPath ?? state.uri.path] ?? 'App';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        // The CustomNavBar will likely handle opening the drawer
        // If CustomNavBar implicitly creates a leading icon for a Drawer,
        // you might still want automaticallyImplyLeading: false here if you want to control it from CustomNavBar.
        automaticallyImplyLeading:
            false, // Set to false if CustomNavBar provides the menu icon
        title: Builder(
          builder: (BuildContext appBarContext) {
            // Pass a context that is a descendant of Scaffold for CustomNavBar to open the drawer
            return CustomNavBar(title: currentTitle, context: appBarContext);
          },
        ),
      ),
      drawer: const CustomDrawer(), // Your single instance of the drawer
      body: child, // The content of the current route
    );
  }
}
