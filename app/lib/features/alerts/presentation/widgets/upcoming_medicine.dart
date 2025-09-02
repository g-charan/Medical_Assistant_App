import 'package:flutter/material.dart';

class UpcomingMedicine extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upcoming Medicine"),
        CustomStyledAccordion(
          medicineName: "Vitamin D3 1100",
          medicineDetails: "Should be taken after food",
          expandedContent:
              "Vitamin D3 is essential for bone health and immune function. It helps your body absorb calcium and phosphorus. Take it consistently as prescribed for best results.",
        ),
      ],
    );
  }
}

class CustomStyledAccordion extends StatefulWidget {
  final String medicineName;
  final String medicineDetails;
  final String expandedContent;
  final bool initialExpanded;

  const CustomStyledAccordion({
    super.key,
    required this.medicineName,
    required this.medicineDetails,
    required this.expandedContent,
    this.initialExpanded = false,
  });

  @override
  State<CustomStyledAccordion> createState() => _CustomStyledAccordionState();
}

class _CustomStyledAccordionState extends State<CustomStyledAccordion>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController; // Renamed for clarity
  late Animation<double> _arrowRotationAnimation; // Renamed for clarity
  late Animation<double> _sizeAnimation; // New animation for size transition

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Consistent duration
    );

    // Animation for the arrow rotation
    _arrowRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animation for the size transition (0.0 to 1.0 for collapsed to expanded)
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Set initial state for the controller
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
        _animationController.forward(); // Play animation forward (expand)
      } else {
        _animationController.reverse(); // Play animation backward (collapse)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Column(
        children: [
          // Header Section (remains mostly the same)
          InkWell(
            onTap: _toggleExpanded,
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.grey.shade400,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.medication),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.medicineName),
                          Text(
                            widget.medicineDetails,
                            style: const TextStyle(fontSize: 11, height: 1),
                          ),
                        ],
                      ),
                    ),
                    RotationTransition(
                      turns: _arrowRotationAnimation,
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
          // --- Animated Content Section (Improved) ---
          // Use SizeTransition for a smooth slide-down effect
          SizeTransition(
            axisAlignment: 0.0, // Aligns content to the top during transition
            sizeFactor: _sizeAnimation, // Controls the size based on animation
            child: FadeTransition(
              // Add FadeTransition for a smoother appearance/disappearance
              opacity: _sizeAnimation, // Fades in/out with the size transition
              child: Offstage(
                // Ensures content doesn't affect layout when fully hidden
                offstage:
                    !_isExpanded &&
                    _sizeAnimation
                        .isDismissed, // Only offstage when fully collapsed
                child: TickerMode(
                  // Ensures child animations only run when visible
                  enabled:
                      _isExpanded ||
                      !_sizeAnimation
                          .isDismissed, // Enable tickers if expanded or animating
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Text(
                      widget.expandedContent,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
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
