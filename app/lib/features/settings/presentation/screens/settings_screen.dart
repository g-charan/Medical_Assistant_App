import 'package:app/core/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 1. Convert to a ConsumerStatefulWidget to access Riverpod providers
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

// 2. Change the State to a ConsumerState
class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // --- Sign Out Logic ---
  void _signOut() async {
    try {
      // Use ref.read to access the service via its provider
      await ref.read(authServiceProvider).signOut();
      // Your GoRouter redirect logic will automatically
      // handle navigation to the login screen.
    } catch (e) {
      // Show an error if sign-out fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF3A5B43),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildStatCards(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildHealthStatus(),
            const SizedBox(height: 30),
            _buildSectionTitle("ACCOUNT"),
            _buildSettingsList([
              {
                "icon": Icons.person_outline,
                "title": "Profile Data",
                "subtitle": "Personal information & preferences",
                "onTap": () => context.push('/settings/edit-profile'),
              },
              {
                "icon": Icons.receipt_long_outlined,
                "title": "Billing & Payment",
                "subtitle": "Subscription & payment methods",
                "trailing": const Text(
                  "Premium",
                  style: TextStyle(color: Colors.green),
                ),
              },
              {
                "icon": Icons.star_border_outlined,
                "title": "Emergency Contacts",
                "subtitle": "Manage emergency contact information",
              },
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("NOTIFICATIONS"),
            _buildSettingsList([
              {
                "icon": Icons.notifications_outlined,
                "title": "Profile Data",
                "subtitle": "Personal information & preferences",
              },
              {
                "icon": Icons.email_outlined,
                "title": "Billing & Payment",
                "subtitle": "Subscription & payment methods",
              },
              {
                "icon": Icons.phone_outlined,
                "title": "Emergency Contacts",
                "subtitle": "Manage emergency contact information",
              },
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("PRIVACY & SECURITY"),
            _buildSettingsList([
              {
                "icon": Icons.security_outlined,
                "title": "Two-Factor Authentication",
                "subtitle": "Add extra security to your account",
              },
            ]),
            const SizedBox(height: 20),
            // Sign Out Button
            OutlinedButton.icon(
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              label: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: _signOut,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for the new UI ---

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFF388E3C),
          child: Text(
            "CG",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Charan Gutti",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "charan.gutti@gmail.com",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              "+1 (555) 123-4567",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              "male • 21 years old • O+",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            const Text("80% Complete", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            SizedBox(
              width: 50,
              child: LinearProgressIndicator(
                value: 0.8,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Height", "5'10\"", Icons.height)),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            "Weight",
            "165 lbs",
            Icons.monitor_weight_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade700)),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.history, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                "Appointments",
                "5 upcoming",
                Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                "Test results",
                "2 new",
                Icons.science_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                "Vaccinations",
                "Up to date",
                Icons.vaccines_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                "Health Data",
                "Synced",
                Icons.monitor_heart_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, color: Color(0xFF388E3C)),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You are all Good!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Just make sure you eat healthy and move your body regularly",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                "Last updated\n2 hours ago",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStepCounter("Steps Today", "8,247"),
              _buildStepCounter("Steps Today", "8,247"),
              _buildStepCounter("Steps Today", "8,247"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCounter(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsList(List<Map<String, dynamic>> items) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Icon(item['icon'], color: Colors.grey.shade700),
            title: Text(item['title']),
            subtitle: Text(item['subtitle']),
            trailing: item['trailing'] ?? const Icon(Icons.chevron_right),
            onTap: item['onTap'],
          );
        },
      ),
    );
  }
}
