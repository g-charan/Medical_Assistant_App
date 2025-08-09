import 'package:flutter/material.dart';
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
            _buildAIAssistant(),
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
        color: const Color(0xFF81C784).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF388E3C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medication, color: Colors.white, size: 28),
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
                  ),
                ),
                Text(
                  genericName,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green.shade700, size: 10),
                    const SizedBox(width: 4),
                    const Text(
                      "Active prescription",
                      style: TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    const Text("30 days left", style: TextStyle(fontSize: 12)),
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
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF388E3C),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Tracking'),
          Tab(text: 'Safety'),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(child: _buildInfoCard("Last Taken", "2 hours ago")),
        const SizedBox(width: 12),
        Expanded(child: _buildInfoCard("Next Dose", "12 hours (8:00 PM)")),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
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
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
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
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Medication Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
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

  Widget _buildAIAssistant() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.smart_toy_outlined, color: Color(0xFF388E3C)),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF388E3C),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
