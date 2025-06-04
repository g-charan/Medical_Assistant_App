import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Simple Pop-up'), // Simpler title
        content: Text(
          'This is a very basic pop-up message.',
        ), // Simpler content
        actions: <Widget>[
          TextButton(
            child: Text('Close'), // Simpler button text
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello There!! Charan", style: TextStyle(fontSize: 32)),
                const SizedBox(height: 10),
                SizedBox(
                  // PageView also needs a finite height
                  height: 60.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal, // <--- Key property
                    children: <Widget>[
                      _buildPage(Colors.grey, 'Page 1'),
                      _buildPage(Colors.grey, 'Page 2'),
                      _buildPage(Colors.grey, 'Page 3'),
                      _buildPage(Colors.grey, 'Page 1'),
                      _buildPage(Colors.grey, 'Page 2'),
                      _buildPage(Colors.grey, 'Page 3'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Upcoming Medicine"),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[_buildList(Colors.grey, "Something")],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Goals"),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[_buildList(Colors.grey, "Something")],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Upcoming Alerts"),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[_buildList(Colors.grey, "Something")],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Family"),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[_buildList(Colors.grey, "Something")],
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 80,

              right: 20,
              child: ElevatedButton(
                onPressed: () => _showAlertDialog(context),

                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.all(10)),
                  minimumSize: WidgetStateProperty.all(Size(50, 50)),
                  shape: WidgetStateProperty.all(CircleBorder()),
                ),
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Color color, String text) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
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

  Widget _buildList(Color color, String text) {
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
}
