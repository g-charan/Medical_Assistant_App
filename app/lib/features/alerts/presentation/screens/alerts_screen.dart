import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// --- Data Models for the Alerts Screen ---
// Note: These models are defined here for a self-contained example.
// In a real app, they would be in their own files.

enum AlertPriority { high, medium, low }

class UpcomingAlert {
  final String id;
  final String medicineName;
  final String patientName;
  final String time;
  final String dosage;
  final String frequency;
  final AlertPriority priority;
  final IconData icon;

  UpcomingAlert({
    required this.id,
    required this.medicineName,
    required this.patientName,
    required this.time,
    required this.dosage,
    required this.frequency,
    required this.priority,
    required this.icon,
  });
}

// --- Main Alerts Screen Widget ---

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _selectedTabIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dynamic items per page based on screen size
  int get _itemsPerPage {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight > 800) return 4;
    if (screenHeight > 600) return 3;
    return 2;
  }

  // --- Dummy Data ---
  final List<UpcomingAlert> _upcomingDoses = [
    UpcomingAlert(
      id: '1',
      medicineName: 'Metformin 500mg',
      patientName: 'Jayasree Gutti',
      time: '2:00 PM',
      dosage: '500mg',
      frequency: 'Twice daily',
      priority: AlertPriority.high,
      icon: Icons.medication,
    ),
    UpcomingAlert(
      id: '2',
      medicineName: 'Lisinopril 10mg',
      patientName: 'Charan Gutti',
      time: '6:00 PM',
      dosage: '10mg',
      frequency: 'Once daily',
      priority: AlertPriority.medium,
      icon: Icons.medication,
    ),
    UpcomingAlert(
      id: '3',
      medicineName: 'Vitamin D3',
      patientName: 'Priya Gutti',
      time: '9:00 PM',
      dosage: '1000 IU',
      frequency: 'Once daily',
      priority: AlertPriority.low,
      icon: Icons.star,
    ),
    UpcomingAlert(
      id: '4',
      medicineName: 'Insulin Injection',
      patientName: 'Meera Gutti',
      time: '8:00 PM',
      dosage: '10 units',
      frequency: 'Before meals',
      priority: AlertPriority.high,
      icon: Icons.star,
    ),
    UpcomingAlert(
      id: '5',
      medicineName: 'Aspirin',
      patientName: 'Jayasree Gutti',
      time: '8:00 AM',
      dosage: '81mg',
      frequency: 'Once daily',
      priority: AlertPriority.low,
      icon: Icons.medication,
    ),
    UpcomingAlert(
      id: '6',
      medicineName: 'Atorvastatin',
      patientName: 'Charan Gutti',
      time: '9:00 PM',
      dosage: '20mg',
      frequency: 'Once daily',
      priority: AlertPriority.medium,
      icon: Icons.medication,
    ),
  ];

  // Placeholder lists for other tabs
  final List<UpcomingAlert> _missedDoses = [];
  final List<UpcomingAlert> _refills = [];
  final List<UpcomingAlert> _expiries = [];

  List<UpcomingAlert> get _currentList {
    switch (_selectedTabIndex) {
      case 0:
        return _upcomingDoses;
      case 1:
        return _missedDoses;
      case 2:
        return _refills;
      case 3:
        return _expiries;
      default:
        return _upcomingDoses;
    }
  }

  String get _currentTabName {
    switch (_selectedTabIndex) {
      case 0:
        return 'Upcoming Doses';
      case 1:
        return 'Missed Doses';
      case 2:
        return 'Refills';
      case 3:
        return 'Expiring';
      default:
        return 'Upcoming Doses';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              _buildHeader(constraints),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getHorizontalPadding(constraints),
                    vertical: 20.0,
                  ),
                  child: _buildFilterTabs(constraints),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getHorizontalPadding(constraints),
                  ),
                  child: _buildContentHeader(),
                ),
              ),
              _buildAlertList(constraints),
            ],
          );
        },
      ),
    );
  }

  // --- Responsive Helper Methods ---

  double _getHorizontalPadding(BoxConstraints constraints) {
    if (constraints.maxWidth > 1200) return 32.0;
    if (constraints.maxWidth > 800) return 24.0;
    return 16.0;
  }

  double _getCardMargin(BoxConstraints constraints) {
    if (constraints.maxWidth > 800) return 16.0;
    return 12.0;
  }

  // --- UI Builder Widgets ---

  Widget _buildHeader(BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;

    return SliverAppBar(
      backgroundColor: const Color(0xFF3A5B43),
      toolbarHeight: 120.0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.fromLTRB(
          _getHorizontalPadding(constraints) - 16, // Subtract default padding
          20,
          0,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Medicine Alerts",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: isWideScreen ? 24 : 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Stay on track with your medication schedule",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isWideScreen ? 15 : 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Chip(
            avatar: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
            label: Text(
              "${_upcomingDoses.length} active",
              style: TextStyle(color: Color(0xFF3A5B43)),
            ),
            backgroundColor: Colors.white.withOpacity(0.2),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide.none,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(BoxConstraints constraints) {
    final isWideScreen = constraints.maxWidth > 600;

    if (isWideScreen) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip(
            0,
            "Upcoming",
            Icons.notifications_active_outlined,
            constraints,
          ),
          _buildFilterChip(
            1,
            "Missed",
            Icons.watch_later_outlined,
            constraints,
          ),
          _buildFilterChip(
            2,
            "Refill",
            Icons.medication_liquid_outlined,
            constraints,
          ),
          _buildFilterChip(
            3,
            "Expiry",
            Icons.calendar_today_outlined,
            constraints,
          ),
        ],
      );
    } else {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          _buildFilterChip(
            0,
            "Upcoming",
            Icons.notifications_active_outlined,
            constraints,
          ),
          _buildFilterChip(
            1,
            "Missed",
            Icons.watch_later_outlined,
            constraints,
          ),
          _buildFilterChip(
            2,
            "Refill",
            Icons.medication_liquid_outlined,
            constraints,
          ),
          _buildFilterChip(
            3,
            "Expiry",
            Icons.calendar_today_outlined,
            constraints,
          ),
        ],
      );
    }
  }

  Widget _buildFilterChip(
    int index,
    String label,
    IconData icon,
    BoxConstraints constraints,
  ) {
    final isSelected = _selectedTabIndex == index;
    final isCompact = constraints.maxWidth < 400;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _currentPage = 0;
          if (_pageController.hasClients) {
            _pageController.jumpToPage(0);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 8 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A5B43) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              size: 18,
            ),
            SizedBox(width: isCompact ? 4 : 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: isCompact ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentTabName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_currentList.length} medications scheduled",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          if (_currentList.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3A5B43),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "${_currentList.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertList(BoxConstraints constraints) {
    if (_currentList.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No alerts in this category",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalPages = (_currentList.length / _itemsPerPage).ceil();

    return SliverToBoxAdapter(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          children: [
            Expanded(
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
                    _currentList.length,
                  );
                  final pageItems = _currentList.sublist(startIndex, endIndex);

                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getHorizontalPadding(constraints),
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 300),
                          child: SlideAnimation(
                            verticalOffset: 30.0,
                            child: FadeInAnimation(
                              child: _AlertCard(
                                alert: pageItems[index],
                                constraints: constraints,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            if (totalPages > 1) _buildPaginationControls(totalPages),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  )
                : null,
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: _currentPage > 0
                  ? const Color(0xFF3A5B43)
                  : Colors.grey.shade400,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_currentPage + 1} of $totalPages",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          IconButton(
            onPressed: _currentPage < totalPages - 1
                ? () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  )
                : null,
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: _currentPage < totalPages - 1
                  ? const Color(0xFF3A5B43)
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Individual Alert Card Widget ---

class _AlertCard extends StatelessWidget {
  final UpcomingAlert alert;
  final BoxConstraints constraints;

  const _AlertCard({required this.alert, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = constraints.maxWidth > 600;
    final margin = constraints.maxWidth > 800 ? 16.0 : 12.0;

    return Card(
      margin: EdgeInsets.only(bottom: margin),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(isWideScreen),
            SizedBox(height: isWideScreen ? 16 : 12),
            _buildDosageInfo(isWideScreen),
            SizedBox(height: isWideScreen ? 20 : 16),
            _buildActionButtons(context, isWideScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(bool isWideScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMedicineIcon(),
        SizedBox(width: isWideScreen ? 16 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.medicineName,
                style: TextStyle(
                  fontSize: isWideScreen ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _buildInfoChip(
                    Icons.person_outline,
                    alert.patientName,
                    isWideScreen,
                  ),
                  _buildInfoChip(Icons.access_time, alert.time, isWideScreen),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildPriorityChip(alert.priority, isWideScreen),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, bool isWideScreen) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isWideScreen ? 16 : 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isWideScreen ? 14 : 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF3A5B43).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(alert.icon, color: const Color(0xFF3A5B43), size: 24),
    );
  }

  Widget _buildPriorityChip(AlertPriority priority, bool isWideScreen) {
    Color color;
    String text;
    switch (priority) {
      case AlertPriority.high:
        color = Colors.red.shade600;
        text = "HIGH";
        break;
      case AlertPriority.medium:
        color = Colors.orange.shade600;
        text = "MEDIUM";
        break;
      case AlertPriority.low:
        color = Colors.green.shade600;
        text = "LOW";
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? 10 : 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: isWideScreen ? 11 : 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDosageInfo(bool isWideScreen) {
    return Container(
      padding: EdgeInsets.all(isWideScreen ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDetailItem("Dosage", alert.dosage, isWideScreen),
          ),
          SizedBox(width: isWideScreen ? 24 : 16),
          Expanded(
            child: _buildDetailItem("Frequency", alert.frequency, isWideScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: isWideScreen ? 13 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isWideScreen ? 15 : 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isWideScreen) {
    if (constraints.maxWidth < 600) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Details"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Reschedule"),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check, size: 18),
              label: const Text("Mark as Taken"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A5B43),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        TextButton(onPressed: () {}, child: const Text("View Details")),
        const Spacer(),
        OutlinedButton(
          onPressed: () {},
          child: const Text("Reschedule"),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check, size: 18),
          label: const Text("Mark Taken"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A5B43),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
