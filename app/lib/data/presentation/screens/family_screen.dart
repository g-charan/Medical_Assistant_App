import 'package:app/data/models/family_member.dart';
import 'package:app/data/presentation/widgets/family/family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import this

class FamilyScreen extends StatelessWidget {
  final List<FamilyMember> familyMembers = const [
    FamilyMember(
      id: 'charan',
      name: "Charan Gutti",
      lastUpdate: "28/09/2024",
      status: "All done for today",
      statusColor: Colors.green,
      iconBackgroundColor: Colors.deepPurple,
    ),
    FamilyMember(
      id: 'mom',
      name: "Mom",
      lastUpdate: "28/09/2024",
      status: "Needs attention",
      statusColor: Colors.red,
      iconData: Icons.woman_rounded,
      iconBackgroundColor: Colors.pink,
    ),
    FamilyMember(
      id: 'dad',
      name: "Dad",
      lastUpdate: "27/09/2024",
      status: "All good",
      statusColor: Colors.green,
      iconData: Icons.man_rounded,
      iconBackgroundColor: Colors.blue,
    ),
    FamilyMember(
      id: 'child',
      name: "Child",
      lastUpdate: "28/09/2024",
      status: "Medication due soon",
      statusColor: Colors.orange,
      iconData: Icons.child_care_rounded,
      iconBackgroundColor: Colors.teal,
    ),
  ];

  const FamilyScreen({super.key}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    // You don't necessarily need screenHeight for a simple ListView,
    // as ListView handles its own height based on content and available space.
    // However, if you explicitly want the ListView to fill the screen height,
    // keeping SizedBox height is fine, but ensure it doesn't cause overflow issues.
    // For staggered animations in a ListView, it's often better to let ListView manage its own scroll extent.

    // Let's create a list of dummy data to simulate multiple family cards

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20), // Made const
        child: AnimationLimiter(
          // Wrap the scrollable content with AnimationLimiter
          child: ListView.builder(
            // Using ListView.builder is generally better for dynamic lists
            scrollDirection:
                Axis.vertical, // Still vertical scrolling for the list itself
            itemCount: familyMembers.length,
            itemBuilder: (BuildContext context, int index) {
              final FamilyMember member = familyMembers[index];
              return AnimationConfiguration.staggeredList(
                position: index, // Crucial for the staggered effect
                duration: const Duration(
                  milliseconds: 375,
                ), // Duration for each item's animation
                child: SlideAnimation(
                  horizontalOffset:
                      200.0, // Items slide in from 200 pixels from the right (or left if negative)
                  child: FadeInAnimation(
                    child: FamilyCard(
                      familyMember: member,
                    ), // Your FamilyCard widget
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
