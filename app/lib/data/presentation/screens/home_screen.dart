import 'package:app/data/models/medicines.dart';
import 'package:app/data/presentation/providers/medicine_providers.dart';
import 'package:app/data/presentation/providers/medicines.provider.dart';

import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/goals/goals_list.dart';
import 'package:app/data/presentation/widgets/calendar/calendar_slide.dart';
import 'package:app/data/presentation/widgets/alerts/upcoming_alerts.dart';
import 'package:app/data/presentation/widgets/medicine/upcoming_medicine.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// Main HomeScreen
// FIX: Converted to a ConsumerStatefulWidget to manage the RefreshController's lifecycle.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Create a local RefreshController instance.
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller when the widget is first created.
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the tree.
    _refreshController.dispose();
    super.dispose();
  }

  /// Refresh handler
  void _onRefresh() async {
    try {
      // Invalidate providers to re-fetch data in the background.
      ref.invalidate(medicineDataProvider);
      // You can invalidate other providers here as well
      // ref.invalidate(anotherDataProvider);

      // Simulate a short delay for the refresh indicator
      await Future.delayed(const Duration(milliseconds: 800));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicineAsyncValue = ref.watch(medicineDataProvider);
    print(medicineAsyncValue);

    // Use the locally managed _refreshController.
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        header: const ClassicHeader(),
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
                          data: (medicineData) => Column(
                            children: [
                              ...medicineData.map((Medicines data) {
                                return Text(
                                  "Hello There!! ${data.medicine.name}",
                                  style: const TextStyle(fontSize: 32),
                                );
                              }),
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
      // Use the standard FloatingActionButton for better layout stability
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshController.requestRefresh();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
