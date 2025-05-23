import 'package:flutter/material.dart';

/// Reorder options screen
class ReorderOptionsScreen extends StatelessWidget {
  /// Medicine ID
  final String medicineId;

  /// Constructor
  const ReorderOptionsScreen({
    super.key,
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Dummy pharmacy options
    final List<Map<String, dynamic>> pharmacies = [
      {
        'name': 'MedPlus',
        'logo': Icons.local_pharmacy,
        'deliveryTime': '30-45 min',
        'rating': 4.5,
      },
      {
        'name': '1mg',
        'logo': Icons.medication,
        'deliveryTime': '45-60 min',
        'rating': 4.3,
      },
      {
        'name': 'PharmEasy',
        'logo': Icons.medical_services,
        'deliveryTime': '60-90 min',
        'rating': 4.2,
      },
      {
        'name': 'Apollo Pharmacy',
        'logo': Icons.health_and_safety,
        'deliveryTime': '30-60 min',
        'rating': 4.4,
      },
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder Options'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Select a pharmacy to reorder your medicine',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...pharmacies.map((pharmacy) => _buildPharmacyCard(
            context,
            theme,
            pharmacy,
          )),
          const SizedBox(height: 16),
          _buildNearbyPharmaciesSection(theme),
        ],
      ),
    );
  }

  Widget _buildPharmacyCard(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> pharmacy,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openPharmacy(context, pharmacy['name']),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  pharmacy['logo'],
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy['name'],
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pharmacy['deliveryTime'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.star,
                          size: 14,
                          color: theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pharmacy['rating'].toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyPharmaciesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Pharmacies',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enable location to see nearby pharmacies',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement location permission request
                  },
                  child: const Text('Enable Location'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openPharmacy(BuildContext context, String pharmacyName) {
    // TODO: Implement pharmacy navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $pharmacyName...'),
      ),
    );
  }
}
