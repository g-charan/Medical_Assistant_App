import 'package:flutter/material.dart';

Widget buildList(Color color, String text) {
  return Container(
    height: 50,
    margin: const EdgeInsets.only(
      top: 10,
      bottom: 10,
    ), // Margin around each page
    color: color,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 11.0, color: Colors.white),
      ),
    ),
  );
}
