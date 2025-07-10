import 'package:flutter/material.dart';

// Your provided CustomStyledAccordion widget, adapted for super-compact view
import 'package:app/data/presentation/widgets/alerts/custom_accordion.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertsPageStyled();
  }
}

class AlertsPageStyled extends StatefulWidget {
  const AlertsPageStyled({super.key});

  @override
  State<AlertsPageStyled> createState() => _AlertsPageStyledState();
}

class _AlertsPageStyledState extends State<AlertsPageStyled> {
  late final PageController _upcomingDosePageController;
  late final PageController _missedDosePageController;
  late final PageController _refillAlertPageController;
  late final PageController _expiryWarningsPageController;

  int _currentUpcomingDosePageIndex = 0;
  int _currentMissedDosePageIndex = 0;
  int _currentRefillAlertPageIndex = 0;
  int _currentExpiryWarningsPageIndex = 0;

  final int _alertsPerPage = 5;

  // --- Dummy Data (remains the same as before) ---
  final List<Map<String, String>> upcomingDoses = List.generate(
    12,
    (index) => {
      'medicine': 'Upcoming Med ${index + 1}',
      'details': 'Take with water after food. Check blood sugar before.',
      'time': '${7 + index % 5}:00 PM',
      'patient': ['Dad', 'Mom', 'Grandma', 'You', 'Child'][index % 5],
      'id': 'upc${index + 1}',
    },
  );

  final List<Map<String, String>> missedDoses = List.generate(
    7,
    (index) => {
      'medicine': 'Missed Med ${index + 1}',
      'details':
          'This dose was crucial for daily energy levels. Consider taking it now if not too late, or double up tomorrow.',
      'time': '${8 + index % 4}:00 AM',
      'patient': ['Grandpa', 'You', 'Mom'][index % 3],
      'id': 'miss${index + 1}',
    },
  );

  final List<Map<String, String>> refillAlerts = [
    {
      'medicine': 'Amoxicillin',
      'details': 'Only 2 doses left. Order now!',
      'expanded':
          'Stock is critically low. Expected delivery by 3 PM tomorrow if ordered immediately. Contact pharmacy directly.',
      'id': 'refill1',
    },
    {
      'medicine': 'Diabetic Strips',
      'details': 'Low stock. Reorder soon.',
      'expanded':
          'You have less than a week\'s supply of test strips. Ensure continuous monitoring by reordering before running out.',
      'id': 'refill2',
    },
    {
      'medicine': 'Painkillers',
      'details': 'Running low.',
      'expanded':
          'Only 15 pills remaining. Consider if you need a fresh prescription or over-the-counter purchase.',
      'id': 'refill3',
    },
    {
      'medicine': 'Thyroid Med',
      'details': 'Needs refill in 5 days',
      'expanded':
          'Your prescription for Thyroid Med will expire soon. Please contact your doctor for a new prescription.',
      'id': 'refill4',
    },
    {
      'medicine': 'Blood Pressure Med',
      'details': 'Reorder by next week',
      'expanded':
          'Ensure you have enough supply. Consult your doctor for a refill prescription.',
      'id': 'refill5',
    },
    {
      'medicine': 'Eye Drops',
      'details': 'Refill soon',
      'expanded':
          'You are running low on eye drops. Please reorder to avoid discomfort.',
      'id': 'refill6',
    },
  ];

  final List<Map<String, String>> expiryWarnings = [
    {
      'medicine': 'Ibuprofen',
      'details': 'expires in 3 days',
      'expanded':
          'Expired medication can be ineffective or harmful. Please dispose of properly and get a new pack.',
      'id': 'exp1',
    },
    {
      'medicine': 'Cetirizine',
      'details': 'expires in 7 days',
      'expanded':
          'Ensure you finish this pack before it expires. If not, consider discarding remaining tablets safely.',
      'id': 'exp2',
    },
    {
      'medicine': 'Cough Syrup',
      'details': 'expires in 10 days',
      'expanded':
          'The effectiveness may decrease after expiry. It\'s recommended to replace it before then.',
      'id': 'exp3',
    },
    {
      'medicine': 'Antibiotic Cream',
      'details': 'Expires in 2 weeks',
      'expanded':
          'Check the expiry date and replace if necessary. Avoid using expired topical creams.',
      'id': 'exp4',
    },
  ];

