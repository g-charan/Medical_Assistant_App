import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Assuming GoRouter for navigation
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import for animations

class FamilyDetailsScreen extends StatefulWidget {
  final String
  familyMemberId; // To identify which family member's details to show

  const FamilyDetailsScreen({Key? key, required this.familyMemberId})
    : super(key: key);

  @override
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  // Page Controllers for horizontal PageViews
  final PageController _healthMetricsPageController = PageController();
  final PageController _medicinesVaultPageController = PageController();

  // Current page indices for indicators
  int _currentHealthMetricPageIndex = 0;
  int _currentMedicineVaultPageIndex = 0;

  // Dummy data for a family member
  String familyMemberName = "Mom";
  String age = "56";
  String conditions = "Diabetic, Hypertension";

  // --- Dummy Data for Health Metrics ---
  final List<Map<String, String>> healthLogs = [
    {'date': 'Jun 7', 'type': 'BP', 'value': '130/85'},
    {'date': 'Jun 6', 'type': 'Sugar', 'value': '145 mg/dL (Fasting)'},
    {'date': 'Jun 1', 'type': 'Weight', 'value': '62 kg'},
    {'date': 'May 28', 'type': 'BP', 'value': '128/82'},
    {'date': 'May 25', 'type': 'Sugar', 'value': '138 mg/dL (Fasting)'},
    {'date': 'May 20', 'type': 'BP', 'value': '125/80'},
    {'date': 'May 15', 'type': 'Sugar', 'value': '130 mg/dL (Fasting)'},
    {'date': 'May 10', 'type': 'Weight', 'value': '61 kg'},
  ];

  // --- Dummy Data for Medicine Vault (adjusted to have more items for pagination) ---
  final List<Map<String, String>> medicines = [
    {
      'name': 'Paracetamol',
      'dosage': '500mg',
      'instructions': 'Take after food',
      'medicineId': 'med001',
    },
    {
      'name': 'Cetirizine',
      'dosage': '10mg',
      'instructions': 'Once daily',
      'medicineId': 'med002',
    },
    {
      'name': 'Telmisartan',
      'dosage': '40mg',
      'instructions': 'Once daily',
      'medicineId': 'med003',
    },
    {
      'name': 'Vitamin D3',
      'dosage': '1100 IU',
      'instructions': 'Take after food',
      'medicineId': 'med004',
    },
    {
      'name': 'Amoxicillin',
      'dosage': '250mg',
      'instructions': 'Three times daily',
      'medicineId': 'med005',
    },
    {
      'name': 'Insulin',
      'dosage': '10 units',
      'instructions': 'Before breakfast',
      'medicineId': 'med006',
    },
    {
      'name': 'Metformin',
      'dosage': '500mg',
      'instructions': 'With meals',
      'medicineId': 'med007',
    },
    {
      'name': 'Aspirin',
      'dosage': '75mg',
      'instructions': 'Daily',
      'medicineId': 'med008',
    },
    {
      'name': 'Omeprazole',
      'dosage': '20mg',
      'instructions': 'Before food',
      'medicineId': 'med009',
    },
    {
      'name': 'Dolo 650',
      'dosage': '650mg',
      'instructions': 'As needed',
      'medicineId': 'med010',
    },
    {
      'name': 'Lisinopril',
      'dosage': '10mg',
      'instructions': 'Once daily',
      'medicineId': 'med011',
    },
    {
      'name': 'Atorvastatin',
      'dosage': '20mg',
      'instructions': 'At bedtime',
      'medicineId': 'med012',
    },
  ];

  // Number of medicines to show per page in the vault
  final int _medicinesPerPage = 5;

  // Calculate total pages for medicines vault
  int get _numMedicineVaultPages =>
      (medicines.length / _medicinesPerPage).ceil();

  // --- Dummy Data for Medical Reports ---
  final List<Map<String, String>> medicalReports = [
    {'name': 'BP Report May.pdf', 'type': 'pdf', 'reportId': 'rep001'},
    {'name': 'Discharge Summary.png', 'type': 'image', 'reportId': 'rep002'},
    {'name': 'Blood Test Jun.pdf', 'type': 'pdf', 'reportId': 'rep003'},
  ];

