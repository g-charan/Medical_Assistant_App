import 'package:flutter/material.dart';

class FamilyList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Family Members"),
        Column(
          children: [
            _buildList(Colors.grey, "Something"),
            _buildList(Colors.grey, "Something"),
          ],
        ),
      ],
    );
  }
}

Widget _buildList(Color color, String text) {
  return Container(
    height: 50,

    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.symmetric(
        horizontal: BorderSide(color: Colors.transparent),
      ),
    ), // Margin around each page

    child: Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.grey.shade400,
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 8),
          Column(
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
