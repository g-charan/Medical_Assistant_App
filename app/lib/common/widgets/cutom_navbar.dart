import "package:flutter/material.dart";

class CustomNavBar extends StatelessWidget {
  final String title;
  final BuildContext? context;

  const CustomNavBar({super.key, required this.title, this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 0),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),

          Text(title, style: TextStyle(fontSize: 18)),

          Icon(Icons.search),
        ],
      ),
    );
  }
}
