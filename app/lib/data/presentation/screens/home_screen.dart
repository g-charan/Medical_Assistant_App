import 'package:app/data/models/welcomeJson.dart';
import 'package:app/data/presentation/providers/medicine_providers.dart';
import 'package:app/data/presentation/providers/refresh_controller_provider.dart';
import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/goals/goals_list.dart';
import 'package:app/data/presentation/widgets/calendar/calendar_slide.dart';
import 'package:app/data/presentation/widgets/alerts/upcoming_alerts.dart';
import 'package:app/data/presentation/widgets/medicine/upcoming_medicine.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// ✅ RefreshController Provider

/// ✅ Show basic popup alert (optional feature)
void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Simple Pop-up'),
        content: const Text('This is a very basic pop-up message.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

/// ✅ Main HomeScreen
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Refresh handler
  void _onRefresh(WidgetRef ref, RefreshController controller) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      ref.invalidate(welcomeDataProvider);
      await Future.delayed(const Duration(milliseconds: 200));
      controller.refreshCompleted();
    } catch (e) {
      controller.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeAsyncValue = ref.watch(welcomeDataProvider);
    final refreshController = ref.watch(refreshControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          SmartRefresher(
            controller: refreshController,
            onRefresh: () => _onRefresh(ref, refreshController),
            enablePullDown: true,
            enablePullUp: false,
            physics: const BouncingScrollPhysics(),
            header: const ClassicHeader(
              releaseText: "Release to refresh",
              completeText: "Refresh completed",
              failedText: "Refresh failed",
              idleText: "Pull down to refresh",
            ),
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
                            const Text(
                              "Hello There!! Charan",
                              style: TextStyle(fontSize: 32),
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
                            const SizedBox(height: 20),
                            welcomeAsyncValue.when(
                              data: (welcomeData) => Text(
                                welcomeData.name,
                                style: const TextStyle(fontSize: 24),
                              ),
                              loading: () => const Text('..Loading'),
                              error: (error, stack) => Text('Error: $error'),
                              skipLoadingOnRefresh: false,
                              skipLoadingOnReload: false,
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ✅ Floating Refresh Button inside Stack
          Positioned(
            bottom: 80,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                ref.invalidate(welcomeDataProvider);
                refreshController.requestRefresh();
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
                minimumSize: WidgetStateProperty.all(const Size(50, 50)),
                shape: WidgetStateProperty.all(const CircleBorder()),
              ),
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
