import 'package:flutter/material.dart';

// CONVERTED to a StatefulWidget to manage the TextEditingController's lifecycle.
class ArtificialIntelligenceScreen extends StatefulWidget {
  const ArtificialIntelligenceScreen({super.key});

  @override
  State<ArtificialIntelligenceScreen> createState() =>
      _ArtificialIntelligenceScreenState();
}

class _ArtificialIntelligenceScreenState
    extends State<ArtificialIntelligenceScreen> {
  // The controller is now a property of the State class.
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Best practice: Initialize controllers in initState.
  }

  @override
  void dispose() {
    // Best practice: Dispose of controllers to free up resources.
    _textController.dispose();
    super.dispose();
  }

  void _handleSendPressed() {
    final String text = _textController.text.trim();
    if (text.isNotEmpty) {
      // In a real chat app, you would add the message to a list here
      // and call setState(() {}) to rebuild the UI.
      print("User input: $text");
      _textController.clear(); // Clear the input field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    // The build method is now part of the State class.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Upcoming Medicine"),
                const SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Text("something"),
                ),
                // This container is a placeholder for your chat message list.
                Expanded(child: Container()),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Ask anything here",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _handleSendPressed,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
