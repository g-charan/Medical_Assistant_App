import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/goals/goals_list.dart';
import 'package:app/data/presentation/widgets/calendar/calendar_slide.dart';
import 'package:app/data/presentation/widgets/alerts/upcoming_alerts.dart';
import 'package:app/data/presentation/widgets/medicine/upcoming_medicine.dart';
import 'package:flutter/material.dart';

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
                  height: 50.0,
                  child: CalendarSlide(), // Using the CalendarSlide widget
                ),
                const SizedBox(height: 20),
                UpcomingMedicine(),
                const SizedBox(height: 20),
                GoalsList(),
                const SizedBox(height: 20),
                UpcomingAlerts(),
                const SizedBox(height: 20),
                FamilyList(),
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
}
