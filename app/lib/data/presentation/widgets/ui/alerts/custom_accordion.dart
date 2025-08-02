import 'package:flutter/material.dart';

class CustomStyledAccordion extends StatefulWidget {
  // Public properties of the accordion.
  final String medicineName; // The main title of the accordion header
  final String medicineDetails; // The subtitle or brief detail in the header
  final String
  expandedContent; // The content visible when the accordion is open
  final bool initialExpanded; // Whether the accordion should be open initially
  final Widget?
  leadingWidget; // Optional widget to display at the start of the header (e.g., an icon or checkbox)
  final String?
  actionText; // Optional text for an actionable button at the bottom of the expanded content
  final VoidCallback?
  onActionPressed; // Callback for when the action button is pressed
  final double? headerHeight; // Height of the accordion header

  const CustomStyledAccordion({
    super.key,
    required this.medicineName,
    required this.medicineDetails,
    required this.expandedContent,
    this.initialExpanded = false,
    this.leadingWidget,
    this.actionText,
    this.onActionPressed,
    this.headerHeight =
        50.0, // Default header height, matching common list item heights
  });

  @override
  State<CustomStyledAccordion> createState() => _CustomStyledAccordionState();
}

class _CustomStyledAccordionState extends State<CustomStyledAccordion>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _arrowRotationAnimation;
  late Animation<double>
  _sizeAnimation; // Controls the height of the expanded content
  late Animation<double>
  _fadeAnimation; // Controls the fade-in/out of the expanded content

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Smooth animation duration
    );

    // Animates the rotation of the arrow icon (0 degrees to 180 degrees)
    _arrowRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animates the size (height) of the content
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Animates the opacity (fade) of the content for a smoother transition
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // If initially expanded, set the animation to its end state
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Toggles the expanded state and runs the animation.
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
      // Consistent styling for the entire accordion card
      margin: const EdgeInsets.symmetric(
        vertical: 2,
      ), // Vertical spacing between accordions
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey.shade400,
            width: 1.0,
          ), // Horizontal borders
        ),
      ),
      child: Column(
        children: [
          // Header Section: Always visible and tappable to toggle expansion
          InkWell(
            onTap: _toggleExpanded,
            // Ensure the entire header area is tappable
            customBorder: Border.all(
              color: Colors.transparent,
            ), // No visible border on tap
            child: SizedBox(
              height: widget.headerHeight, // Use the provided header height
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ), // Padding inside the header
                child: Row(
                  children: [
                    // Optional leading widget (e.g., checkbox, icon)
                    if (widget.leadingWidget != null) ...[
                      widget.leadingWidget!,
                      const SizedBox(width: 8), // Spacing after leading widget
                    ],
                    // Expanded column for medicine name and details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Vertically center content
                        children: [
                          Text(
                            widget.medicineName,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.medicineDetails,
                            style: const TextStyle(
                              fontSize: 9.5,
                              height:
                                  1.1, // Adjust line height for better readability
                              color: Colors.black54,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Arrow icon that rotates based on expansion state
                    RotationTransition(
                      turns: _arrowRotationAnimation,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.black54, // Consistent icon color
                      ),
                    ),
                    const SizedBox(width: 4), // Small trailing space
                  ],
                ),
              ),
            ),
          ),
          // Animated Content Section: Expands/collapses with animation
          SizeTransition(
            axisAlignment: 0.0, // Align size transition from top
            sizeFactor: _sizeAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Offstage(
                // Use Offstage to prevent content from being built when fully collapsed
                // for performance, but only when animation is dismissed.
                offstage: !_isExpanded && _animationController.isDismissed,
                child: TickerMode(
                  // Ensure children widgets (like text) only tick when visible/animating
                  enabled: _isExpanded || !_animationController.isDismissed,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16.0,
                      4.0,
                      16.0,
                      12.0,
                    ), // Padding for expanded content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.expandedContent,
                          textAlign: TextAlign
                              .justify, // Justify text for better readability
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black87,
                          ),
                        ),
                        // Optional action button
                        if (widget.actionText != null &&
                            widget.onActionPressed != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: widget.onActionPressed,
                              behavior: HitTestBehavior
                                  .opaque, // Ensures the whole padding area is tappable
                              child: Text(
                                widget.actionText!,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Colors
                                      .blue, // Action text in a prominent color
                                  fontWeight: FontWeight
                                      .w600, // Make action text slightly bolder
                                ),
                              ),
                            ),
                          ),
                      ],
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
