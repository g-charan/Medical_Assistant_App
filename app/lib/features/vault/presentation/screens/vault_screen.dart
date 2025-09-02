import 'dart:async';

import 'dart:math';

import 'package:app/core/utils/app_refresher.dart';
import 'package:app/data/models/ai.models.dart';
import 'package:app/data/models/medicines.dart';
import 'package:app/features/ai/presentation/providers/ai_providers.dart';
import 'package:app/features/family/presentation/providers/family_providers.dart';
import 'package:app/features/vault/presentation/providers/medicines_provider.dart';

// import 'package:app/data/presentation/providers/ai.providers.dart';

// //Assuming your model is here

// import 'package:app/data/presentation/providers/family.providers.dart';

// import 'package:app/data/presentation/providers/medicines.provider.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:go_router/go_router.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:image_picker/image_picker.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  bool _isProcessing = false;
  int _currentPage = 0;
  final int _itemsPerPage = 5;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- REWRITTEN: This method now correctly handles the async flow and calls the new dialog ---
  Future<void> _scanWithOCR() async {
    if (_isProcessing) return;

    try {
      setState(() => _isProcessing = true);

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null || !mounted) return;

      _showMessage('📷 Processing image...', showProgress: true);

      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();

      final String rawText = recognizedText.text;
      if (!mounted) return;

      // Clean the text and trigger the AI analysis
      final String cleanedText = _cleanOcrText(rawText);
      if (cleanedText.isEmpty) {
        _showMessage('📄 No relevant text detected.', isError: true);
        return;
      }

      // Hide the "Processing..." message and show "Analyzing..."
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showMessage(
        '🤖 Analyzing text with AI...',
        showProgress: true,
        duration: 15,
      );
      print(cleanedText);

      // Call the API and wait for the state to update
      await ref.read(ocrResponseProvider.notifier).fetchAnalysis(cleanedText);

      // Read the final state from the provider
      final ocrResultState = ref.read(ocrResponseProvider);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (ocrResultState.error == null && ocrResultState.name != null) {
        _showAnalysisResultDialog(
          OcrResponse(
            name: ocrResultState.name!,
            description:
                ocrResultState.description ?? "No description provided.",
          ),
        );
      } else {
        _showMessage("❌ AI Analysis Failed.", isError: true);
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('--- OCR ERROR --- \n$e\n$stackTrace');
      }
      if (mounted) {
        _showMessage('Error processing image: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // --- NEW: A professional and clean dialog to display the AI results ---
  void _showAnalysisResultDialog(OcrResponse result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
        contentPadding: const EdgeInsets.all(24),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('AI Analysis Result'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SUGGESTED MEDICINE NAME",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  result.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "AI-GENERATED DESCRIPTION",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  result.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.inventory_2_outlined, size: 18),
            label: const Text('Save to Vault'),
            onPressed: () {
              Navigator.of(context).pop();
              // This is your dummy function for the final step
              _processMedicineText(result.name);
            },
          ),
        ],
      ),
    );
  }

  // --- UNCHANGED: All other methods remain the same ---

  String _cleanOcrText(String rawText) {
    const List<String> blocklist = [
      'batch',
      'b. no.',
      'exp',
      'mfg',
      'date',
      'price',
      'm.r.p',
      'rs.',
      'doses',
      'dose',
      'metered',
      'tablet',
      'capsule',
      'spray',
      'nasal',
      'for external use only',
      'keep out of reach',
      'schedule h',
      'drug',
      'licensed',
      'marketed',
      'company',
      'limited',
      'pvt',
      'ltd',
    ];
    final lines = rawText.split('\n');
    final List<String> cleanLines = [];
    for (var line in lines) {
      final trimmedLine = line.trim();
      final lowerCaseLine = trimmedLine.toLowerCase();
      if (trimmedLine.isEmpty) continue;
      if (blocklist.any((keyword) => lowerCaseLine.contains(keyword))) continue;
      final words = trimmedLine.split(' ');
      bool hasJunkCode = words.any((word) {
        final hasDigits = word.contains(RegExp(r'\d'));
        final hasLetters = word.contains(RegExp(r'[a-zA-Z]'));
        return hasDigits &&
            hasLetters &&
            !word.toLowerCase().contains(
              RegExp(r'(\d+(mg|ml|mcg))|([a-z]\d+)'),
            );
      });
      if (hasJunkCode) continue;
      if (double.tryParse(trimmedLine) != null) continue;
      cleanLines.add(trimmedLine);
    }
    return cleanLines.join(' ');
  }

  Future<void> _handleOCRResult(RecognizedText recognizedText) async {
    final String cleanedText = _cleanOcrText(recognizedText.text);
    if (cleanedText.isEmpty) {
      _showMessage(
        '📄 No text detected. Try:\n• Better lighting\n• Hold camera steady\n• Get closer to text',
        duration: 5,
      );
      return;
    }
    final String preview = cleanedText.length > 80
        ? '${cleanedText.substring(0, 80)}...'
        : cleanedText;
    _showMessage(
      '✅ Text recognized!\nPreview: $preview',
      duration: 6,
      action: SnackBarAction(
        label: 'View Full',
        onPressed: () => _showFullTextDialog(cleanedText),
      ),
    );
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

  void _showFullTextDialog(String? text) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cleaned Text'),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: SelectableText(
              text ?? 'No text available',
              style: const TextStyle(fontSize: 16),
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
              _processMedicineText(text);
            },
            child: const Text('Add Medicine'),
          ),
        ],
      ),
    );
  }

  void _processMedicineText(String? text) {
    if (kDebugMode) print('Processing cleaned medicine text: $text');
    _showMessage('🔄 Processing medicine information...');
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
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
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicineAsyncValue = ref.watch(medicineDataProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppRefresher(
        onRefresh: () async {
          setState(() => _currentPage = 0);
          if (_pageController.hasClients) _pageController.jumpToPage(0);
          await Future.wait([
            ref.refresh(medicineDataProvider.future),
            ref.refresh(familyDataProvider.future),
          ]);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 20),
              medicineAsyncValue.when(
                data: (List<Medicines> medicines) =>
                    _buildPaginatedContent(medicines),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Error: $err")),
              ),
              const SizedBox(height: 30),
              const Text(
                "Check your family vault",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFamilyList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Your Vault",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list),
              label: const Text("Filters"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            IconButton.filled(
              onPressed: _isProcessing ? null : _showAddOptions,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF344E41),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginatedContent(List<Medicines> medicines) {
    if (medicines.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("Your vault is empty. Add a medicine to get started!"),
        ),
      );
    }
    final totalPages = (medicines.length / _itemsPerPage).ceil();
    final int itemsOnCurrentPage = min(
      _itemsPerPage,
      medicines.length - (_currentPage * _itemsPerPage),
    );
    final double pageViewHeight =
        (88.0 * itemsOnCurrentPage) +
        (12.0 * (itemsOnCurrentPage > 1 ? itemsOnCurrentPage - 1 : 0));
    return Column(
      children: [
        SizedBox(
          height: pageViewHeight + 32, // Added padding back
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, pageIndex) {
              final startIndex = pageIndex * _itemsPerPage;
              final endIndex = min(
                startIndex + _itemsPerPage,
                medicines.length,
              );
              final pageItems = medicines.sublist(startIndex, endIndex);
              return _buildMedicineListPage(pageItems, startIndex);
            },
          ),
        ),
        const SizedBox(height: 20),
        if (totalPages > 1) _buildPagination(totalPages),
      ],
    );
  }

  Widget _buildMedicineListPage(
    List<Medicines> pageItems,
    int globalStartIndex,
  ) {
    return ListView.separated(
      itemCount: pageItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final med = pageItems[index];
        final name = med.medicine.name;
        final initials = name.isNotEmpty
            ? name.substring(0, min(2, name.length)).toUpperCase()
            : "??";
        final color = Colors
            .primaries[(globalStartIndex + index) % Colors.primaries.length];
        return _buildMedicineListItem(
          med.medicine.medicineId,
          initials,
          name,
          med.notes,
          "today",
          color,
        );
      },
    );
  }

  Widget _buildMedicineListItem(
    String id,
    String initials,
    String name,
    String subtitle,
    String updated,
    Color color,
  ) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDAD7CD)),
      ),
      color: const Color(0xFFDAD7CD).withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/vault/$id'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Text(
                  initials,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Updated $updated",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Text(" • ", style: TextStyle(color: Colors.grey)),
                        Text(
                          "Active",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.squareArrowUpRight,
                  color: Color(0xFF3A5B43),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    final canGoBack = _currentPage > 0;
    final canGoForward = _currentPage < totalPages - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: canGoBack
              ? () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                )
              : null,
        ),
        Text(
          "${_currentPage + 1} / $totalPages",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: canGoForward
              ? () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildFamilyList() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: const Color(0xFFFDFDFD),
      child: Column(
        children: [
          _buildFamilyListItem("Charan Gutti", "today"),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildFamilyListItem("Jayasree Gutti", "28/09/2024"),
        ],
      ),
    );
  }

  Widget _buildFamilyListItem(String name, String updated) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFDAD7CD).withOpacity(0.2),
        child: const Icon(Icons.person, color: Colors.grey),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("last updated on $updated"),
      trailing: IconButton(
        icon: const Icon(Icons.open_in_new),
        onPressed: () {},
      ),
    );
  }
}
