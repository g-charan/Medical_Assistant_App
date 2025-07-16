import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// No need for flutter_staggered_animations import here,
// as the animations will be applied by the parent (FamilyList)

class FamilyCard extends StatelessWidget {
  const FamilyCard({super.key}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, bottom: 10), // Made const
      decoration: BoxDecoration(
        // Added BoxDecoration for rounded corners and shadow
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10), // Made const
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10), // Made const
              child: Row(
                children: [
                  const Icon(Icons.supervised_user_circle), // Made const
                  const SizedBox(width: 10), // Made const
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Charan Gutti"), // Made const
                      const Text(
                        // Made const
                        "last updated on 28/09/2024",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        // Made const
                        "All done for today",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1), // Made const
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "View Details",
                    style: TextStyle(fontSize: 12),
                  ), // Made const
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_right_alt,
                      size: 16,
                    ), // Made const
                    onPressed: () {
                      context.go("/family/2");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
