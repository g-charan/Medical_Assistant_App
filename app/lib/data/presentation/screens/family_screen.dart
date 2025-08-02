import 'package:app/data/presentation/providers/family.providers.dart';
import 'package:app/data/presentation/widgets/ui/family/family_card.dart';
import 'package:app/data/presentation/widgets/utils/app_refresher.dart';
import 'package:app/data/presentation/widgets/utils/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// The FamilyScreen, now a simple and clean ConsumerWidget.
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFamilyData = ref.watch(familyDataProvider);

    return Scaffold(
      body: AppRefresher(
        onRefresh: () => ref.refresh(familyDataProvider.future),
        child: CustomScrollView(
          slivers: [
            AsyncValueWidget(
              value: asyncFamilyData,
              data: (familyMembers) {
                if (familyMembers.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("No family members found.")),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(12.0),
                  sliver: SliverList.builder(
                    itemCount: familyMembers.length,
                    itemBuilder: (context, index) {
                      final member = familyMembers[index];

                      // Apply animations to each item in the list.
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          horizontalOffset: 200.0,
                          child: FadeInAnimation(
                            child: Padding(
                              // Apply spacing between cards.
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: FamilyCard(familyMember: member),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              // Provide a custom error widget with a retry button.
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $err'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => ref.refresh(familyDataProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(familyDataProvider.future),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
