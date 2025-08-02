import 'package:app/data/presentation/providers/family.providers.dart';
import 'package:app/data/presentation/providers/medicines.provider.dart';
import 'package:app/data/presentation/widgets/ui/family/family_list.dart';
import 'package:app/data/presentation/widgets/ui/vault/vault_medicines.dart';
import 'package:app/data/presentation/widgets/utils/app_refresher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  Future<void> _scanWithOCR(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null || !context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recognizing text...')));

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      if (kDebugMode) {
        print('--- OCR Result ---');
        print(recognizedText.text);
        print('--------------------');
      }

      await textRecognizer.close();

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text recognized and logged to console!'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error during text recognition: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not recognize text.')),
        );
      }
    }
  }

  void _showAddOptions(BuildContext context, WidgetRef ref) {
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
                  Navigator.of(context).pop();
                  _scanWithOCR(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Add Manually'),
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(showAddMedicineDialogProvider.notifier).state = true;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AppRefresher(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(medicineDataProvider.future),
            ref.refresh(familyDataProvider.future),
          ]);
        },
        // FIX: Use SingleChildScrollView with proper layout
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // FIX: Wrap VaultMedicines with proper height calculation
                SizedBox(
                  height:
                      620, // Title(20) + spacing(10) + medicines(540) + pagination(50)
                  child: VaultMedicines(),
                ),
                const SizedBox(height: 10),
                // Your FamilyList widget
                FamilyList(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddOptions(context, ref);
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
