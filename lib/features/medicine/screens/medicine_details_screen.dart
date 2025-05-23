import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';

/// Medicine details screen
class MedicineDetailsScreen extends StatefulWidget {
  /// Medicine ID
  final String medicineId;

  /// Constructor
  const MedicineDetailsScreen({
    super.key,
    required this.medicineId,
  });

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  bool _isLoading = true;
  
  // Dummy medicine data
  late final Map<String, dynamic> _medicineData = {
    'name': 'Sample Medicine',
    'dosage': '10mg',
    'schedule': 'Once daily',
    'notes': 'Take after breakfast',
    'imageUrl': null,
    'createdAt': DateTime.now().subtract(const Duration(days: 7)),
  };

  @override
  void initState() {
    super.initState();
    _loadMedicineDetails();
  }

  Future<void> _loadMedicineDetails() async {
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: Load actual medicine data
    
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToEdit() {
    context.go('${AppRoutes.medicines}/${widget.medicineId}/edit');
  }

  void _navigateToReorder() {
    context.go('${AppRoutes.medicines}/${widget.medicineId}/reorder');
  }

  Future<void> _deleteMedicine() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: const Text(
          'Are you sure you want to delete this medicine? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement actual delete logic
      
      if (!mounted) return;
      
      // Navigate back to medicines list
      context.go(AppRoutes.medicines);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Medicine Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _navigateToEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteMedicine,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMedicineHeader(theme),
            const SizedBox(height: 24),
            _buildInfoSection(theme),
            const SizedBox(height: 24),
            _buildNotesSection(theme),
            const SizedBox(height: 32),
            AppButton(
              text: 'Reorder Medicine',
              onTap: _navigateToReorder,
              icon: Icons.shopping_cart_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.medication,
            size: 40,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _medicineData['name'],
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                _medicineData['dosage'],
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Added on ${_formatDate(_medicineData['createdAt'])}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine Information',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              theme,
              'Schedule',
              _medicineData['schedule'],
              Icons.schedule_outlined,
            ),
            const Divider(),
            _buildInfoItem(
              theme,
              'Next Dose',
              'Today, 8:00 PM',
              Icons.alarm_outlined,
            ),
            const Divider(),
            _buildInfoItem(
              theme,
              'Remaining',
              '12 tablets',
              Icons.inventory_2_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _medicineData['notes'] ?? 'No notes added',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // TODO: Use intl package for proper formatting
    return '${date.day}/${date.month}/${date.year}';
  }
}
