import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app/data/models/medicines.dart';
//Assuming your model is here
import 'package:app/data/presentation/providers/family.providers.dart';
import 'package:app/data/presentation/providers/medicines.provider.dart';
import 'package:app/data/presentation/widgets/utils/app_refresher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // --- Existing OCR and State Management Logic (Preserved) ---
  Future<void> _scanWithOCR() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    TextRecognizer? textRecognizer;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image == null || !mounted) return;

      final File imageFile = File(image.path);
      if (!await imageFile.exists()) {
        _showMessage('Error: Image file not found', isError: true);
        return;
      }

      _showMessage('📷 Processing image...', showProgress: true);
      final inputImage = InputImage.fromFilePath(image.path);
      textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      if (!mounted) return;
      await _handleOCRResult(recognizedText);
      await imageFile.delete();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('--- OCR ERROR --- \n$e\n$stackTrace\n----------------');
      }
      if (mounted) {
        _showMessage('Error processing image: ${e.toString()}', isError: true);
      }
    } finally {
      await textRecognizer?.close();
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleOCRResult(RecognizedText recognizedText) async {
    final String cleanText = recognizedText.text.trim();
    if (cleanText.isEmpty) {
      _showMessage(
        '📄 No text detected. Try:\n'
        '• Better lighting\n'
        '• Hold camera steady\n'
        '• Get closer to text',
        duration: 5,
      );
      return;
    }
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
              _processMedicineText(text);
            },
            child: const Text('Add Medicine'),
          ),
        ],
      ),
    );
  }

  void _processMedicineText(String text) {
    if (kDebugMode) print('Processing medicine text: $text');
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
          if (_pageController.hasClients) {
            _pageController.jumpToPage(0);
          }
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
                data: (List<Medicines> medicines) {
                  return _buildPaginatedContent(medicines);
                },
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
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
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
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.swap_vert),
              label: const Text("Sort"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
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
    // FIX: Use an AnimatedBuilder to dynamically calculate the height of the PageView
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              // Calculate height based on item size and count for the CURRENT page
              height:
                  (88.0 *
                      min(
                        _itemsPerPage,
                        medicines.length - (_currentPage * _itemsPerPage),
                      )) +
                  (12.0 *
                      (min(
                            _itemsPerPage,
                            medicines.length - (_currentPage * _itemsPerPage),
                          ) -
                          1)),
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
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
      },
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
          med.id,
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
    // FIX: Removed fixed height SizedBox and let the Card manage its own size.
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: const Color(0xFFFDFDFD),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/vault/$id'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
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
              // FIX: Wrapped the Column in an Expanded widget to prevent overflow.
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
                icon: const Icon(Icons.refresh, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    final bool canGoBack = _currentPage > 0;
    final bool canGoForward = _currentPage < totalPages - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: canGoBack
              ? () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              : null,
        ),
        Text(
          "${_currentPage + 1} / $totalPages",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: canGoForward
              ? () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
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
        backgroundColor: Colors.grey.shade200,
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
