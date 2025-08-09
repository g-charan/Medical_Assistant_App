import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date formatting

// Assuming these providers and widgets exist from your previous code
import 'package:app/data/presentation/providers/medicines.provider.dart';
import 'package:app/data/presentation/widgets/utils/app_refresher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // FIX: Moved color constants outside the build method to be accessible by all helper methods.
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.grey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineAsyncValue = ref.watch(medicineDataProvider);
    final today = DateTime.now();

    final cardBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(color: Colors.grey.shade300),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppRefresher(
        onRefresh: () async {
          await ref.refresh(medicineDataProvider.future);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- Header ---
              _buildHeader(context, medicineAsyncValue, today),
              const SizedBox(height: 24),

              // --- Metrics Card ---
              _buildMetricsCard(context),
              const SizedBox(height: 24),

              // --- Upcoming Medicine ---
              _buildSectionTitle(context, "Upcoming Medicine"),
              const SizedBox(height: 8),
              _buildUpcomingMedicine(context),
              const SizedBox(height: 24),

              // --- Family Members ---
              _buildSectionTitle(context, "Family Members"),
              const SizedBox(height: 16),
              _buildFamilyMembers(context),
              const SizedBox(height: 24),

              // --- Quick Actions ---
              _buildSectionTitle(context, "Quick Actions"),
              const SizedBox(height: 16),
              _buildQuickActions(context, cardBorder),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets for Building Sections ---

  Widget _buildHeader(
    BuildContext context,
    AsyncValue medicineAsyncValue,
    DateTime today,
  ) {
    return medicineAsyncValue.when(
      data: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello, Jayasree", // Placeholder name
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat(
                  'EEEE, MMM d',
                ).format(today), // e.g., Wednesday, Aug 6
                style: const TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // This is where you put the code that runs when the avatar is tapped.
              // For example, you could navigate to a profile screen.
              context.go('/settings'); // Example route
              print('Avatar tapped!');
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
              // child: Icon(Icons.person, color: Colors.white), // Or an image
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Text("Error loading data"),
    );
  }

  Widget _buildMetricsCard(BuildContext context) {
    // This is a placeholder for the card with a PageView
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF8F8F8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "122/80",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("mmHg", style: TextStyle(color: secondaryTextColor)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        SizedBox(width: 4),
                        Text("Normal", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 12),
                        SizedBox(width: 4),
                        Text(
                          "Excellent",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  label: const Text("Heart Rate"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Last updated: 2 min ago",
              style: TextStyle(color: secondaryTextColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUpcomingMedicine(BuildContext context) {
    return Column(
      children: [
        _buildMedicineTile(
          context,
          "Vitamin D3 1100",
          "After food - 7:00 PM",
          true,
        ),
        const SizedBox(height: 8),
        _buildMedicineTile(
          context,
          "Paracetamol",
          "After lunch - 1:00 PM",
          false,
        ),
      ],
    );
  }

  Widget _buildMedicineTile(
    BuildContext context,
    String name,
    String time,
    bool isTaken,
  ) {
    return ListTile(
      leading: Icon(
        isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isTaken ? Colors.green : Colors.grey,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(time),
      trailing: const Icon(Icons.medication, color: Colors.orangeAccent),
      onTap: () {},
    );
  }

  Widget _buildFamilyMembers(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFamilyMemberAvatar(context, "Jayasree", "JG", "23min ago"),
        _buildFamilyMemberAvatar(context, "Charan", "CG", "4h ago"),
        _buildFamilyMemberAvatar(
          context,
          "Add Member",
          null,
          null,
          isAddButton: true,
        ),
      ],
    );
  }

  Widget _buildFamilyMemberAvatar(
    BuildContext context,
    String name,
    String? initials,
    String? updated, {
    bool isAddButton = false,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isAddButton
              ? Colors.blue.shade50
              : Colors.purple.shade50,
          child: isAddButton
              ? Icon(Icons.add, color: Colors.blue.shade800, size: 30)
              : Text(
                  initials ?? "",
                  style: TextStyle(
                    color: Colors.purple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (updated != null)
          Text(
            "Updated $updated",
            style: const TextStyle(color: secondaryTextColor, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ShapeBorder cardShape) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(
          context,
          "Add Medicine",
          Icons.medication_outlined,
          () => context.go('/vault'),
        ),
        _buildActionCard(
          context,
          "Upload Reports",
          Icons.file_upload_outlined,
          () => context.go('/reports'),
        ), // Placeholder route
        _buildActionCard(
          context,
          "Track Metrics",
          Icons.bar_chart_outlined,
          () => context.go('/metrics'),
        ),
        _buildActionCard(
          context,
          "Ask AI",
          Icons.smart_toy_outlined,
          () => context.go('/ai'),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
