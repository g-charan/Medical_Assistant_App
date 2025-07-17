// app/data/presentation/widgets/vault/vault_medicines.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:app/data/models/medicine.dart';

class VaultMedicines extends StatefulWidget {
  const VaultMedicines({super.key});

  @override
  // This correctly returns an instance of the private _VaultMedicinesState
  VaultMedicinesState createState() => VaultMedicinesState();
}

class VaultMedicinesState extends State<VaultMedicines> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  List<Medicine> allMedicines = [
    // ... (your existing medicine data) ...
    Medicine(
      id: 'med1',
      name: "Vitamin D3 1000IU",
      description: "Should be taken after food.",
      iconColor: Colors.orange,
      iconData: Icons.food_bank,
    ),
    Medicine(
      id: 'med2',
      name: "Amoxicillin 500mg",
      description: "Take with water, finish the course.",
      iconColor: Colors.blue,
      iconData: Icons.local_pharmacy,
    ),
    Medicine(
      id: 'med3',
      name: "Paracetamol 650mg",
      description: "For fever and pain relief.",
      iconColor: Colors.green,
      iconData: Icons.medical_services,
    ),
    Medicine(
      id: 'med4',
      name: "Omeprazole 20mg",
      description: "Take on an empty stomach.",
      iconColor: Colors.purple,
      iconData: Icons.medication_liquid,
    ),
    Medicine(
      id: 'med5',
      name: "Loratadine 10mg",
      description: "For allergy relief, once daily.",
      iconColor: Colors.teal,
      iconData: Icons.masks,
    ),
    Medicine(
      id: 'med6',
      name: "Ibuprofen 400mg",
      description: "Take with food to avoid stomach upset.",
      iconColor: Colors.red,
      iconData: Icons.sick,
    ),
    Medicine(
      id: 'med7',
      name: "Multivitamin",
      description: "Daily supplement, best with breakfast.",
      iconColor: Colors.brown,
      iconData: Icons.food_bank,
    ),
    Medicine(
      id: 'med8',
      name: "Cough Syrup",
      description: "Shake well before use, follow dosage.",
      iconColor: Colors.lightGreen,
      iconData: Icons.local_hospital,
    ),
    Medicine(
      id: 'med9',
      name: "Antibiotic Cream",
      description: "Apply thinly to affected area.",
      iconColor: Colors.pink,
      iconData: Icons.vaccines,
    ),
    Medicine(
      id: 'med10',
      name: "Blood Pressure Med",
      description: "Take at the same time daily.",
      iconColor: Colors.indigo,
      iconData: Icons.monitor_heart,
    ),
    Medicine(
      id: 'med11',
      name: "Thyroid Hormone",
      description: "Take on an empty stomach, 30 min before food.",
      iconColor: Colors.cyan,
      iconData: Icons.healing,
    ),
    Medicine(
      id: 'med12',
      name: "Eye Drops",
      description: "Apply 2 drops to each eye as needed.",
      iconColor: Colors.lime,
      iconData: Icons.remove_red_eye,
    ),
    Medicine(
      id: 'med13',
      name: "Sleeping Pills",
      description: "Take before bed, use as directed.",
      iconColor: Colors.deepPurple,
      iconData: Icons.bedtime,
    ),
    Medicine(
      id: 'med14',
      name: "Digestive Aid",
      description: "Take with meals to aid digestion.",
      iconColor: Colors.amber,
      iconData: Icons.fastfood,
    ),
  ];

  final int _medicinesPerPage = 10;

  int get _numPages {
    if (allMedicines.isEmpty) return 0;
    return (allMedicines.length / _medicinesPerPage).ceil();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _editMedicine(Medicine medicineToEdit) async {
    final updatedMedicine = await showDialog<Medicine>(
      context: context,
      builder: (context) => _EditMedicineDialog(medicine: medicineToEdit),
    );

    if (updatedMedicine != null) {
      setState(() {
        final index = allMedicines.indexWhere(
          (m) => m.id == updatedMedicine.id,
        );
        if (index != -1) {
          allMedicines[index] = updatedMedicine;
        }
      });
    }
  }

  void _addNewMedicineManually() async {
    final newMedicine = Medicine(
      id: Medicine.generateUniqueId(),
      name: '',
      description: '',
      iconColor: Colors.grey,
      iconData: Icons.medication,
    );

    final addedMedicine = await showDialog<Medicine>(
      context: context,
      builder: (context) =>
          _EditMedicineDialog(medicine: newMedicine, isNewEntry: true),
    );

    if (addedMedicine != null) {
      setState(() {
        allMedicines.add(addedMedicine);
        _pageController.jumpToPage(_numPages - 1);
      });
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

  // This method is correctly public within _VaultMedicinesState
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Medicines",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SizedBox(
            height: 540.0 + ((_medicinesPerPage - 1) * 4),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _numPages,
              itemBuilder: (context, pageIndex) {
                final int startIndex = pageIndex * _medicinesPerPage;
                final int endIndex = (startIndex + _medicinesPerPage).clamp(
                  0,
                  allMedicines.length,
                );
                final List<Medicine> medicinesForPage = allMedicines.sublist(
                  startIndex,
                  endIndex,
                );

                return AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: medicinesForPage.length,
                    itemBuilder: (context, itemIndex) {
                      return AnimationConfiguration.staggeredList(
                        position: itemIndex,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _MedicineListItem(
                              key: ValueKey(medicinesForPage[itemIndex].id),
                              medicine: medicinesForPage[itemIndex],
                              onTap: () {
                                context.go(
                                  '/vault/${medicinesForPage[itemIndex].id}',
                                );
                              },
                              onLongPress: () =>
                                  _editMedicine(medicinesForPage[itemIndex]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_numPages > 1)
          Row(
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
                icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                splashRadius: 22,
              ),
              const SizedBox(width: 8),
              Text(
                " ${_currentPageIndex + 1} / $_numPages ",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _currentPageIndex < _numPages - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward_ios_outlined, size: 20),
                splashRadius: 22,
              ),
            ],
          ),
      ],
    );
  }
}

// Including _MedicineListItem and _EditMedicineDialog for completeness,
// assuming they are in the same file as VaultMedicines.
// If they are in separate public files, ensure they are correctly imported.
class _MedicineListItem extends StatefulWidget {
  const _MedicineListItem({
    required this.medicine,
    required this.onTap,
    required this.onLongPress,
    Key? key,
  }) : super(key: key);

  final Medicine medicine;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  State<_MedicineListItem> createState() => _MedicineListItemState();
}

class _MedicineListItemState extends State<_MedicineListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLongPress() async {
    await _animationController.forward();
    widget.onLongPress();
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: _handleLongPress,
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
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: widget.medicine.backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      widget.medicine.iconData,
                      color: widget.medicine.iconColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.medicine.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.medicine.description,
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
                  onPressed: widget.onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditMedicineDialog extends StatefulWidget {
  final Medicine medicine;
  final bool isNewEntry;

  const _EditMedicineDialog({
    Key? key,
    required this.medicine,
    this.isNewEntry = false,
  }) : super(key: key);

  @override
  State<_EditMedicineDialog> createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<_EditMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine.name);
    _descriptionController = TextEditingController(
      text: widget.medicine.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        widget.isNewEntry ? 'Add New Medicine' : 'Edit Medicine Details',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description cannot be empty';
                  }
                  return null;
                },
                maxLines: 3,
                minLines: 1,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final resultMedicine = widget.medicine.copyWith(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
              );
              Navigator.of(context).pop(resultMedicine);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(widget.isNewEntry ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
