import 'package:flutter/material.dart';

class CustomStyledAccordion extends StatefulWidget {
  final String medicineName;
  final String medicineDetails;
  final String expandedContent;
  final bool initialExpanded;
  final Widget? leadingWidget;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? headerHeight;

  const CustomStyledAccordion({
    super.key,
    required this.medicineName,
    required this.medicineDetails,
    required this.expandedContent,
    this.initialExpanded = false,
    this.leadingWidget,
    this.actionText,
    this.onActionPressed,
    this.headerHeight = 50.0, // Set to 50.0 to match the _buildList2 height
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
      // Match the _buildList2 container style: light grey background with horizontal borders, no rounded corners.
      margin: const EdgeInsets.only(top: 2, bottom: 2), // Vertical spacing
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
        // Removed borderRadius to make it square
      ),
      child: Column(
        children: [
          // Header Section: This is the part that is always visible
          InkWell(
            onTap: _toggleExpanded,
            child: SizedBox(
              height:
                  widget.headerHeight, // Use dynamic header height (now 50.0)
              child: Padding(
                padding: const EdgeInsets.all(5), // Match _buildList2 padding
                child: Row(
                  children: [
                    const SizedBox(width: 4), // Match _buildList2 spacing
                    // Replaced static icon with leadingWidget
                    if (widget.leadingWidget != null)
                      Container(
                        decoration: const BoxDecoration(
                          // Removed borderRadius
                          // Consider if you want this inner container to have its own color or if the icon color is enough
                        ),
                        child: widget.leadingWidget!,
                      ),
                    const SizedBox(width: 8), // Match _buildList2 spacing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.medicineName,
                            style: const TextStyle(
                              fontSize: 13.0, // Retained from your version
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.medicineDetails,
                            style: const TextStyle(
                              fontSize: 9.5, // Retained from your version
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
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20, // Retained from your version
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Animated Content Section: This expands/collapses
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.expandedContent,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black87,
                          ),
                        ),
                        if (widget.actionText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: widget.onActionPressed,
                              child: Text(
                                widget.actionText!,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.blue,
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
