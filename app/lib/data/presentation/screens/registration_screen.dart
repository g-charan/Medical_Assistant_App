import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class InputBoxExample extends StatefulWidget{
  @override
  RegistrationScreen createState() => RegistrationScreen();
}

class RegistrationScreen extends State<InputBoxExample>{
  final TextEditingController _textController = TextEditingController();
  String _inputText = '';
  @override
  void dispose() {
    _textController.dispose(); // Remember to dispose of the controller
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Box Example'),actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.go('/');
            // Handle save action
          },
        ),
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter Text',
                hintText: 'Type something here',
                prefixIcon: Icon(Icons.text_fields),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear();
                    setState(() {
                      _inputText = '';
                    });
                  },
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
              onSubmitted: (value) {
                print('Submitted: $value');
                // You can perform actions on submit here
              },
            ),
            SizedBox(height: 20),
            Text('You entered: $_inputText'),
          ],
        ),
      ),
    );
  }
}

