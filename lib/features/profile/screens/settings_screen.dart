import 'package:flutter/material.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  /// Constructor
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // TODO: Load actual settings from storage
    
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    setState(() {
      // Default values for now
      _isDarkMode = false;
      _notificationsEnabled = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    
    // TODO: Save theme preference and update app theme
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    
    // TODO: Save notification preference
  }

  void _toggleSound(bool value) {
    setState(() {
      _soundEnabled = value;
    });
    
    // TODO: Save sound preference
  }

  void _toggleVibration(bool value) {
    setState(() {
      _vibrationEnabled = value;
    });
    
    // TODO: Save vibration preference
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingSection(
            theme,
            'Appearance',
            [
              _buildSwitchTile(
                theme,
                'Dark Mode',
                'Switch between light and dark theme',
                Icons.dark_mode_outlined,
                _isDarkMode,
                _toggleDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingSection(
            theme,
            'Notifications',
            [
              _buildSwitchTile(
                theme,
                'Enable Notifications',
                'Receive reminders for your medications',
                Icons.notifications_outlined,
                _notificationsEnabled,
                _toggleNotifications,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                theme,
                'Sound',
                'Play sound with notifications',
                Icons.volume_up_outlined,
                _soundEnabled,
                _toggleSound,
                enabled: _notificationsEnabled,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                theme,
                'Vibration',
                'Vibrate with notifications',
                Icons.vibration_outlined,
                _vibrationEnabled,
                _toggleVibration,
                enabled: _notificationsEnabled,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingSection(
            theme,
            'Data & Privacy',
            [
              _buildActionTile(
                theme,
                'Clear App Data',
                'Remove all app data and reset to default',
                Icons.delete_outline,
                _showClearDataDialog,
              ),
              const Divider(height: 1),
              _buildActionTile(
                theme,
                'Export Data',
                'Export your medicine data as CSV',
                Icons.download_outlined,
                _exportData,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(
    ThemeData theme,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: enabled
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
        ),
      ),
      secondary: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled
              ? theme.colorScheme.primaryContainer.withOpacity(0.5)
              : theme.colorScheme.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: theme.colorScheme.primary,
    );
  }

  Widget _buildActionTile(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Future<void> _showClearDataDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear App Data'),
        content: const Text(
          'This will remove all your medicines, reminders, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement clear data functionality
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('App data cleared'),
        ),
      );
    }
  }

  void _exportData() {
    // TODO: Implement data export functionality
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export not implemented yet'),
      ),
    );
  }
}
