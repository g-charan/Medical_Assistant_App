import 'package:app/data/presentation/providers/medicines.provider.dart';
// Import your AppRefresher widget

import 'package:app/data/presentation/widgets/ui/family/family_list.dart';
import 'package:app/data/presentation/widgets/ui/goals/goals_list.dart';
import 'package:app/data/presentation/widgets/ui/calendar/calendar_slide.dart';
import 'package:app/data/presentation/widgets/ui/alerts/upcoming_alerts.dart';
import 'package:app/data/presentation/widgets/ui/medicine/upcoming_medicine.dart';
import 'package:app/data/presentation/widgets/utils/app_refresher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FIX: Converted to a simpler ConsumerWidget. No more state management needed here.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The watch call remains the same.
    final medicineAsyncValue = ref.watch(medicineDataProvider);
    print(medicineAsyncValue);

    return Scaffold(
      // The body is now wrapped with your reusable AppRefresher.
      body: AppRefresher(
        // The refresh logic is now a single, correct line.
        onRefresh: () async {
          // You can refresh multiple providers at once if needed.
          await Future.wait([
            ref.refresh(medicineDataProvider.future),
            // ref.refresh(anotherProvider.future),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              sliver: SliverToBoxAdapter(
                child: AnimationLimiter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        // The .when is now inline, only affecting the welcome text.
                        medicineAsyncValue.when(
                          data: (medicineData) => const Column(
                            children: [
                              Text(
                                "Hello There!! Charan",
                                style: TextStyle(fontSize: 32),
                              ),
                            ],
                          ),
                          // Show a placeholder while loading
                          loading: () => Container(
                            height: 38, // Approx height of the text
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Show a generic welcome message on error
                          error: (err, stack) => const Text(
                            "Hello There!!",
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(height: 50.0, child: CalendarSlide()),
                        const SizedBox(height: 20),
                        UpcomingMedicine(),
                        const SizedBox(height: 20),
                        GoalsList(),
                        const SizedBox(height: 20),
                        UpcomingAlerts(),
                        const SizedBox(height: 20),
                        FamilyList(),
                        const SizedBox(height: 100), // Padding at bottom
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // The FAB can also trigger a refresh using the same correct logic.
          ref.refresh(medicineDataProvider.future);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
