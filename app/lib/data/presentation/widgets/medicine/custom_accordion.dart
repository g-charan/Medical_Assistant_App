import 'package:flutter/material.dart';

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