  @override
  void initState() {
    super.initState();
    _upcomingDosePageController = PageController();
    _missedDosePageController = PageController();
    _refillAlertPageController = PageController();
    _expiryWarningsPageController = PageController();
  }

  @override
  void dispose() {
    _upcomingDosePageController.dispose();
    _missedDosePageController.dispose();
    _refillAlertPageController.dispose();
    _expiryWarningsPageController.dispose();
    super.dispose();
  }

  int _calculateTotalPages(List<Map<String, String>> alerts) {
    if (alerts.isEmpty) return 0;
    return (alerts.length / _alertsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ListView(
          children: [
            const SizedBox(height: 12),

            // --- Upcoming Dose Category ---
            _buildAlertCategory(
              context: context,
              title: 'Upcoming Dose (${upcomingDoses.length} Alerts)',
              alerts: upcomingDoses,
              pageController: _upcomingDosePageController,
              currentPageIndex: _currentUpcomingDosePageIndex,
              onPageChanged: (index) {
                setState(() {
                  _currentUpcomingDosePageIndex = index;
                });
              },
              medicineNameBuilder: (alert) =>
                  '${alert['medicine']!} (${alert['patient']!})',
              medicineDetailsBuilder: (alert) => alert['time']!,
              leadingWidgetBuilder: (alert) =>
                  // Checkbox for upcoming dose to mark as taken
                  Container(
                    color: Colors.grey, // Background color for the icon
                    child: Checkbox(
                      value: false,
                      onChanged: (bool? value) {
                        // Handle checkbox change
                      },
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.green;
                        }
                        return Colors
                            .grey
                            .shade400; // Default color for unchecked
                      }),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              actionTextBuilder: (alert) => '➜ Tap to mark as Taken',
              expandedContentBuilder: (alert) => alert['details']!,
            ),

            const SizedBox(height: 12),

            // --- Missed Dose Category ---
            _buildAlertCategory(
              context: context,
              title: 'Missed Dose (${missedDoses.length} Alerts)',
              alerts: missedDoses,
              pageController: _missedDosePageController,
              currentPageIndex: _currentMissedDosePageIndex,
              onPageChanged: (index) {
                setState(() {
                  _currentMissedDosePageIndex = index;
                });
              },
              medicineNameBuilder: (alert) =>
                  '${alert['medicine']!} (${alert['patient']!})',
              medicineDetailsBuilder: (alert) => alert['time']!,
              leadingWidgetBuilder: (alert) => Container(
                color: Colors.grey, // Background color for the icon
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.watch_later_outlined, // Clock icon for missed dose
                  color: Colors.red.shade700,
                  size: 22,
                ),
              ),
              actionTextBuilder: (alert) => '➜ Reschedule | Mark as Skipped',
              expandedContentBuilder: (alert) => alert['details']!,
            ),

            const SizedBox(height: 12),

            // --- Refill Alert Category ---
            _buildAlertCategory(
              context: context,
              title: 'Refill Alert (${refillAlerts.length})',
              alerts: refillAlerts,
              pageController: _refillAlertPageController,
              currentPageIndex: _currentRefillAlertPageIndex,
              onPageChanged: (index) {
                setState(() {
                  _currentRefillAlertPageIndex = index;
                });
              },
              medicineNameBuilder: (alert) => alert['medicine']!,
              medicineDetailsBuilder: (alert) => alert['details']!,
              leadingWidgetBuilder: (alert) => Container(
                color: Colors.grey, // Background color for the icon
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.medication_liquid_outlined, // Icon for refill
                  color: Colors.orange.shade700,
                  size: 22,
                ),
              ),
              actionTextBuilder: (alert) => '➜ Order Now | Add Refill',
              expandedContentBuilder: (alert) => alert['expanded']!,
            ),

            const SizedBox(height: 12),

            // --- Expiry Warnings Category ---
            _buildAlertCategory(
              context: context,
              title: 'Expiry Warnings (${expiryWarnings.length})',
              alerts: expiryWarnings,
              pageController: _expiryWarningsPageController,
              currentPageIndex: _currentExpiryWarningsPageIndex,
              onPageChanged: (index) {
                setState(() {
                  _currentExpiryWarningsPageIndex = index;
                });
              },
              medicineNameBuilder: (alert) => alert['medicine']!,
              medicineDetailsBuilder: (alert) => alert['details']!,
              leadingWidgetBuilder: (alert) => Container(
                color: Colors.grey, // Background color for the icon
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.calendar_today_outlined, // Calendar icon for expiry
                  color: Colors.yellow.shade800,
                  size: 22,
                ),
              ),
              actionTextBuilder: (alert) => '➜ Details',
              expandedContentBuilder: (alert) => alert['expanded']!,
            ),

