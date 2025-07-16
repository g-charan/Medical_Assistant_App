import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/vault/vault_medicines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import this

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    // Define your list of widgets that will be animated
    final List<Widget> vaultScreenContent = [
      // Your existing widgets inside the Column
      VaultMedicines(),
      const SizedBox(height: 10),
      FamilyList(),
      // Add any other widgets you want to be part of the staggered animation here
      const SizedBox(
        height: 20,
      ), // Added some space at the bottom for better visual
      const Text(
        "Welcome to your Vault!",
        style: TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
    ];

    return Scaffold(
      body: AnimationLimiter(
        // Wrap your scrollable content with AnimationLimiter
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(
            20,
          ), // Apply the padding directly to the ListView
          children: AnimationConfiguration.toStaggeredList(
            // Use toStaggeredList for Column-like children
            duration: const Duration(
              milliseconds: 375,
            ), // Duration for each item's animation
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0, // Items slide in from 50 pixels below
              child: FadeInAnimation(
                child: widget, // The actual widget being animated
              ),
            ),
            children: vaultScreenContent, // Pass your list of widgets here
          ),
        ),
      ),
    );
  }
}
