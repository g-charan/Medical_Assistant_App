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
import 'dart:io';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  bool _isProcessing = false;

  Future<void> _scanWithOCR() async {
    if (_isProcessing) return; // Prevent multiple concurrent calls

    setState(() {
      _isProcessing = true;
    });

    if (kDebugMode) {
      print('--- Starting OCR process ---');
    }

    TextRecognizer? textRecognizer;

    try {
      final ImagePicker picker = ImagePicker();

      if (kDebugMode) {
        print('Opening image picker...');
      }

      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Good balance between quality and file size
        maxWidth: 1920,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (kDebugMode) {
        print('Image picker result: ${image?.path ?? 'null'}');
      }

      // Check if user cancelled or if widget is disposed
      if (image == null) {
        if (kDebugMode) {
          print('User cancelled image picker');
        }
        return;
      }

      // Important: Check if widget is still mounted before proceeding
      if (!mounted) {
        if (kDebugMode) {
          print('Widget disposed after image capture, cleaning up...');
        }
        // Clean up the image file
        try {
          await File(image.path).delete();
        } catch (e) {
          if (kDebugMode) print('Could not delete temp image: $e');
        }
        return;
      }

      // Verify file exists and is readable
      final File imageFile = File(image.path);
      if (!await imageFile.exists()) {
        if (kDebugMode) {
          print('Image file does not exist at path: ${image.path}');
        }
        _showMessage('Error: Image file not found', isError: true);
        return;
      }

      // Show processing message
      _showMessage('📷 Processing image...', showProgress: true);

      if (kDebugMode) {
        print('Creating InputImage from path: ${image.path}');
        final fileSize = await imageFile.length();
        print('Image file size: ${fileSize} bytes');
      }

      final inputImage = InputImage.fromFilePath(image.path);

      // Create text recognizer
      textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

      if (kDebugMode) {
        print('Starting text recognition...');
      }

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      if (kDebugMode) {
        print('Text recognition completed');
        print('Recognized text length: ${recognizedText.text.length}');
        print('Number of blocks: ${recognizedText.blocks.length}');
      }

      // Check if widget is still mounted before updating UI
      if (!mounted) {
        if (kDebugMode) {
          print('Widget disposed during OCR processing');
        }
        return;
      }

      // Process the results
      await _handleOCRResult(recognizedText);

      // Clean up temporary image file
      try {
        await imageFile.delete();
        if (kDebugMode) {
          print('Temporary image file deleted');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Could not delete temporary image: $e');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('--- OCR ERROR ---');
        print('Error: $e');
        print('Stack trace: $stackTrace');
        print('----------------');
      }

      if (mounted) {
        _showMessage('Error processing image: ${e.toString()}', isError: true);
      }
    } finally {
      // Always clean up the recognizer
      try {
        await textRecognizer?.close();
      } catch (e) {
        if (kDebugMode) {
          print('Error closing text recognizer: $e');
        }
      }

      // Reset processing state
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleOCRResult(RecognizedText recognizedText) async {
    final String cleanText = recognizedText.text.trim();

    if (cleanText.isEmpty) {
      if (kDebugMode) {
        print('--- OCR Result: No text recognized ---');
        print('Blocks found: ${recognizedText.blocks.length}');
        for (int i = 0; i < recognizedText.blocks.length; i++) {
          print('Block $i: "${recognizedText.blocks[i].text.trim()}"');
        }
      }

      _showMessage(
        '📄 No text detected. Try:\n'
        '• Better lighting\n'
        '• Hold camera steady\n'
        '• Get closer to text',
        duration: 5,
      );
      return;
    }

    // Success case
    if (kDebugMode) {
      print('--- OCR SUCCESS ---');
      print('Full text: "$cleanText"');
      print('Text length: ${cleanText.length}');
      print('Lines: ${cleanText.split('\n').length}');
      print('------------------');
    }

    // Show success with preview
    final String preview = cleanText.length > 80
        ? '${cleanText.substring(0, 80)}...'
        : cleanText;

    _showMessage(
      '✅ Text recognized!\nPreview: $preview',
      duration: 6,
      action: SnackBarAction(
        label: 'View Full',
        onPressed: () => _showFullTextDialog(cleanText),
      ),
    );

    // TODO: Process the medicine text here
    // await _processMedicineInformation(cleanText);
  }

  void _showMessage(
    String message, {
    bool isError = false,
    bool showProgress = false,
    int duration = 3,
    SnackBarAction? action,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showProgress) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        duration: Duration(seconds: duration),
        backgroundColor: isError ? Colors.red[600] : null,
        action: action,
      ),
    );
  }

  void _showFullTextDialog(String text) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recognized Text'),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: SelectableText(
              text,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Process the text for medicine information
              _processMedicineText(text);
            },
            child: const Text('Add Medicine'),
          ),
        ],
      ),
    );
  }

  void _processMedicineText(String text) {
    // TODO: Implement your medicine processing logic here
    if (kDebugMode) {
      print('Processing medicine text: $text');
    }

    _showMessage('🔄 Processing medicine information...');

    // You can parse the text for medicine names, dosages, etc.
    // Example parsing logic:
    // final medicineInfo = _parseMedicineInfo(text);
    // Then add to your medicines provider
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: _isProcessing ? Colors.grey : null,
                ),
                title: Text(
                  _isProcessing ? 'Processing...' : 'Scan Medicine Cover',
                ),
                subtitle: Text(
                  _isProcessing
                      ? 'Please wait...'
                      : 'Use camera to recognize text',
                ),
                enabled: !_isProcessing,
                onTap: _isProcessing
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        _scanWithOCR();
                      },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Add Manually'),
                subtitle: const Text('Enter medicine details manually'),
                onTap: () {
                  Navigator.of(context).pop();
                  // ref.read(showAddMedicineDialogProvider.notifier).state = true;
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppRefresher(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(medicineDataProvider.future),
            ref.refresh(familyDataProvider.future),
          ]);
        },
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
                SizedBox(height: 620, child: VaultMedicines()),
                const SizedBox(height: 10),
                FamilyList(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isProcessing ? null : _showAddOptions,
        label: Text(_isProcessing ? 'Processing...' : 'Add Medicine'),
        icon: _isProcessing
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
        backgroundColor: _isProcessing
            ? Colors.grey
            : Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
