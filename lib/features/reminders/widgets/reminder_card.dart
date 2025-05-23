import 'package:flutter/material.dart';

/// Reminder card widget
class ReminderCard extends StatelessWidget {
  /// Medicine name
  final String medicineName;
  
  /// Medicine dosage
  final String dosage;
  
  /// Reminder time
  final TimeOfDay time;
  
  /// Is reminder active
  final bool isActive;
  
  /// On toggle callback
  final ValueChanged<bool>? onToggle;
  
  /// On edit callback
  final VoidCallback? onEdit;

  /// Constructor
  const ReminderCard({
    super.key,
    required this.medicineName,
    required this.dosage,
    required this.time,
    required this.isActive,
    this.onToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.alarm,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isActive
                          ? theme.colorScheme.onBackground
                          : theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dosage • ${_formatTime(time)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isActive
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: isActive,
                  onChanged: onToggle,
                ),
                if (onEdit != null)
                  TextButton(
                    onPressed: isActive ? onEdit : null,
                    child: Text(
                      'Edit',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
