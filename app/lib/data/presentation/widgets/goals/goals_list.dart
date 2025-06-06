import 'package:flutter/material.dart';

class GoalsList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upcoming Medicine"),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[_buildList(Colors.grey, "Something")],
          ),
        ),
      ],
    );
  }
}

Widget _buildList(Color color, String text) {
  return Container(
    height: 50,
    margin: const EdgeInsets.only(top: 5, bottom: 5),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.symmetric(
        horizontal: BorderSide(color: Colors.grey.shade400),
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
              child: Icon(Icons.medication),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Vitamin d3 1100"),
              Text(
                "Should be taken after food",
                style: TextStyle(fontSize: 11, height: 1),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
