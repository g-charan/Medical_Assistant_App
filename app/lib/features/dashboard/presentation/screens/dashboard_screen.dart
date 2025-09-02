import 'dart:async';
import 'package:app/core/utils/app_refresher.dart';
import 'package:app/features/vault/presentation/providers/medicines_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Assuming these providers and widgets exist from your previous code

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // FIX: Updated color constants to better match the design.
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Colors.grey;
  static const Color appPrimaryColor = Color(0xFF3A5B43);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineAsyncValue = ref.watch(medicineDataProvider);
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      body: AppRefresher(
        onRefresh: () async {
          await ref.refresh(medicineDataProvider.future);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- Header ---
              _buildHeader(context, medicineAsyncValue, today),
              const SizedBox(height: 24),

              // --- Metrics Card (Now a slider) ---
              const MetricsSliderCard(), // Replaced static card with slider
              const SizedBox(height: 24),

              // --- Upcoming Medicine ---
              _buildSectionTitle(context, "Upcoming Medicine"),
              const SizedBox(height: 8),
              _buildUpcomingMedicine(context),
              const SizedBox(height: 24),

              // --- Family Members ---
              _buildSectionTitle(context, "Family Members"),
              const SizedBox(height: 16),
              _buildFamilyMembers(context),
              const SizedBox(height: 24),

              // --- Quick Actions ---
              _buildSectionTitle(context, "Quick Actions"),
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets for Building Sections ---

  Widget _buildHeader(
    BuildContext context,
    AsyncValue medicineAsyncValue,
    DateTime today,
  ) {
    return medicineAsyncValue.when(
      data: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello, Jayasree", // Placeholder name
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat(
                  'EEEE, MMM d',
                ).format(today), // e.g., Wednesday, Aug 6
                style: const TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Navigate to settings or profile screen
              context.go('/settings');
            },
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.person, size: 30, color: Colors.black54),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Text("Error loading data"),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: primaryTextColor,
      ),
    );
  }

  Widget _buildUpcomingMedicine(BuildContext context) {
    return Column(
      children: [
        _buildMedicineTile(
          context,
          "Vitamin D3 1100",
          "After food - 7:00 PM",
          true,
        ),
        const SizedBox(height: 8),
        _buildMedicineTile(
          context,
          "Paracetamol",
          "After lunch - 1:00 PM",
          false,
        ),
      ],
    );
  }

  Widget _buildMedicineTile(
    BuildContext context,
    String name,
    String time,
    bool isTaken,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      leading: FaIcon(
        isTaken ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
        color: isTaken ? const Color(0xFF3A5B43) : Colors.grey,
        size: 28,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
      ),
      subtitle: Text(time, style: const TextStyle(color: secondaryTextColor)),
      trailing: const FaIcon(FontAwesomeIcons.pills, color: Color(0xFF3A5B43)),
      onTap: () {},
    );
  }

  Widget _buildFamilyMembers(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFamilyMemberAvatar(context, "Jayasree", "JG", "23min ago"),
        _buildFamilyMemberAvatar(context, "Charan", "CG", "4h ago"),
        _buildFamilyMemberAvatar(
          context,
          "Add Member",
          null,
          null,
          isAddButton: true,
        ),
      ],
    );
  }

  Widget _buildFamilyMemberAvatar(
    BuildContext context,
    String name,
    String? initials,
    String? updated, {
    bool isAddButton = false,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isAddButton
              ? const Color(0xFFE3F2FD)
              : const Color(0xFFF3E5F5),
          child: isAddButton
              ? const Icon(Icons.add, color: Color(0xFF1565C0), size: 30)
              : Text(
                  initials ?? "",
                  style: const TextStyle(
                    color: Color(0xFF6A1B9A),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        if (updated == null) const SizedBox(height: 16),
        if (updated != null)
          Text(
            "Updated $updated",
            style: const TextStyle(color: secondaryTextColor, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildActionCard(
          context,
          "Add Medicine",
          Icons.medication_outlined,
          () => context.go('/vault'),
        ),
        _buildActionCard(
          context,
          "Upload Reports",
          Icons.file_upload_outlined,
          () => context.go('/reports'),
        ),
        _buildActionCard(
          context,
          "Track Metrics",
          Icons.bar_chart_outlined,
          () => context.go('/metrics'),
        ),
        _buildActionCard(
          context,
          "Ask AI",
          Icons.smart_toy_outlined,
          () => context.go('/ai'),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: const Color(0xFFF9F9F9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: appPrimaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Metrics Slider Card Widget ---

class MetricsSliderCard extends StatefulWidget {
  const MetricsSliderCard({super.key});

  @override
  State<MetricsSliderCard> createState() => _MetricsSliderCardState();
}

class _MetricsSliderCardState extends State<MetricsSliderCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Dummy data for the slider
  final List<Widget> _metricPages = [
    _buildMetricPage(
      "122/80",
      "mmHg",
      "Normal",
      "Excellent",
      "Last updated: 2 min ago",
    ),
    _buildMetricPage("98", "bpm", "Resting", "Good", "Last updated: 5 min ago"),
    _buildMetricPage(
      "105",
      "mg/dL",
      "Fasting",
      "Normal",
      "Last updated: 1 day ago",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Start a timer to auto-scroll the PageView
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _metricPages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Color(0xFFDAD7CD), width: 2.0),
      ),
      color: const Color(0xFFDAD7CD).withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 125, // Fixed height for the PageView
              child: PageView.builder(
                controller: _pageController,
                itemCount: _metricPages.length,
                itemBuilder: (context, index) {
                  return _metricPages[index];
                },
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_metricPages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentPage == index ? 24.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? HomeScreen.appPrimaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Static helper to build a single metric page
  static Widget _buildMetricPage(
    String value,
    String unit,
    String status1,
    String status2,
    String lastUpdated,
  ) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: HomeScreen.primaryTextColor,
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        color: HomeScreen.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Color(0xFF4CAF50),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status1,
                          style: const TextStyle(color: Color(0xFF4CAF50)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFC107),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status2,
                          style: const TextStyle(color: Color(0xFFFFC107)),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, color: Colors.redAccent),
                  label: const Text("Heart Rate"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 1,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              lastUpdated,
              style: const TextStyle(
                color: HomeScreen.secondaryTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
