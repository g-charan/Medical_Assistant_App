import 'package:flutter/material.dart';

/// Medicine card widget
class MedicineCard extends StatelessWidget {
  /// Medicine name
  final String name;
  
  /// Medicine dosage
  final String dosage;
  
  /// Medicine schedule
  final String schedule;
  
  /// Medicine image URL
  final String? imageUrl;
  
  /// On tap callback
  final VoidCallback? onTap;
  
  /// On edit callback
  final VoidCallback? onEdit;
  
  /// On reorder callback
  final VoidCallback? onReorder;

  /// Constructor
  const MedicineCard({
    super.key,
    required this.name,
    required this.dosage,
    required this.schedule,
    this.imageUrl,
    this.onTap,
    this.onEdit,
    this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildMedicineImage(theme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dosage,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActions(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineImage(ThemeData theme) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.medication,
                    color: theme.colorScheme.primary,
                    size: 30,
                  );
                },
              ),
            )
          : Icon(
              Icons.medication,
              color: theme.colorScheme.primary,
              size: 30,
            ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    return Column(
      children: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: onEdit,
            tooltip: 'Edit',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        if (onReorder != null)
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 20),
            onPressed: onReorder,
            tooltip: 'Reorder',
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
      ],
    );
  }
}
