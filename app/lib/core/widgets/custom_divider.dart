import "package:flutter/material.dart";

class DividerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const Divider(color: Colors.grey, thickness: 1.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          color: Theme.of(context).scaffoldBackgroundColor, // Match background
          child: Text('OR', style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }
}
