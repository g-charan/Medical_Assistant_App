import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:go_router/go_router.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final String medicineId;

  const MedicineDetailsScreen({super.key, required this.medicineId});

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration

    const medicineName = "Paracetamol 500mg";

    const genericName = "Acetaminophen";

    const brand = "Calpol (GSK)";

    const dosage = "500mg";

    const frequency = "2 times a day";

    const duration = "Until June 15, 2025";

    const warnings =
        "Do not exceed recommended dose. Consult doctor if fever persists for more than 3 days or pain for more than 10 days. Avoid alcohol consumption as it may increase the risk of liver damage.";

    const sideEffects =
        "Mild stomach upset, nausea, allergic reactions (rare). Seek immediate medical attention if you experience severe allergic reactions.";

    const storage =
        "Store at room temperature (15-30°C), away from direct sunlight and moisture. Keep out of reach of children.";

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),

          onPressed: () => context.go('/vault'),
        ),

        title: const Text(
          'Medicine Details',

          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildHeader(medicineName, genericName),

            const SizedBox(height: 20),

            _buildTabBar(),

            const SizedBox(height: 20),

            _buildInfoCards(),

            const SizedBox(height: 20),

            _buildInfoSection(
              "Important Warnings",

              warnings,

              Icons.warning_amber_rounded,

              Colors.red.shade100,
            ),

            const SizedBox(height: 12),

            _buildInfoSection(
              "Side Effects",

              sideEffects,

              Icons.healing_outlined,

              Colors.orange.shade100,
            ),

            const SizedBox(height: 12),

            _buildInfoSection(
              "Storage Instructions",

              storage,

              Icons.inventory_2_outlined,

              Colors.blue.shade100,
            ),

            const SizedBox(height: 20),

            _buildMedicationInfo(brand, dosage, frequency, duration),

            const SizedBox(height: 20),

            _buildWeeklyTracking(),

            const SizedBox(height: 20),

            _buildAIAssistant(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String genericName) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        // Remove the 'color' property and add 'gradient'
        gradient: LinearGradient(
          colors: [
            const Color(0xFFA3B18A), // Lighter green from the image
            const Color(0xFF588157), // Darker green from the image
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),

              borderRadius: BorderRadius.circular(8),
            ),

            child: const Icon(
              Icons.medication,
              color: Color(0xFF3A5A40),
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,

                  style: const TextStyle(
                    fontSize: 20,

                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Text(
                  "($genericName)",

                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 10,
                    ),

                    const SizedBox(width: 4),

                    const Text(
                      "Active prescription",

                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),

                    const Spacer(),

                    const Text(
                      "30 days left",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 62,

      decoration: BoxDecoration(
        color: Color(0xFFDAD7CD).withValues(alpha: 0.2),

        border: Border.all(color: Color(0xFFDAD7CD), width: 1),

        borderRadius: BorderRadius.circular(8),
      ),

      child: TabBar(
        controller: _tabController,

        indicatorPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),

        indicatorSize: TabBarIndicatorSize.tab,

        indicator: BoxDecoration(
          shape: BoxShape.rectangle,

          borderRadius: BorderRadius.circular(8),

          color: const Color(0xFF344E41),
        ),

        labelColor: Colors.white,

        unselectedLabelColor: Colors.black,

        tabs: const [
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ), // Add horizontal padding

              child: Text('Overview', style: TextStyle(fontSize: 16)),
            ),
          ),

          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ), // Add horizontal padding

              child: Text('Tracking', style: TextStyle(fontSize: 16)),
            ),
          ),

          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ), // Add horizontal padding

              child: Text('Safety', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoCard("Last Taken", "2 hours ago")),

            const SizedBox(width: 12),

            Expanded(child: _buildInfoCard("Next Dose", "12 hours (8:00 PM)")),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _buildInfoCard("Last Taken", "2 hours ago")),

            const SizedBox(width: 12),

            Expanded(child: _buildInfoCard("Next Dose", "12 hours (8:00 PM)")),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Color(0xFFDAD7CD).withValues(alpha: 0.2),

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: Color(0xFFDAD7CD), width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 4),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,

    String content,

    IconData icon,

    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Color(0xFFDAD7CD).withValues(alpha: 0.2),

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: Color(0xFFDAD7CD), width: 1),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 32,

            height: 32,

            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),

            child: Icon(icon, color: Colors.black54, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(child: Text(content, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildMedicationInfo(
    String brand,

    String dosage,

    String frequency,

    String duration,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Color(0xFFDAD7CD).withValues(alpha: 0.2),

        border: Border.all(color: Color(0xFFDAD7CD), width: 1),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Medication Information",

            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _buildDetailRow("Brand", brand),

          const Divider(),

          _buildDetailRow("Dosage", dosage),

          const Divider(),

          _buildDetailRow("Frequency", frequency),

          const Divider(),

          _buildDetailRow("Duration", duration),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),

          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWeeklyTracking() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "Weekly Medication Tracking",

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(Icons.chevron_left),

                    constraints: const BoxConstraints(),
                  ),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(Icons.chevron_right),

                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          const Text("Adherence: % +/- doses taken"),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(Icons.circle, color: Color(0xFF388E3C), size: 12),

              const SizedBox(width: 4),

              const Text("Taken"),

              const SizedBox(width: 16),

              Icon(Icons.circle, color: Colors.grey.shade400, size: 12),

              const SizedBox(width: 4),

              const Text("Missed"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIAssistant(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF344E41),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: const Icon(
                    Icons.smart_toy_outlined,

                    color: Colors.white,

                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "AI Medicine Assistant",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      "Ask questions about this medication",

                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              Expanded(
                child: TextField(
                  controller: _myController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),

                  decoration: InputDecoration(
                    filled: true, // Fill the background with color
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF344E41)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFDAD7CD)),
                    ),
                    hintText: "Ask about dosage, side effects an...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFDAD7CD)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ), // Adjusted padding
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF344E41),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: const FaIcon(
                    FontAwesomeIcons.solidPaperPlane,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
