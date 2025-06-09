import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Re-using the CustomStyledAccordion from the previous example for consistent styling
class CustomStyledAccordion extends StatefulWidget {
  final String medicineName; // Used as the header title
  final String medicineDetails; // Used as the header subtitle
  final Widget
  expandedContentWidget; // Now accepts a Widget for flexible content
  final bool initialExpanded;
  final Widget? leadingWidget;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? headerHeight;

  const CustomStyledAccordion({
    super.key,
    required this.medicineName,
    required this.medicineDetails,
    required this.expandedContentWidget, // Changed to Widget
    this.initialExpanded = false,
    this.leadingWidget,
    this.actionText,
    this.onActionPressed,
    this.headerHeight = 50.0,
  });

  @override
  State<CustomStyledAccordion> createState() => _CustomStyledAccordionState();
}

class _CustomStyledAccordionState extends State<CustomStyledAccordion>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _arrowRotationAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _arrowRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: SizedBox(
              height: widget.headerHeight,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    if (widget.leadingWidget != null)
                      Container(child: widget.leadingWidget!),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.medicineName,
                            style: const TextStyle(
                              fontSize: 14.0, // Slightly larger for clarity
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.medicineDetails,
                            style: const TextStyle(
                              fontSize: 10.0, // Slightly larger for clarity
                              height: 1.1,
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    RotationTransition(
                      turns: _arrowRotationAnimation,
                      child: const Icon(Icons.keyboard_arrow_down, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizeTransition(
            axisAlignment: 0.0,
            sizeFactor: _sizeAnimation,
            child: FadeTransition(
              opacity: _sizeAnimation,
              child: Offstage(
                offstage: !_isExpanded && _animationController.isDismissed,
                child: TickerMode(
                  enabled: _isExpanded || !_animationController.isDismissed,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
                    // Use the widget directly
                    child: widget.expandedContentWidget,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineDetailsScreen extends StatelessWidget {
  final String
  medicineId; // This can be used to fetch actual data in a real app

  const MedicineDetailsScreen({super.key, required this.medicineId});

  // Helper to build the content for the CustomStyledAccordion (elderly-friendly)
  Widget _buildElderlyFriendlyContent(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) {
        // Prepare TextSpans for RichText
        List<TextSpan> spans = [];
        final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*'); // Matches **text**

        // Handle nested bullet points (e.g., '  •  ')
        bool isNestedBullet = point.startsWith('  •  ');
        String processedPoint = isNestedBullet
            ? point.substring(3)
            : point; // Remove initial '  •  ' for parsing

        int lastMatchEnd = 0;
        for (RegExpMatch match in boldRegex.allMatches(processedPoint)) {
          // Add text before the bold part
          if (match.start > lastMatchEnd) {
            spans.add(
              TextSpan(
                text: processedPoint.substring(lastMatchEnd, match.start),
                style: const TextStyle(fontSize: 15.0, color: Colors.black87),
              ),
            );
          }
          // Add the bold part
          spans.add(
            TextSpan(
              text: match.group(1), // The captured group inside ** **
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
          lastMatchEnd = match.end;
        }
        // Add any remaining text after the last bold part
        if (lastMatchEnd < processedPoint.length) {
          spans.add(
            TextSpan(
              text: processedPoint.substring(lastMatchEnd),
              style: const TextStyle(fontSize: 15.0, color: Colors.black87),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            left: isNestedBullet ? 16.0 : 0.0, // Indent nested bullets
            bottom: isNestedBullet ? 4.0 : 6.0, // Spacing
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isNestedBullet) // Add bullet for top-level points only
                const Text(
                  '•  ',
                  style: TextStyle(
                    fontSize: 15.0,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: spans,
                    style: const TextStyle(
                      height: 1.4,
                    ), // Apply overall line height
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Function to show the "Ask AI" dialog
  void _showAskAiDialog(BuildContext context, String medicineName) {
    final TextEditingController _questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ask AI about $medicineName'),
          content: TextField(
            controller: _questionController,
            decoration: const InputDecoration(
              hintText: 'Type your question here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String question = _questionController.text.trim();
                if (question.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  // Simulate AI response
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'AI is thinking about: "$question"... Here\'s a simulated answer: "For detailed medical advice, please consult a healthcare professional."',
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                  // In a real app, you'd send 'question' to your AI model
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a question.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Ask AI'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration purposes,
    // in a real app, you'd fetch this using medicineId
    final String medicineName = "Paracetamol 500mg";
    final String brand = "Calpol (GSK)"; // Added manufacturer name
    final String genericName =
        "Acetaminophen"; // Added generic name for clarity
    final String dosage = "500 mg";
    final String frequency = "2 times a day";
    final String duration = "Until June 15, 2025";
    final String warnings =
        "Do not exceed recommended dose. Consult doctor if fever persists for more than 3 days or pain for more than 10 days. Avoid alcohol consumption as it may increase the risk of liver damage.";
    final String sideEffects =
        "Mild stomach upset, nausea, allergic reactions (rare). Seek immediate medical attention if you experience severe allergic reactions.";
    final String storage =
        "Store at room temperature (15-30°C), away from direct sunlight and moisture. Keep out of reach of children.";

    // AI generated content for generic questions, formatted for readability
    final List<Map<String, dynamic>> aiQuestions = [
      {
        'question': 'What is Paracetamol 500mg used for?',
        'answer_points': [
          '**Relieves mild to moderate pain** (like headaches, toothaches, period pain).',
          '**Reduces fever** (from colds or flu).',
          'It\'s a very common medicine for pain and fever.',
        ],
      },
      {
        'question': 'How will it improve my health (considering my metrics)?',
        'answer_points': [
          '**For your current condition (fever: 38.5°C, mild headache):**',
          'Your fever should go down within **30-60 minutes**.',
          'Your headache will ease, making you more comfortable.',
          'Your **liver function tests are normal**, so this dose is safe for you.',
          'Please **continue to check your temperature** regularly.',
        ],
      },
      {
        'question': 'Is it only recommended when prescribed?',
        'answer_points': [
          '**No, you can buy it without a prescription** from most pharmacies.',
          'However, **always follow the dosage instructions** very carefully.',
          'If your symptoms don\'t improve, or if they get worse, **please see a doctor**.',
        ],
      },
      {
        'question': 'What are the common side effects?',
        'answer_points': [
          'Side effects are usually mild:',
          '  •  Mild stomach upset or nausea.',
          '  •  Very rarely, allergic reactions like a skin rash or swelling.',
          '**Important:** If you experience any severe reactions (like difficulty breathing or severe swelling), **get medical help immediately**.',
        ],
      },
      {
        'question': 'Can I take this with other medications?',
        'answer_points': [
          '**Always ask your doctor or pharmacist first.**',
          '**Do NOT take it with other medicines that also contain paracetamol** to avoid an overdose.',
          'Be careful if you are taking **blood thinners** (like warfarin), as paracetamol can increase their effect.',
        ],
      },
      {
        'question': 'What if I miss a dose?',
        'answer_points': [
          'If you forget a dose, **take it as soon as you remember**.',
          'If it\'s almost time for your next dose, **just skip the missed one**.',
          '**Do NOT take a double dose** to make up for the one you missed.',
          'Just continue with your regular schedule.',
        ],
      },
      {
        'question': 'How should I store this medicine?',
        'answer_points': [
          'Store it at **room temperature** (between 15-30°C or 59-86°F).',
          'Keep it **away from direct sunlight, heat, and moisture**.',
          '**Do not store it in the bathroom**.',
          '**Keep it out of reach of children and pets**.',
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/vault'), // Navigate back to Vault
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ListView(
          children: [
            // --- Medicine Header Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                // Enhanced gradient for a modern look
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade300,
                    Colors.deepPurple.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ), // Slightly more rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade200.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.medical_services,
                    size: 40, // Larger icon
                    color: Colors.white, // White icon for contrast
                  ),
                  const SizedBox(width: 15), // Increased spacing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicineName,
                          style: const TextStyle(
                            fontSize: 22, // Larger font size for main name
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text for contrast
                          ),
                        ),
                        Text(
                          '($genericName)', // Display generic name
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70, // Slightly faded white
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15), // Space between header and details
            // --- Basic Details Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(
                  10,
                ), // Slightly rounded for consistency
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Brand:", brand),
                  const Divider(height: 15, thickness: 0.5),
                  _buildDetailRow("Dosage:", dosage),
                  const Divider(height: 15, thickness: 0.5),
                  _buildDetailRow("Frequency:", frequency),
                  const Divider(height: 15, thickness: 0.5),
                  _buildDetailRow("Duration:", duration),
                  const Divider(height: 15, thickness: 0.5),
                  _buildDetailRow("Warnings:", warnings, isWarning: true),
                  const Divider(height: 15, thickness: 0.5),
                  _buildDetailRow("Side Effects:", sideEffects),
                  const Divider(height: 15, thickness: 0.5),
                  _buildDetailRow("Storage:", storage),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- AI Insights Section ---
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'AI Insights & Common Questions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Using a theme color
                  ),
                ),
              ),
            ),
            ...aiQuestions.map(
              (q) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ), // Spacing between accordions
                child: CustomStyledAccordion(
                  medicineName: q['question']!,
                  medicineDetails: 'Tap to see answer', // Consistent subtitle
                  expandedContentWidget: _buildElderlyFriendlyContent(
                    q['answer_points'] as List<String>,
                  ), // Pass the Widget
                  leadingWidget: Container(
                    color: Colors.grey, // Consistent grey background for icon
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.smart_toy_outlined, // AI icon
                      color: Colors.blue.shade700,
                      size: 22,
                    ),
                  ),
                  headerHeight: 50.0, // Consistent header height
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- Ask AI More Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAskAiDialog(context, medicineName),
                icon: const Icon(Icons.help_outline),
                label: const Text('Ask AI More Questions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple.shade600, // A prominent color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 5, // Add a subtle shadow
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- Attachments Section ---
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Attachments',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Using a theme color
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentButton(
                    context,
                    Icons.insert_drive_file,
                    'View Prescription',
                    () {
                      print('Viewing prescription for $medicineId');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening prescription...'),
                        ),
                      );
                    },
                  ),
                  _buildAttachmentButton(
                    context,
                    Icons.camera_alt,
                    'View Box Image',
                    () {
                      print('Viewing box image for $medicineId');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening box image...')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Add some bottom padding
          ],
        ),
      ),
    );
  }

  // Helper widget to build a single detail row (Brand, Dosage, etc.)
  Widget _buildDetailRow(String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Slightly increased width for labels
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: isWarning ? Colors.red.shade700 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build attachment buttons
  Widget _buildAttachmentButton(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.blue.shade700,
      ), // Slightly darker blue
      label: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.blue.shade700),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