            const SizedBox(height: 12),

            // --- Add Custom Alert Button ---
            _buildAddItemButton(
              context,
              title: 'Add Custom Alert',
              icon: Icons.add_alert_outlined, // Specific icon for adding alert
              onTap: () {
                // Handle Add Custom Alert tap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCategory({
    required BuildContext context,
    required String title,
    required List<Map<String, String>> alerts,
    required PageController pageController,
    required int currentPageIndex,
    required ValueChanged<int> onPageChanged,
    required String Function(Map<String, String> alert) medicineNameBuilder,
    required String Function(Map<String, String> alert) medicineDetailsBuilder,
    required Widget Function(Map<String, String> alert) leadingWidgetBuilder,
    required String Function(Map<String, String> alert) actionTextBuilder,
    required String Function(Map<String, String> alert) expandedContentBuilder,
  }) {
    final int totalPages = _calculateTotalPages(alerts);

    // Adjusted height calculation based on _alertsPerPage and CustomStyledAccordion header height (50 + 2*2 margin = 54 effective height per item)
    final double basePageHeight = _alertsPerPage * 44.0;
    final double expansionBuffer = 80.0; // Increased buffer for expansion
    final double categoryHeight = basePageHeight + expansionBuffer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: categoryHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: totalPages,
            onPageChanged: onPageChanged,
            itemBuilder: (context, pageIndex) {
              final int startIndex = pageIndex * _alertsPerPage;
              final int endIndex = (startIndex + _alertsPerPage).clamp(
                0,
                alerts.length,
              );
              final List<Map<String, String>> currentAlerts = alerts.sublist(
                startIndex,
                endIndex,
              );

              return SingleChildScrollView(
                child: Column(
                  children: currentAlerts.map((alert) {
                    return CustomStyledAccordion(
                      medicineName: medicineNameBuilder(alert),
                      medicineDetails: medicineDetailsBuilder(alert),
                      expandedContent: expandedContentBuilder(alert),
                      leadingWidget: leadingWidgetBuilder(alert),
                      actionText: actionTextBuilder(alert),
                      onActionPressed: () {
                        // Handle action tap
                      },
                      headerHeight: 50.0, // Match the new standard height
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        _buildPageIndicatorWithArrows(
          pageController: pageController,
          currentPage: currentPageIndex,
          totalPages: totalPages,
        ),
      ],
    );
  }

  Widget _buildAddItemButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50, // Match the height of the medicine list items
      margin: const EdgeInsets.only(top: 2, bottom: 2), // Vertical spacing
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
        // Removed borderRadius to make it square
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5), // Match _buildList2 padding
          child: Row(
            children: [
              const SizedBox(width: 4), // Match _buildList2 spacing
              Container(
                decoration: const BoxDecoration(
                  // Removed borderRadius here as well
                  color: Colors
                      .grey, // Consistent grey color for the icon background
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    5,
                  ), // Match _buildList2 icon padding
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8), // Match _buildList2 spacing
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicatorWithArrows({
    required PageController pageController,
    required int currentPage,
    required int totalPages,
  }) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 0
                ? () {
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
            splashRadius: 22,
          ),
          Text(
            ' ${currentPage + 1} / $totalPages ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          IconButton(
            onPressed: currentPage < totalPages - 1
                ? () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_ios_outlined, size: 20),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}
