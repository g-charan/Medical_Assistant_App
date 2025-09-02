import 'package:app/core/utils/app_refresher.dart';
import 'package:app/core/utils/async_value_widget.dart';
import 'package:app/data/models/family.models.dart'; // Assuming your model is here
import 'package:app/features/family/presentation/providers/family_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart'; // FIX: Added go_router import
import 'package:intl/intl.dart'; // Import for date formatting

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFamilyData = ref.watch(familyDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppRefresher(
        onRefresh: () => ref.refresh(familyDataProvider.future),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStatsGrid(),
              const SizedBox(height: 20),
              // This AsyncValueWidget now only wraps the family list
              AsyncValueWidget(
                value: asyncFamilyData,
                // The `data` callback now correctly handles the dynamic list from the provider.
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (familyMembers) =>
                    _buildFamilyMemberList(context, familyMembers as List),
                error: (err, stack) => Center(
                  child: Column(
                    children: [
                      Text('Error: $err'),
                      ElevatedButton(
                        onPressed: () => ref.refresh(familyDataProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("Upcoming Reminders"),
              const SizedBox(height: 10),
              _buildRemindersList(),
              const SizedBox(height: 30),
              _buildSectionTitle("Recent Activity"),
              const SizedBox(height: 10),
              _buildActivityList(),
              const SizedBox(height: 30),
              _buildSectionTitle("Quick Actions"),
              const SizedBox(height: 10),
              _buildQuickActionsGrid(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets for the new UI ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Check your family vault",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const FaIcon(FontAwesomeIcons.plus),
          label: const Text("Add"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A5A40),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.5,
      children: [
        _buildStatCard("5", "Family Members"),
        _buildStatCard("20", "Active Medications"),
        _buildStatCard("12", "Completed Today"),
        _buildStatCard("3", "Missed Today", valueColor: Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFDAD7CD).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFDAD7CD), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberList(BuildContext context, List familyMembers) {
    if (familyMembers.isEmpty) {
      return const Center(child: Text("No family members found."));
    }
    return ListView.separated(
      itemCount: familyMembers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = familyMembers[index];
        final name = member.relatedUser.name ?? "No Name";
        final updatedAt = DateFormat.yMMMd().format(
          member.relatedUser.updatedAt,
        );

        final initials = name.isNotEmpty
            ? name.substring(0, 2).toUpperCase()
            : "??";
        final color = Colors.primaries[index % Colors.primaries.length];

        return ListTile(
          tileColor: Color(0xFFDAD7CD).withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xFFDAD7CD), width: 1.0),
          ),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Text(
              initials,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Updated on $updatedAt"),
          trailing: const Icon(Icons.chevron_right),
          // FIX: Added navigation to the family member detail screen.
          onTap: () {
            context.go('/family/${member.relatedUser.id}');
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRemindersList() {
    // Dummy data
    final reminders = [
      {
        "name": "Jayasree Gutti",
        "task": "Insulin Injection",
        "time": "2:00 PM",
        "priority": "High Priority",
        "color": Colors.red,
      },
      {
        "name": "Charan Gutti",
        "task": "Blood pressure medication",
        "time": "6:00 PM",
        "priority": "Medium Priority",
        "color": Colors.orange,
      },
      {
        "name": "Meera Gutti",
        "task": "Arthritis medication",
        "time": "8:00 PM",
        "priority": "High Priority",
        "color": Colors.red,
      },
      {
        "name": "Priya Gutti",
        "task": "Vitamin supplements",
        "time": "9:00 PM",
        "priority": "Low Priority",
        "color": Colors.green,
      },
    ];
    return Column(
      spacing: 8,
      children: reminders.map((r) {
        return ListTile(
          tileColor: Color(0xFFDAD7CD).withValues(alpha: 0.2),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xFFDAD7CD), width: 1.0),
          ),
          leading: Icon(
            Icons.notifications_active_outlined,
            color: r['color'] as Color,
          ),
          title: Text(
            r['name'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(r['task'] as String),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                r['time'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                r['priority'] as String,
                style: TextStyle(color: r['color'] as Color, fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityList() {
    // Dummy data
    final activities = [
      {
        "icon": Icons.add,
        "name": "Jayasree Gutti",
        "action": "Added new medication",
        "time": "2 hours ago",
      },
      {
        "icon": Icons.block,
        "name": "Charan Gutti",
        "action": "Missed medication",
        "time": "4 hours ago",
      },
      {
        "icon": Icons.check,
        "name": "Meera Gutti",
        "action": "Arthritis medication",
        "time": "6 hours ago",
      },
      {
        "icon": Icons.edit,
        "name": "Priya Gutti",
        "action": "Vitamin supplements",
        "time": "1 day ago",
      },
    ];
    return Column(
      spacing: 8,
      children: activities.map((a) {
        return ListTile(
          tileColor: Color(0xFFDAD7CD).withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xFFDAD7CD), width: 1.0),
          ),
          leading: CircleAvatar(
            backgroundColor: Color(0xFFDAD7CD).withValues(alpha: 1),
            child: Icon(
              a['icon'] as IconData,
              size: 20,
              color: Colors.grey.shade700,
            ),
          ),
          title: Text(
            a['name'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(a['action'] as String),
          trailing: Text(
            a['time'] as String,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionsGrid() {
    // Dummy data
    final actions = [
      {"icon": Icons.receipt_long_outlined, "label": "Order Medicines"},
      {"icon": Icons.assessment_outlined, "label": "Generate Report"},
      {"icon": Icons.share_outlined, "label": "Share Vault"},
      {"icon": Icons.alarm_add_outlined, "label": "Set Reminders"},
    ];
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final action = actions[index];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action['icon'] as IconData, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                action['label'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
