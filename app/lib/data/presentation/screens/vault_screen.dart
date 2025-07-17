// app/data/presentation/widgets/vault/vault_screen.dart
import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/vault/vault_medicines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final GlobalKey<VaultMedicinesState> _vaultMedicinesKey =
      GlobalKey<VaultMedicinesState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              // Use a precise height for VaultMedicines to fit 10 items perfectly.
              SizedBox(
                height:
                    638.0, // Calculated to fit 10 items + title + pagination
                child: VaultMedicines(key: _vaultMedicinesKey),
              ),
              const SizedBox(height: 10),
              FamilyList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _vaultMedicinesKey.currentState?.showAddMedicineOptions();
        },
        label: const Text('Add Medicine'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
