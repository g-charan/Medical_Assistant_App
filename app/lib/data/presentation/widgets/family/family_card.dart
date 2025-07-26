import 'package:app/data/models/family.models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FamilyCard extends StatelessWidget {
  final Family familyMember;

  const FamilyCard({super.key, required this.familyMember});

  // Helper to determine icon based on relation
  Map<String, dynamic> _getIconFromRelation() {
    final relation = familyMember.relation.toLowerCase();
    if (relation.contains('mom') || relation.contains('mother')) {
      return {'icon': Icons.woman_rounded, 'color': Colors.pink};
    }
    if (relation.contains('dad') || relation.contains('father')) {
      return {'icon': Icons.man_rounded, 'color': Colors.blue};
    }
    if (relation.contains('child') ||
        relation.contains('son') ||
        relation.contains('daughter')) {
      return {'icon': Icons.child_care_rounded, 'color': Colors.teal};
    }
    return {'icon': Icons.person, 'color': Colors.deepPurple};
  }

  @override
  Widget build(BuildContext context) {
    final iconInfo = _getIconFromRelation();
    final name = familyMember.relatedUser.name ?? familyMember.relation;
    final lastUpdate = DateFormat(
      'MMM d, yyyy',
    ).format(familyMember.relatedUser.updatedAt);

    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias, // Ensures content respects border radius
      child: InkWell(
        onTap: () => context.go('/family/${familyMember.relationshipId}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            _buildHeader(context, name, lastUpdate, iconInfo),

            // --- Details Section ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: 'Next Appointment',
                    value: 'Dr. Smith - Jul 29, 2025', // Static data
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    context,
                    icon: Icons.medication_outlined,
                    label: 'Pending Meds Today',
                    value: '2 medications', // Static data
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Key Vitals",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildVitalChip(
                        'BP',
                        '122/80',
                        Icons.monitor_heart_outlined,
                      ),
                      _buildVitalChip(
                        'Sugar',
                        '95 mg/dL',
                        Icons.water_drop_outlined,
                      ),
                      _buildVitalChip('Oxygen', '98%', Icons.air),
                    ],
                  ),
                ],
              ),
            ),

            // --- Actions Section ---
            const Divider(height: 1),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for Building Sections ---

  Widget _buildHeader(
    BuildContext context,
    String name,
    String lastUpdate,
    Map<String, dynamic> iconInfo,
  ) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: iconInfo['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(iconInfo['icon'], color: iconInfo['color'], size: 28.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Last update: $lastUpdate',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalChip(String label, String value, IconData icon) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              // TODO: Implement call functionality
              print('Calling ${familyMember.relatedUser.name}...');
            },
            icon: Icon(
              Icons.call_outlined,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              "Call",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // TODO: Implement navigation to reports screen
              print('Viewing reports...');
            },
            icon: Icon(
              Icons.folder_copy_outlined,
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              "Reports",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                context.go('/family/${familyMember.relationshipId}'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("View Details"),
          ),
        ],
      ),
    );
  }
}
