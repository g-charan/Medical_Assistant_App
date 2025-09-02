import 'package:app/features/alerts/presentation/widgets/custom_accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// Import your new data models
import 'package:app/data/models/alert_models.dart'; // Make sure this path is correct!
// Import your CustomAccordion (assuming its path is correct)

// --- MAIN ALERTS SCREEN ---
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

  // --- CORRECT: Strongly Typed Dummy Data ---
  final List<UpcomingDoseAlert> upcomingDoses = List.generate(
    12,
    (index) => UpcomingDoseAlert(
      // <--- Create an instance of UpcomingDoseAlert
      id: 'upc${index + 1}',
      medicineName: 'Upcoming Med ${index + 1}',
      patientName: ['Dad', 'Mom', 'Grandma', 'You', 'Child'][index % 5],
      time: '${7 + index % 5}:00 PM',
      details:
          'Take with water after food. Check blood sugar before. This is an extended detail for Upcoming Med ${index + 1}.',
    ),
  );

  final List<MissedDoseAlert> missedDoses = List.generate(
    7,
    (index) => MissedDoseAlert(
      // <--- Create an instance of MissedDoseAlert
      id: 'miss${index + 1}',
      medicineName: 'Missed Med ${index + 1}',
      patientName: ['Grandpa', 'You', 'Mom'][index % 3],
      time: '${8 + index % 4}:00 AM',
      details:
          'This dose was crucial for daily energy levels. Consider taking it now if not too late, or double up tomorrow. If you are unsure, please consult your doctor or pharmacist. This is an extended detail for Missed Med ${index + 1}.',
    ),
  );

  final List<RefillAlert> refillAlerts = const [
    RefillAlert(
      // <--- Create an instance of RefillAlert
      id: 'refill1',
      medicineName: 'Amoxicillin',
      shortDetail: 'Only 2 doses left. Order now!',
      details:
          'Stock is critically low. Expected delivery by 3 PM tomorrow if ordered immediately. Contact pharmacy directly for urgent refills. Check your prescription for renewal options.',
    ),
    RefillAlert(
      id: 'refill2',
      medicineName: 'Diabetic Strips',
      shortDetail: 'Low stock. Reorder soon.',
      details:
          'You have less than a week\'s supply of test strips. Ensure continuous monitoring by reordering before running out. Check with your insurance provider for coverage.',
    ),
    RefillAlert(
      id: 'refill3',
      medicineName: 'Painkillers',
      shortDetail: 'Running low.',
      details:
          'Only 15 pills remaining. Consider if you need a fresh prescription or over-the-counter purchase. Do not exceed the recommended daily dose.',
    ),
    RefillAlert(
      id: 'refill4',
      medicineName: 'Thyroid Med',
      shortDetail: 'Needs refill in 5 days',
      details:
          'Your prescription for Thyroid Med will expire soon. Please contact your doctor for a new prescription. It is vital to maintain consistent dosage for thyroid conditions.',
    ),
    RefillAlert(
      id: 'refill5',
      medicineName: 'Blood Pressure Med',
      shortDetail: 'Reorder by next week',
      details:
          'Ensure you have enough supply. Consult your doctor for a refill prescription. Do not stop taking your blood pressure medication without medical advice.',
    ),
    RefillAlert(
      id: 'refill6',
      medicineName: 'Eye Drops',
      shortDetail: 'Refill soon',
      details:
          'You are running low on eye drops. Please reorder to avoid discomfort. Check the type of eye drops required with your optometrist.',
    ),
  ];

  final List<ExpiryWarningAlert> expiryWarnings = const [
    ExpiryWarningAlert(
      // <--- Create an instance of ExpiryWarningAlert
      id: 'exp1',
      medicineName: 'Ibuprofen',
      expiresIn: 'expires in 3 days',
      details:
          'Expired medication can be ineffective or harmful. Please dispose of properly at a designated medical waste facility and get a new pack. Do not flush down the toilet.',
    ),
    ExpiryWarningAlert(
      id: 'exp2',
      medicineName: 'Cetirizine',
      expiresIn: 'expires in 7 days',
      details:
          'Ensure you finish this pack before it expires. If not, consider discarding remaining tablets safely. Check for any current allergies before continuing use.',
    ),
    ExpiryWarningAlert(
      id: 'exp3',
      medicineName: 'Cough Syrup',
      expiresIn: 'expires in 10 days',
      details:
          'The effectiveness may decrease after expiry. It\'s recommended to replace it before then. Store in a cool, dry place away from direct sunlight.',
    ),
    ExpiryWarningAlert(
      id: 'exp4',
      medicineName: 'Antibiotic Cream',
      expiresIn: 'Expires in 2 weeks',
      details:
          'Check the expiry date and replace if necessary. Avoid using expired topical creams as they may lose potency or cause skin irritation.',
    ),
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

  // int _calculateTotalPages<T>(List<T> alerts) {
  //   if (alerts.isEmpty) return 0;
  //   return (alerts.length / _alertsPerPage).ceil();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            delay: const Duration(milliseconds: 100),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              const SizedBox(height: 8),

              // --- Upcoming Dose Category ---
              _AlertCategoryCard(
                title: 'Upcoming Dose (${upcomingDoses.length} Alerts)',
                alerts:
                    upcomingDoses, // Now this will be List<UpcomingDoseAlert>
                pageController: _upcomingDosePageController,
                currentPageIndex: _currentUpcomingDosePageIndex,
                alertsPerPage: _alertsPerPage,
                onPageChanged: (index) {
                  setState(() {
                    _currentUpcomingDosePageIndex = index;
                  });
                },
                itemBuilder: (context, alert) {
                  final UpcomingDoseAlert typedAlert =
                      alert as UpcomingDoseAlert;
                  return CustomStyledAccordion(
                    medicineName:
                        '${typedAlert.medicineName} (${typedAlert.patientName})',
                    medicineDetails: typedAlert.time,
                    expandedContent: typedAlert.details,
                    leadingWidget: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Checkbox(
                        value: false,
                        onChanged: (bool? value) {
                          // TODO: Implement logic to mark dose as taken
                        },
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.green.shade600;
                          }
                          return Colors.grey.shade400;
                        }),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    actionText: 'Tap to mark as Taken',
                    onActionPressed: () {
                      // TODO: Implement action for Upcoming Dose
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- Missed Dose Category ---
              _AlertCategoryCard(
                title: 'Missed Dose (${missedDoses.length} Alerts)',
                alerts: missedDoses, // Now this will be List<MissedDoseAlert>
                pageController: _missedDosePageController,
                currentPageIndex: _currentMissedDosePageIndex,
                alertsPerPage: _alertsPerPage,
                onPageChanged: (index) {
                  setState(() {
                    _currentMissedDosePageIndex = index;
                  });
                },
                itemBuilder: (context, alert) {
                  final MissedDoseAlert typedAlert = alert as MissedDoseAlert;
                  return CustomStyledAccordion(
                    medicineName:
                        '${typedAlert.medicineName} (${typedAlert.patientName})',
                    medicineDetails: typedAlert.time,
                    expandedContent: typedAlert.details,
                    leadingWidget: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.watch_later_outlined,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                    ),
                    actionText: 'Reschedule | Mark as Skipped',
                    onActionPressed: () {
                      // TODO: Implement action for Missed Dose
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- Refill Alert Category ---
              _AlertCategoryCard(
                title: 'Refill Alert (${refillAlerts.length})',
                alerts: refillAlerts, // Now this will be List<RefillAlert>
                pageController: _refillAlertPageController,
                currentPageIndex: _currentRefillAlertPageIndex,
                alertsPerPage: _alertsPerPage,
                onPageChanged: (index) {
                  setState(() {
                    _currentRefillAlertPageIndex = index;
                  });
                },
                itemBuilder: (context, alert) {
                  final RefillAlert typedAlert = alert as RefillAlert;
                  return CustomStyledAccordion(
                    medicineName: typedAlert.medicineName,
                    medicineDetails: typedAlert.shortDetail,
                    expandedContent: typedAlert.details,
                    leadingWidget: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.medication_liquid_outlined,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                    ),
                    actionText: 'Order Now | Add Refill',
                    onActionPressed: () {
                      // TODO: Implement action for Refill Alert
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- Expiry Warnings Category ---
              _AlertCategoryCard(
                title: 'Expiry Warnings (${expiryWarnings.length})',
                alerts:
                    expiryWarnings, // Now this will be List<ExpiryWarningAlert>
                pageController: _expiryWarningsPageController,
                currentPageIndex: _currentExpiryWarningsPageIndex,
                alertsPerPage: _alertsPerPage,
                onPageChanged: (index) {
                  setState(() {
                    _currentExpiryWarningsPageIndex = index;
                  });
                },
                itemBuilder: (context, alert) {
                  final ExpiryWarningAlert typedAlert =
                      alert as ExpiryWarningAlert;
                  return CustomStyledAccordion(
                    medicineName: typedAlert.medicineName,
                    medicineDetails: typedAlert.expiresIn,
                    expandedContent: typedAlert.details,
                    leadingWidget: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.yellow.shade800,
                        size: 20,
                      ),
                    ),
                    actionText: 'View Details',
                    onActionPressed: () {
                      // TODO: Implement action for Expiry Warning
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // --- Add Custom Alert Button ---
              _buildAddItemButton(
                context,
                title: 'Add Custom Alert',
                icon: Icons.add_alert_outlined,
                onTap: () {
                  // TODO: Implement Add Custom Alert tap
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddItemButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCategoryCard<T extends AppAlert> extends StatelessWidget {
  final String title;
  final List<T> alerts;
  final PageController pageController;
  final int currentPageIndex;
  final int alertsPerPage;
  final ValueChanged<int> onPageChanged;
  final Widget Function(BuildContext context, T alert) itemBuilder;

  const _AlertCategoryCard({
    super.key,
    required this.title,
    required this.alerts,
    required this.pageController,
    required this.currentPageIndex,
    required this.alertsPerPage,
    required this.onPageChanged,
    required this.itemBuilder,
  });

  int get _totalPages {
    if (alerts.isEmpty) return 0;
    return (alerts.length / alertsPerPage).ceil();
  }

  final double _pageViewHeight =
      320.0; // This value is an estimation and might need fine-tuning

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: _pageViewHeight,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: _totalPages,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, pageIndex) {
                    final int startIndex = pageIndex * alertsPerPage;
                    final int endIndex = (startIndex + alertsPerPage).clamp(
                      0,
                      alerts.length,
                    );
                    final List<T> currentAlerts = alerts.sublist(
                      startIndex,
                      endIndex,
                    );

                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: currentAlerts.map((alert) {
                          return itemBuilder(context, alert);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              _buildPageIndicatorWithArrows(
                pageController: pageController,
                currentPage: currentPageIndex,
                totalPages: _totalPages,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicatorWithArrows({
    required PageController pageController,
    required int currentPage,
    required int totalPages,
  }) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: currentPage > 0 ? Colors.black54 : Colors.grey.shade400,
            ),
            splashRadius: 20,
          ),
          Text(
            '${currentPage + 1} / $totalPages',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
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
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: currentPage < totalPages - 1
                  ? Colors.black54
                  : Colors.grey.shade400,
            ),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
