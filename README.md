# MediScan - Medicine Scanning & Tracking App

A Flutter mobile application for scanning, tracking, and managing medications with reminders.

## 📱 Features

- **Medicine Scanning**: Scan medicine packages using OCR to extract information
- **Medicine Tracking**: Keep track of all your medicines in one place
- **Reminders**: Set up customizable reminders for your medications
- **Reordering**: Find options to reorder your medicines from various pharmacies
- **User Profile**: Manage your profile and app settings

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/mediscan.git
   cd mediscan
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 🧩 Project Structure

The project follows a feature-based architecture:

```
lib/
├── core/               # Theme, config, constants
├── features/
│   ├── auth/           # Login, onboarding
│   ├── scan/           # OCR UI and camera
│   ├── medicine/       # Add, list, detail
│   ├── reminders/      # Reminders and alerts
│   └── profile/        # User profile & settings
├── shared/             # Common widgets, models
├── routes/             # Navigation logic
├── main.dart
```

## 🔌 Adding Dependencies

### Firebase Integration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your app to the Firebase project
3. Download the configuration files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)
4. Place them in the appropriate directories
5. Uncomment Firebase dependencies in `pubspec.yaml`
6. Run `flutter pub get`

### OCR Integration

1. Uncomment the `google_ml_kit` dependency in `pubspec.yaml`
2. Run `flutter pub get`
3. Add OCR logic in the `lib/features/scan/services/` directory
4. Connect the OCR service to the scan screen

### Notifications Integration

1. Uncomment the `flutter_local_notifications` dependency in `pubspec.yaml`
2. Run `flutter pub get`
3. Add notification service in the `lib/core/services/` directory
4. Connect the notification service to the reminders feature

## 🎨 Customization

- **Theme**: Modify colors in `lib/core/theme/color_schemes.dart`
- **Text Styles**: Update text styles in `lib/core/theme/text_themes.dart`
- **App Constants**: Change app constants in `lib/core/constants/app_constants.dart`

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Material Design](https://material.io/design)
- [go_router](https://pub.dev/packages/go_router)
- [provider](https://pub.dev/packages/provider)
