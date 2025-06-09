import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VaultMedicines extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Medicines"),

        SizedBox(
          height: 540, // Keep your SizedBox for PageView height
          child: PageView(
            controller: _pageController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildList2(Colors.grey, "Something 11", context),
                  _buildList2(Colors.grey, "Something 12", context),
                  _buildList2(Colors.grey, "Something 13", context),
                  _buildList2(Colors.grey, "Something 14", context),
                ],
              ),
            ],
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
        ),

        Row(
          spacing: 1,
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
                Text("Vitamin d3 1100"),
                Text(
                  "Should be taken after food",
                  style: TextStyle(fontSize: 11, height: 1),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_outward_rounded),
            onPressed: () {
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
