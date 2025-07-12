import 'package:app/common/widgets/loading_circle.dart';
import 'package:app/data/models/welcomeJson.dart';
import 'package:app/data/presentation/providers/medicine_providers.dart';
import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/goals/goals_list.dart';
import 'package:app/data/presentation/widgets/calendar/calendar_slide.dart';
import 'package:app/data/presentation/widgets/alerts/upcoming_alerts.dart';
import 'package:app/data/presentation/widgets/medicine/upcoming_medicine.dart';
import 'package:app/data/services/medicines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This function can remain outside or be moved into the State class if it needs
// access to the State's properties. For a simple dialog, it's fine here.
void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Simple Pop-up'), // Simpler title
        content: const Text(
          'This is a very basic pop-up message.',
        ), // Simpler content
        actions: <Widget>[
          TextButton(
            child: const Text('Close'), // Simpler button text
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
}

// 1. Conver HomeScreen to a consumerWidget
class HomeScreen extends ConsumerWidget {
  // If you had any mutable state variables, they would go here.
  // For example:
  // String _userName = "Charan"; // If the name "Charan" could change dynamically

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeAsyncValue = ref.watch(welcomeDataProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Stack(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello There!! Charan", // If _userName was used, it would be 'Hello There!! $_userName'
                      style: TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
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
                    Text(
                      welcomeAsyncValue.when(
                        data: (welcomeData) {
                          return welcomeData.name; // Displaying welcome message
                        },
                        loading: () => '..Loading', // Displaying loading state
                        error: (error, stack) => 'Error: $error',
                        skipLoadingOnRefresh: false,
                        skipLoadingOnReload: false,
                      ), // Displaying welcome data
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 100,
                    ), // Added some extra space at the bottom
                  ],
                ),
              ],
            ),

            Positioned(
              bottom: 80,
              right: 20,
              child: ElevatedButton(
                onPressed: () => ref.invalidate(
                  welcomeDataProvider,
                ), // Show the alert dialog on button press
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
                  minimumSize: WidgetStateProperty.all(const Size(50, 50)),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
