/// App routes
class AppRoutes {
  /// Splash screen
  static const String splash = '/splash';
  
  /// Onboarding screen
  static const String onboarding = '/onboarding';
  
  /// Login screen
  static const String login = '/login';
  
  /// Scan screen (tab)
  static const String scan = '/scan';
  
  /// Medicines screen (tab)
  static const String medicines = '/medicines';
  
  /// Profile screen (tab)
  static const String profile = '/profile';
  
  /// Add medicine screen
  static const String addMedicine = '/medicines/add';
  
  /// Add medicine screen (relative path)
  static const String addMedicineRelative = 'add';
  
  /// Medicine details screen
  static const String medicineDetails = '/medicines/:id';
  
  /// Medicine details screen (relative path)
  static const String medicineDetailsRelative = ':id';
  
  /// Reminders screen
  static const String reminders = '/profile/reminders';
  
  /// Reminders screen (relative path)
  static const String remindersRelative = 'reminders';
  
  /// Reorder options screen
  static const String reorderOptions = '/medicines/:id/reorder';
  
  /// Reorder options screen (relative path)
  static const String reorderOptionsRelative = ':id/reorder';
  
  /// Settings screen
  static const String settings = '/profile/settings';
  
  /// Settings screen (relative path)
  static const String settingsRelative = 'settings';
}
