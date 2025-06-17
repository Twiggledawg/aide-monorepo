# Mobile Package

Flutter mobile application for iOS and Android platforms with modern architecture and state management.

## 🏗️ Architecture

- **Framework**: Flutter 3.x with Dart
- **State Management**: Riverpod (Provider 2.0)
- **Navigation**: GoRouter
- **HTTP Client**: Dio with interceptors
- **Local Storage**: Hive or SharedPreferences
- **UI Components**: Custom design system
- **Testing**: Flutter Test + Mockito
- **Code Generation**: build_runner
- **Linting**: flutter_lints

## 🚀 Quick Start

### Prerequisites

- Flutter SDK >= 3.16.0
- Dart SDK >= 3.2.0
- Android Studio / Xcode
- Backend service running (for API calls)

### Installation

1. Install Flutter dependencies:
   ```bash
   pnpm install
   ```

2. Get Flutter packages:
   ```bash
   flutter pub get
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API endpoints
   ```

4. Run the app:
   ```bash
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   ```

## 📁 Project Structure

```
packages/mobile/
├── lib/
│   ├── app/              # App configuration
│   ├── core/             # Core utilities
│   │   ├── constants/    # App constants
│   │   ├── errors/       # Error handling
│   │   ├── network/      # Network utilities
│   │   └── utils/        # Utility functions
│   ├── features/         # Feature-based modules
│   │   ├── auth/         # Authentication feature
│   │   ├── home/         # Home feature
│   │   ├── profile/      # Profile feature
│   │   └── settings/     # Settings feature
│   ├── shared/           # Shared components
│   │   ├── widgets/      # Reusable widgets
│   │   ├── models/       # Shared models
│   │   └── services/     # Shared services
│   └── main.dart         # App entry point
├── test/                 # Test files
├── android/              # Android-specific code
├── ios/                  # iOS-specific code
├── pubspec.yaml          # Flutter dependencies
└── analysis_options.yaml # Dart analysis options
```

## 🛠️ Available Scripts

- `pnpm dev` - Run in development mode
- `pnpm build:android` - Build Android APK
- `pnpm build:ios` - Build iOS app
- `pnpm test` - Run tests
- `pnpm test:coverage` - Run tests with coverage
- `pnpm lint` - Run Dart analyzer
- `pnpm format` - Format Dart code
- `pnpm clean` - Clean build artifacts

## 🔧 Configuration

### Environment Variables

- `API_BASE_URL` - Backend API URL
- `API_KEY` - API authentication key
- `APP_NAME` - Application name
- `APP_VERSION` - Application version

### Key Features

- **Authentication**: JWT token management
- **Offline Support**: Local data caching
- **Push Notifications**: Firebase Cloud Messaging
- **Biometric Auth**: Fingerprint/Face ID support
- **Deep Linking**: URL scheme handling
- **Analytics**: Firebase Analytics integration

## 🎨 UI Components

The mobile app uses a custom design system:

- **Theme**: Material Design 3 with custom colors
- **Typography**: Custom font families
- **Icons**: Custom icon set + Material Icons
- **Animations**: Lottie animations
- **Responsive**: Adaptive layouts for different screen sizes

### Widget Examples

```dart
// Custom button widget
CustomButton(
  text: 'Sign In',
  onPressed: () => _handleSignIn(),
  variant: ButtonVariant.primary,
)

// Custom text field
CustomTextField(
  label: 'Email',
  controller: _emailController,
  validator: EmailValidator.validate,
)
```

## 🧪 Testing

```bash
# Run all tests
pnpm test

# Run tests with coverage
pnpm test:coverage

# Run specific test file
flutter test test/features/auth/auth_test.dart
```

## 📱 Platform Support

### iOS
- **Minimum Version**: iOS 12.0
- **Target Version**: iOS 17.0
- **Features**: Face ID, Touch ID, Apple Pay

### Android
- **Minimum Version**: Android 6.0 (API 23)
- **Target Version**: Android 14 (API 34)
- **Features**: Biometric authentication, Google Pay

## 🔒 Security

- **Certificate Pinning**: SSL certificate validation
- **Biometric Auth**: Secure authentication
- **Data Encryption**: Local data encryption
- **Network Security**: HTTPS enforcement
- **Code Obfuscation**: Release build protection

## 🚀 Performance

- **Lazy Loading**: On-demand resource loading
- **Image Caching**: Efficient image management
- **Memory Management**: Optimized memory usage
- **Background Processing**: Efficient background tasks
- **App Size**: Optimized APK/IPA size

## 📊 Analytics & Monitoring

- **Firebase Analytics**: User behavior tracking
- **Crashlytics**: Crash reporting
- **Performance Monitoring**: App performance metrics
- **Custom Events**: Business-specific tracking

## 🔄 State Management

Using Riverpod for state management:

```dart
// Provider example
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Consumer widget
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // ...
  }
}
```

## 🌐 Internationalization

Support for multiple languages:

- **English** (default)
- **Spanish**
- **French**
- **German**

## 📦 Build & Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for device
flutter build ios --release

# Archive for App Store
flutter build ipa --release
```

## 📚 Documentation

- **API Documentation**: Generated with dartdoc
- **Widget Catalog**: Interactive widget examples
- **Architecture Guide**: Detailed architecture documentation
- **Testing Guide**: Testing best practices 