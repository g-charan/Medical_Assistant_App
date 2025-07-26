import 'package:app/data/presentation/providers/family.providers.dart';
// Import your provider
import 'package:app/data/presentation/widgets/family/family_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// UPDATED: Converted to a ConsumerWidget to use Riverpod
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UPDATED: Watch the provider to get the async data
    final asyncFamilyData = ref.watch(familyDataProvider);

    return Scaffold(
      // UPDATED: Use .when to handle loading, error, and data states
      body: asyncFamilyData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $err'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => ref.invalidate(familyDataProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (familyMembers) {
          if (familyMembers.isEmpty) {
            return const Center(child: Text("No family members found."));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0), // A little less padding
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: familyMembers.length,
                itemBuilder: (BuildContext context, int index) {
                  // UPDATED: Use the 'Family' object from the fetched data
                  final member = familyMembers[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 200.0,
                      child: FadeInAnimation(
                        // UPDATED: Pass the 'Family' object to the card
                        child: FamilyCard(familyMember: member),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
