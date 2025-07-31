// app/data/presentation/widgets/vault/vault_screen.dart
import 'dart:io';

import 'package:app/data/presentation/widgets/family/family_list.dart';
import 'package:app/data/presentation/widgets/vault/vault_medicines.dart';
import 'package:flutter/foundation.dart'; // For logging in debug mode
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final GlobalKey<VaultMedicinesState> _vaultMedicinesKey =
      GlobalKey<VaultMedicinesState>();

  /// Handles the complete OCR process from picking an image to recognition.
  Future<void> _scanWithOCR() async {
    final ImagePicker picker = ImagePicker();
    // Launch the camera to let the user take a picture.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    // Ensure the widget is still mounted and an image was captured.
    if (image == null || !mounted) return;

    // Show a snackbar to indicate processing has started.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recognizing text...')));

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      // **FIXED:** Use the default constructor which defaults to the Latin script.
      final textRecognizer = TextRecognizer();

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      // **Log the recognized text to the console as requested.**
      if (kDebugMode) {
        print('--- OCR Result ---');
        print(recognizedText.text);
        print('--------------------');
      }

      // Close the recognizer to free up resources.
      textRecognizer.close();

      // Hide the "processing" snackbar and show a success message.
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Text recognized and logged to console!')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during text recognition: $e');
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not recognize text.')),
      );
    }
  }

  /// Shows a modal bottom sheet with options to add a medicine.
  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Scan Medicine Cover'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _scanWithOCR();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Add Manually'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _vaultMedicinesKey.currentState?.showAddMedicineOptions();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              // This part of your code remains unchanged.
              SizedBox(
                height:
                    638.0, // Calculated to fit 10 items + title + pagination
                child: VaultMedicines(key: _vaultMedicinesKey),
              ),
              const SizedBox(height: 10),
              FamilyList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // **MODIFIED:** This now calls our new method to show options.
          _showAddOptions();
        },
        label: const Text('Add Medicine'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
