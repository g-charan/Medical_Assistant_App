import 'package:app/data/presentation/widgets/family/family_card.dart';
import 'package:flutter/material.dart';

class FamilyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          height: screenHeight,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
              FamilyCard(),
            ],
          ),
        ),
      ),
    );
  }
}
