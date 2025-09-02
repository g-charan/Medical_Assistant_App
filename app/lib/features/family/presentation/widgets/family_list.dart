import 'package:flutter/material.dart';

// Fixed FamilyList widget
class FamilyList extends StatelessWidget {
  const FamilyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Family Members",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            _buildList(Colors.grey, "Jayasree Gutti"),
            _buildList(Colors.grey, "Another Member"),
          ],
        ),
      ],
    );
  }

  Widget _buildList(Color color, String name) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.grey.shade400,
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.person),
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Jayasree Gutti"),
                Text(
                  "last updated 2 days ago",
                  style: TextStyle(fontSize: 11, height: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
