import 'package:flutter/material.dart';

class CalendarSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal, // <--- Key property
      children: <Widget>[
        _buildPage('Mon'),
        _buildPage('Tue'),
        _buildPage('Wed'),
        _buildPage('Mon'),
        _buildPage('Tue'),
        _buildPage('Wed'),
      ],
    );
  }

  Widget _buildPage(String text) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(
        left: 4,
        right: 4,
      ), // Margin around each page
      color: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("04", style: TextStyle(fontSize: 16, height: 1)),
            Text(text, style: TextStyle(fontSize: 12, height: 1)),
          ],
        ),
      ),
    );
  }
}
