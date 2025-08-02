import 'package:app/data/presentation/providers/medicines.provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:uuid/uuid.dart';

import 'package:app/data/models/medicines.dart';

class VaultMedicines extends ConsumerStatefulWidget {
  const VaultMedicines({super.key});

  @override
  ConsumerState<VaultMedicines> createState() => VaultMedicinesState();
}

class VaultMedicinesState extends ConsumerState<VaultMedicines> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final int _medicinesPerPage = 10;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _editMedicine(Medicines medicineToEdit) async {
    final updatedMedicine = await showDialog<Medicines>(
      context: context,
      builder: (context) => _EditMedicineDialog(medicines: medicineToEdit),
    );

    if (updatedMedicine != null) {
      ref.invalidate(medicineDataProvider);
    }
  }

  void _addNewMedicineManually() async {
    const uuid = Uuid();
    final newMedicine = Medicines(
      id: uuid.v4(),
      userId: '',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      notes: '',
      isActive: true,
      medicine: Medicine(
        medicineId: uuid.v4(),
        name: '',
        manufacturer: '',
        genericName: '',
      ),
    );

    final addedMedicine = await showDialog<Medicines>(
      context: context,
      builder: (context) =>
          _EditMedicineDialog(medicines: newMedicine, isNewEntry: true),
    );

    if (addedMedicine != null) {
      ref.invalidate(medicineDataProvider);
    }
  }

  void _addNewMedicineByScan() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image scan functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showAddMedicineOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Add New Medicine',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.blue,
              ),
              title: const Text('Scan Image'),
              onTap: () {
                Navigator.pop(context);
                _addNewMedicineByScan();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit_note_outlined,
                color: Colors.green,
              ),
              title: const Text('Manually Add'),
              onTap: () {
                Navigator.pop(context);
                _addNewMedicineManually();
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(medicineDataProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (allMedicines) {
        final numPages = allMedicines.isEmpty
            ? 0
            : (allMedicines.length / _medicinesPerPage).ceil();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Medicines",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // FIX: Use Expanded to take available space and prevent overflow
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: numPages,
                onPageChanged: (index) {
                  setState(() => _currentPageIndex = index);
                },
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * _medicinesPerPage;
                  final endIndex = (startIndex + _medicinesPerPage).clamp(
                    0,
                    allMedicines.length,
                  );
                  final medicinesForPage = allMedicines.sublist(
                    startIndex,
                    endIndex,
                  );

                  // Create a fixed grid of 10 items with flexible sizing
                  return AnimationLimiter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(_medicinesPerPage, (index) {
                        if (index < medicinesForPage.length) {
                          final medicineData = medicinesForPage[index];
                          return Expanded(
                            child: AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _MedicineListItem(
                                    key: ValueKey(medicineData.id),
                                    medicinesData: medicineData,
                                    onTap: () =>
                                        context.go('/vault/${medicineData.id}'),
                                    onLongPress: () =>
                                        _editMedicine(medicineData),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Empty placeholder that takes equal space
                          return const Expanded(child: SizedBox());
                        }
                      }),
                    ),
                  );
                },
              ),
            ),
            // Pagination controls - takes only needed space
            if (numPages > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _currentPageIndex > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 20,
                      ),
                      splashRadius: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      " ${_currentPageIndex + 1} / $numPages ",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _currentPageIndex < numPages - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 20,
                      ),
                      splashRadius: 22,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

// Keep all the other widget classes from your original code
class _MedicineListItem extends StatelessWidget {
  const _MedicineListItem({
    required this.medicinesData,
    required this.onTap,
    required this.onLongPress,
    Key? key,
  }) : super(key: key);

  final Medicines medicinesData;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(0),
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(
                Icons.medical_services,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    medicinesData.medicine.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    medicinesData.notes,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_outward_rounded, size: 20),
              splashRadius: 22,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditMedicineDialog extends StatefulWidget {
  final Medicines medicines;
  final bool isNewEntry;

  const _EditMedicineDialog({
    Key? key,
    required this.medicines,
    this.isNewEntry = false,
  }) : super(key: key);

  @override
  State<_EditMedicineDialog> createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<_EditMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.medicines.medicine.name,
    );
    _notesController = TextEditingController(text: widget.medicines.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        widget.isNewEntry ? 'Add New Medicine' : 'Edit Medicine Details',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name cannot be empty'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes / Description',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final result = widget.medicines.copyWith(
                notes: _notesController.text.trim(),
                medicine: widget.medicines.medicine.copyWith(
                  name: _nameController.text.trim(),
                ),
              );
              Navigator.of(context).pop(result);
            }
          },
          child: Text(widget.isNewEntry ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
