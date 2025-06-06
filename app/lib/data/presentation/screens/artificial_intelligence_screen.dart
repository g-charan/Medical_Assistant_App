import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArtificialIntelligenceScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Upcoming Medicine"),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Text("something"),
                ),
                // Add Expanded here if the content above needs to take remaining vertical space
                // Otherwise, it will float at the top.
                // For a chat-like screen, you'd usually have a ListView.builder for messages here,
                // wrapped in an Expanded.
                Expanded(
                  child:
                      Container(), // Placeholder for chat messages or main content
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0, // <--- Add this
              right: 0, // <--- Add this
              child: TextField(
                // <--- No need for SizedBox here, Positioned constrains width
                controller: _textController,
                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Ask anything here",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  // If you want a rounded rectangle border for the TextField itself:
                  // borderRadius: BorderRadius.circular(25.0), // Requires OutlineInputBorder or similar
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
