import 'package:flutter/material.dart';

import '../widgets/reminder_card.dart';

/// Reminders screen
class RemindersScreen extends StatefulWidget {
  /// Constructor
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _isLoading = true;
  
  // Dummy reminders data
  final List<Map<String, dynamic>> _reminders = [
    {
      'id': '1',
      'medicineName': 'Sample Medicine 1',
      'dosage': '10mg',
      'time': TimeOfDay(hour: 8, minute: 0),
      'isActive': true,
    },
    {
      'id': '2',
      'medicineName': 'Sample Medicine 2',
      'dosage': '5ml',
      'time': TimeOfDay(hour: 14, minute: 0),
      'isActive': true,
    },
    {
      'id': '3',
      'medicineName': 'Sample Medicine 3',
      'dosage': '1 tablet',
      'time': TimeOfDay(hour: 20, minute: 0),
      'isActive': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Load actual reminders data
    
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleReminderStatus(String id, bool isActive) {
    setState(() {
      final index = _reminders.indexWhere((reminder) => reminder['id'] == id);
      if (index != -1) {
        _reminders[index]['isActive'] = isActive;
      }
    });
    
    // TODO: Update reminder status in storage
  }

  Future<void> _editReminderTime(String id) async {
    final index = _reminders.indexWhere((reminder) => reminder['id'] == id);
    if (index == -1) return;
    
    final currentTime = _reminders[index]['time'] as TimeOfDay;
    
    final newTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    
    if (newTime != null) {
      setState(() {
        _reminders[index]['time'] = newTime;
      });
      
      // TODO: Update reminder time in storage
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reminders'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: _reminders.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return ReminderCard(
                  medicineName: reminder['medicineName'],
                  dosage: reminder['dosage'],
                  time: reminder['time'],
                  isActive: reminder['isActive'],
                  onToggle: (isActive) => _toggleReminderStatus(
                    reminder['id'],
                    isActive,
                  ),
                  onEdit: () => _editReminderTime(reminder['id']),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Reminders',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any medication reminders set up yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
