import 'package:flutter/material.dart';

class FamilyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.grey.shade200,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.supervised_user_circle),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Charan Gutti"),
                      Text(
                        "last updated on 28/09/2024",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "All done for today",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("View Details", style: TextStyle(fontSize: 12)),
                  IconButton(
                    icon: Icon(Icons.arrow_right_alt, size: 16),
                    onPressed: () {
                      // Navigate to family details screen
                      // context.push('/family/details');
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
