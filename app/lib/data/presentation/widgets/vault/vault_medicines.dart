import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import this

class VaultMedicines extends StatefulWidget {
  const VaultMedicines({super.key}); // Added const constructor

  @override
  _VaultMedicinesState createState() => _VaultMedicinesState();
}

class _VaultMedicinesState extends State<VaultMedicines> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final int _numPages = 2; // Two pages based on your Column structure

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Helper method to build a page with staggered animations
  Widget _buildStaggeredMedicinePage(List<Widget> medicineItems) {
    return AnimationLimiter(
      // Wrap each page content with AnimationLimiter
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: medicineItems, // Pass the list of _buildList2 items
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the content for each page
    final List<Widget> page1Content = [
      _buildList2(Colors.grey, "Something 1", context),
      _buildList2(Colors.grey, "Something 2", context),
      _buildList2(Colors.grey, "Something 3", context),
      _buildList2(Colors.grey, "Something 4", context),
      _buildList2(Colors.grey, "Something 5", context),
      _buildList2(Colors.grey, "Something 6", context),
      _buildList2(Colors.grey, "Something 7", context),
      _buildList2(Colors.grey, "Something 8", context),
      _buildList2(Colors.grey, "Something 9", context),
      _buildList2(Colors.grey, "Something 10", context),
    ];

    final List<Widget> page2Content = [
      _buildList2(Colors.grey, "Something 11", context),
      _buildList2(Colors.grey, "Something 12", context),
      _buildList2(Colors.grey, "Something 13", context),
      _buildList2(Colors.grey, "Something 14", context),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Medicines",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ), // Added style for consistency

        const SizedBox(height: 10), // Added some spacing

        SizedBox(
          height: 540, // Keep your SizedBox for PageView height
          child: PageView(
            controller: _pageController,
            children: [
              // Use the helper method to build each page with animations
              _buildStaggeredMedicinePage(page1Content),
              _buildStaggeredMedicinePage(page2Content),
            ],
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 10), // Spacing below PageView

        Row(
          spacing:
              1, // This property doesn't exist on Row. Perhaps you meant a SizedBox for spacing?
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _currentPageIndex > 0
                  ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  : null, // Disable if on the first page
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
            Text(
              " ${_currentPageIndex + 1} / $_numPages ",
              style: const TextStyle(fontSize: 16), // Added style
            ), // Display current page / total pages
            IconButton(
              onPressed: _currentPageIndex < _numPages - 1
                  ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  : null, // Disable if on the last page
              icon: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildList2(Color color, String text, BuildContext context) {
  // It's good practice to make this widget a StatelessWidget if it doesn't manage its own state
  // This allows Flutter to optimize rendering.
  return Container(
    height: 50,
    margin: const EdgeInsets.only(top: 2, bottom: 2),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.symmetric(
        horizontal: BorderSide(color: Colors.grey.shade400),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.grey,
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
                const Text("Vitamin d3 1100"), // Made Text const
                const Text(
                  // Made Text const
                  "Should be taken after food",
                  style: TextStyle(fontSize: 11, height: 1),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_outward_rounded), // Made Icon const
            onPressed: () {
              // Ensure your GoRouter setup has a route for "/vault/2"
              context.go(
                "/vault/2",
              ); // Navigate to details screen with medicine name
            },
          ),
        ],
      ),
    ),
  );
}
