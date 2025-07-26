import 'package:app/data/presentation/providers/family.providers.dart';
import 'package:app/data/presentation/widgets/family/family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class FamilyScreen extends ConsumerStatefulWidget {
  const FamilyScreen({super.key});

  @override
  ConsumerState<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends ConsumerState<FamilyScreen> {
  // Create a local RefreshController instance following HomeScreen pattern
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller when the widget is first created
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed from the tree
    _refreshController.dispose();
    super.dispose();
  }

  /// Refresh handler - matching HomeScreen pattern
  void _onRefresh() async {
    try {
      // Invalidate the provider to tell Riverpod to re-fetch the data
      ref.invalidate(familyDataProvider);

      // Simulate a short delay for the refresh indicator (like HomeScreen)
      await Future.delayed(const Duration(milliseconds: 800));

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncFamilyData = ref.watch(familyDataProvider);

    // Following HomeScreen's exact structure with Scaffold and SmartRefresher
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        header: const ClassicHeader(), // Same header as HomeScreen
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverToBoxAdapter(
                child: AnimationLimiter(
                  child: asyncFamilyData.when(
                    // Loading state with placeholder similar to HomeScreen
                    loading: () => SizedBox(
                      height: 200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    // Error state
                    error: (err, stack) => SizedBox(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $err'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  _refreshController.requestRefresh(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Data state with staggered animations
                    data: (familyMembers) {
                      if (familyMembers.isEmpty) {
                        return SizedBox(
                          height: 200,
                          child: const Center(
                            child: Text("No family members found."),
                          ),
                        );
                      }

                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 200.0,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            // Add family members with proper spacing
                            ...familyMembers
                                .map(
                                  (member) => Column(
                                    children: [
                                      FamilyCard(familyMember: member),
                                      const SizedBox(
                                        height: 12,
                                      ), // Spacing between cards
                                    ],
                                  ),
                                )
                                .toList(),
                            const SizedBox(
                              height: 100,
                            ), // Bottom padding like HomeScreen
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Optional: Add the same FloatingActionButton as HomeScreen for testing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshController.requestRefresh();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
