/// App constants
class AppConstants {
  /// App name
  static const String appName = 'MediScan';
  
  /// App version
  static const String appVersion = '1.0.0';
  
  /// App build number
  static const int appBuildNumber = 1;
  
  /// Shared preferences key for theme mode
  static const String themePreferenceKey = 'theme_mode';
  
  /// Shared preferences key for onboarding status
  static const String onboardingCompleteKey = 'onboarding_complete';
  
  /// Shared preferences key for user login status
  static const String userLoggedInKey = 'user_logged_in';
  
  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  /// Splash screen duration
  static const Duration splashDuration = Duration(seconds: 2);
  
  /// Onboarding page count
  static const int onboardingPageCount = 3;
}