  // --- Dummy Data for Medication Status Log ---
  final List<Map<String, String>> medicationStatusLog = [
    {
      'date': 'Today',
      'time': '9:00 AM',
      'medicine': 'Telmisartan',
      'status': 'Taken',
    },
    {
      'date': 'Today',
      'time': '8:00 AM',
      'medicine': 'Insulin',
      'status': 'Taken',
    },
    {
      'date': 'Yesterday',
      'time': '10:00 PM',
      'medicine': 'Atorvastatin',
      'status': 'Taken',
    },
    {
      'date': 'Yesterday',
      'time': '6:00 PM',
      'medicine': 'Paracetamol',
      'status': 'Missed',
    },
    {
      'date': 'Yesterday',
      'time': '9:00 AM',
      'medicine': 'Telmisartan',
      'status': 'Taken',
    },
    {
      'date': 'Jun 7',
      'time': '8:00 AM',
      'medicine': 'Insulin',
      'status': 'Missed',
    },
    {
      'date': 'Jun 7',
      'time': '6:00 AM',
      'medicine': 'Dolo 650',
      'status': 'Taken',
    },
  ];

  @override
  void dispose() {
    _healthMetricsPageController.dispose();
    _medicinesVaultPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              context.go('/family'), // Navigate back to family list
        ),
        title: Text(
          familyMemberName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Family Member Info Header ---
            _buildSectionHeader(
              context,
              title: familyMemberName,
              subTitle: 'Age: $age | $conditions',
              icon: Icons.person,
            ),
            const SizedBox(height: 20), // Spacing between sections
            // --- Health Metrics Section (Horizontal PageView with Indicator) ---
            _buildSectionTitle('Health Metrics'),
            const SizedBox(height: 10),
            SizedBox(
              height: 100, // Fixed height for horizontal cards
              child: AnimationLimiter(
                child: PageView.builder(
                  controller: _healthMetricsPageController,
                  itemCount: healthLogs.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentHealthMetricPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final log = healthLogs[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0, // Animate horizontally
                        child: FadeInAnimation(
                          child: _buildHealthMetricCard(
                            log['type']!,
                            log['value']!,
                            log['date']!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Page indicator for Health Metrics (circles only)
            _buildCirclePageIndicator(
              currentPage: _currentHealthMetricPageIndex,
              totalPages: healthLogs.length,
            ),
            const SizedBox(height: 20), // Spacing between sections
            // --- Medicines Vault Section (Horizontal PageView with Indicator) ---
            _buildSectionTitle('Medicines Vault'),
            const SizedBox(height: 10),
            SizedBox(
              height:
                  _medicinesPerPage *
                  54.0, // 50 (item height) + 2*2 (margin) = 54 per item
              child: AnimationLimiter(
                child: PageView.builder(
                  controller: _medicinesVaultPageController,
                  itemCount: _numMedicineVaultPages,
                  onPageChanged: (index) {
                    setState(() {
                      _currentMedicineVaultPageIndex = index;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    final int startIndex = pageIndex * _medicinesPerPage;
                    final int endIndex = (startIndex + _medicinesPerPage).clamp(
                      0,
                      medicines.length,
                    );
                    final List<Map<String, String>> currentMedicines = medicines
                        .sublist(startIndex, endIndex);

                    return KeyedSubtree(
                      key: ValueKey(
                        pageIndex,
                      ), // Important: Force rebuild when pageIndex changes
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 400,
                        ), // Duration for the page transition
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              // Combine Fade and Slide for a nice page entry effect
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(
                                      1.0,
                                      0.0,
                                    ), // Start from right
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                        child: Column(
                          // This is the content that AnimatedSwitcher will transition
                          key: ValueKey(
                            'medicinesPage_$pageIndex',
                          ), // **FIXED**: Unique key for Column per page
                          children: AnimationConfiguration.toStaggeredList(
                            // Stagger from the top of the new page
                            duration: const Duration(milliseconds: 375),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: currentMedicines.map((medicine) {
                              return _buildMedicineVaultItem(
                                context,
                                medicine['name']!,
                                medicine['instructions']!,
                                medicine['medicineId']!,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Page indicator for Medicines Vault (numbers with arrows)
            _buildPageIndicatorWithArrows(
              pageController: _medicinesVaultPageController,
              currentPage: _currentMedicineVaultPageIndex,
              totalPages: _numMedicineVaultPages,
            ),
            const SizedBox(height: 20), // Spacing between sections
            // --- Medication Log Section: Taken/Missed Medicines ---
            _buildSectionTitle('Medication Log'),
            const SizedBox(height: 10),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: medicationStatusLog.map((log) {
                    return _buildMedicationStatusItem(
                      context,
                      log['medicine']!,
                      log['date']!,
                      log['time']!,
                      log['status']!,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing at bottom
            // --- Medical Reports Section ---
            _buildSectionTitle('Medical Reports'),
            const SizedBox(height: 10),
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: medicalReports.map((report) {
                    return _buildMedicalReportItem(
                      context,
                      report['name']!,
                      report['type']!,
                      report['reportId']!,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing at bottom
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets matching _buildList2 style ---

  // Generic Section Header (like the Alerts header, adapted for family member info)
  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subTitle,
    required IconData icon,
  }) {
    return Container(
      height: 70, // Slightly taller for two lines of text
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
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title (e.g., "Health Metrics", "Medicines Vault")
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Health Metric Card (for horizontal PageView)
  Widget _buildHealthMetricCard(String type, String value, String date) {
    return Container(
      width: 180, // Fixed width for each card in horizontal scroll
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey.shade400), // All-around border
        borderRadius: BorderRadius.circular(8), // Slight rounding for cards
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple, // Highlight value
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Medicine Vault Item (matches _buildList2 exactly)
  Widget _buildMedicineVaultItem(
    BuildContext context,
    String name,
    String instructions,
    String medicineId,
  ) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to MedicineDetailsScreen using GoRouter
          context.go("/medicine_details/$medicineId");
        },
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
                  child: Icon(Icons.medication, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      instructions,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.black54,
                ),
                onPressed: () {
                  // Navigate to MedicineDetailsScreen using GoRouter
                  context.go("/medicine_details/$medicineId");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// New Helper Widget for displaying individual medication status log entries.
  /// This matches the _buildList2 style for consistency.
  Widget _buildMedicationStatusItem(
    BuildContext context,
    String medicineName,
    String date,
    String time,
    String status, // 'Taken' or 'Missed'
  ) {
    IconData statusIcon;
    Color iconColor;
    String statusText;

    if (status == 'Taken') {
      statusIcon = Icons.check_circle_outline;
      iconColor = Colors.green.shade700;
      statusText = 'Taken';
    } else {
      statusIcon = Icons.cancel_outlined;
      iconColor = Colors.red.shade700;
      statusText = 'Missed';
    }

    return Container(
      height: 60, // Slightly increased height to accommodate status text better
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          8,
        ), // Increased padding for better spacing
        child: Row(
          children: [
            const SizedBox(width: 4),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.grey, // Background for the status icon
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(statusIcon, color: iconColor, size: 24),
              ),
            ),
            const SizedBox(width: 12), // Spacing between icon and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    medicineName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Small space between lines
                  Text(
                    '$date, $time - $statusText',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          iconColor, // Use status color for date/time/status text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Optional: Add an action button here (e.g., info, reschedule)
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: () {
                // Handle tapping for more details or actions
                print('Tapped on $medicineName status log for more info.');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Medical Report Item (matches _buildList2 style with view action)
  Widget _buildMedicalReportItem(
    BuildContext context,
    String name,
    String type,
    String reportId,
  ) {
    IconData fileIcon;
    Color iconColor;
    if (type == 'pdf') {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red.shade700;
    } else if (type == 'image') {
      fileIcon = Icons.image;
      iconColor = Colors.blue.shade700;
    } else {
      fileIcon = Icons.insert_drive_file;
      iconColor = Colors.grey.shade700;
    }

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Implement viewing the report
          print('Viewing report: $name (ID: $reportId)');
        },
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
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(fileIcon, color: iconColor), // Icon based on type
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "File Type: ${type.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Colors.black54,
                ), // Download/View icon
                onPressed: () {
                  // Implement viewing the report
                  print('Downloading/Viewing report: $name (ID: $reportId)');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- New Helper for Circle-only Page Indicator ---
  Widget _buildCirclePageIndicator({
    required int currentPage,
    required int totalPages,
  }) {
    if (totalPages == 0)
      return const SizedBox.shrink(); // Don't show if no pages

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade600.withOpacity(
                currentPage == index
                    ? 1.0
                    : 0.3, // Full opacity for current, low for others
              ),
            ),
          );
        }),
      ),
    );
  }

  // Helper Widget for the Page Indicator with Arrows (for numerical display)
  Widget _buildPageIndicatorWithArrows({
    required PageController pageController,
    required int currentPage,
    required int totalPages,
  }) {
    if (totalPages == 0)
      return const SizedBox.shrink(); // Don't show if no pages

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
                : null, // Disable if on the first page
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          Text(
            ' ${currentPage + 1} / $totalPages ',
            style: const TextStyle(
              fontSize: 14,
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
                : null, // Disable if on the last page
            icon: const Icon(Icons.arrow_forward_ios_outlined),
          ),
        ],
      ),
    );
  }
}
