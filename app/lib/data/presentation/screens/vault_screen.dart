import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VaultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('This is the Home Screen'),
              ElevatedButton(
                onPressed: () {
                  context.go('/second');
                },
                child: Text('Go to Second Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
