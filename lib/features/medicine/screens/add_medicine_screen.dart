import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Add medicine screen
class AddMedicineScreen extends StatefulWidget {
  /// Medicine ID for editing (optional)
  final String? medicineId;

  /// Constructor
  const AddMedicineScreen({
    super.key,
    this.medicineId,
  });

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.medicineId != null;
    
    if (_isEditing) {
      // TODO: Load medicine data for editing
      _loadMedicineData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _scheduleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicineData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // TODO: Load actual medicine data
    _nameController.text = 'Sample Medicine';
    _dosageController.text = '10mg';
    _scheduleController.text = 'Once daily';
    _notesController.text = 'Take after breakfast';
  }

  Future<void> _saveMedicine() async {
    if (_nameController.text.isEmpty ||
        _dosageController.text.isEmpty ||
        _scheduleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate saving delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    // TODO: Implement actual save logic
    
    if (!mounted) return;
    
    // Navigate back to medicines list
    context.go(AppRoutes.medicines);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Medicine' : 'Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine Information',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _nameController,
              labelText: 'Medicine Name',
              hintText: 'Enter medicine name',
              prefixIcon: Icons.medication_outlined,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _dosageController,
              labelText: 'Dosage',
              hintText: 'e.g., 10mg, 5ml, 1 tablet',
              prefixIcon: Icons.scale_outlined,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _scheduleController,
              labelText: 'Schedule',
              hintText: 'e.g., Once daily, Twice daily',
              prefixIcon: Icons.schedule_outlined,
            ),
            const SizedBox(height: 24),
            Text(
              'Additional Information',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _notesController,
              labelText: 'Notes',
              hintText: 'Add any additional notes',
              prefixIcon: Icons.note_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildImageUploadSection(theme),
            const SizedBox(height: 32),
            AppButton(
              text: _isEditing ? 'Update Medicine' : 'Add Medicine',
              onTap: _saveMedicine,
              isLoading: _isLoading,
              icon: _isEditing ? Icons.check : Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medicine Image',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to add image',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
