import 'package:app/common/widgets/custom_list.dart';
import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/vault/vault_medicines.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VaultMedicines(),
              const SizedBox(height: 40),
              FamilyList(),
            ],
          ),
        ),
      ),
    );
  }
}
