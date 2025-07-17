import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/data/models/family_member.dart'; // Import your new data model

class FamilyCard extends StatelessWidget {
  // FamilyCard now takes a FamilyMember object
  final FamilyMember familyMember;

  const FamilyCard({super.key, required this.familyMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
      ), // Consistent vertical margin
      decoration: BoxDecoration(
        color: Colors.white, // Clean white background
        borderRadius: BorderRadius.circular(16), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Softer shadow
            spreadRadius: 2,
            blurRadius: 10, // More blur for a softer look
            offset: const Offset(0, 5), // Deeper shadow
          ),
        ],
      ),
      child: InkWell(
        // Use InkWell for ripple effect on the whole card
        borderRadius: BorderRadius.circular(
          16,
        ), // Match container's border radius
        onTap: () {
          context.go(
            "/family/${familyMember.id}",
          ); // Navigate using the member's ID
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ), // Adjusted padding
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50, // Fixed size for the circular icon background
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Circular background
                      color: familyMember
                          .iconBackgroundColor, // Dynamic background color
                    ),
                    child: Icon(
                      familyMember.iconData, // Dynamic icon
                      color: familyMember.iconColor, // Dynamic icon color
                      size: 30, // Appropriate icon size
                    ),
                  ),
                  const SizedBox(width: 15), // Increased spacing
                  Expanded(
                    // Use Expanded to ensure text wraps
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          familyMember.name, // Dynamic name
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4), // Small space
                        Text(
                          "Last updated: ${familyMember.lastUpdate}", // Dynamic last update
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2), // Very small space
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: familyMember
                                    .statusColor, // Dynamic status color dot
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              familyMember.status, // Dynamic status
                              style: TextStyle(
                                fontSize: 13,
                                color: familyMember
                                    .statusColor, // Status text color matches dot
                                fontWeight:
                                    FontWeight.w600, // Slightly bolder status
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 24,
                thickness: 0.8,
                color: Colors.grey,
              ), // Thicker, more visible divider
              SizedBox(
                height: 30, // Reduced height for the action row
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align to the right
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).primaryColor, // Use theme primary color
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4), // Small space
                    Icon(
                      Icons.arrow_forward_ios_rounded, // Modern arrow icon
                      size: 16,
                      color: Theme.of(
                        context,
                      ).primaryColor, // Use theme primary color
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
