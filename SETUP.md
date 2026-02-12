# VisionBreak - Setup Guide

## Prerequisites

### Required Software
1. **Flutter SDK** (Stable channel)
   - Download from: https://flutter.dev/docs/get-started/install
   - Version: 3.0.0 or later
   
2. **Android Studio** or **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code with Flutter extension: https://code.visualstudio.com/
   
3. **Android SDK**
   - API Level 34 (Android 14)
   - Minimum API Level 24 (Android 7.0)
   
4. **Java Development Kit (JDK)**
   - Version 17 (Temurin or Oracle)

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/imriadh/VisionBreak.git
cd VisionBreak
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Verify Flutter Setup
```bash
flutter doctor
```
Fix any issues reported by Flutter Doctor.

### 4. Configure Android

#### Set Java Home (if needed)
```bash
# macOS/Linux
export JAVA_HOME=/path/to/java17
export PATH=$JAVA_HOME/bin:$PATH

# Windows
set JAVA_HOME=C:\path\to\java17
set PATH=%JAVA_HOME%\bin;%PATH%
```

#### Accept Android Licenses
```bash
flutter doctor --android-licenses
```

## GitHub Codespaces Setup

### 1. Open in Codespaces
Click "Code" → "Codespaces" → "New codespace" on GitHub

### 2. Install Flutter
```bash
# Flutter is pre-installed in many Codespaces configurations
flutter --version

# If not installed, run:
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
```

### 3. Install Android SDK
```bash
# Install Android SDK command-line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip -d $HOME/android-sdk
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
```

### 4. Setup Flutter for Android
```bash
flutter config --android-sdk $ANDROID_HOME
flutter doctor --android-licenses
```

## Building the App

### Development Build
```bash
# Run on connected device/emulator
flutter run

# Run with hot reload
flutter run --hot
```

### Release Build (APK)
```bash
# Build single APK (universal)
flutter build apk --release

# Build split APKs (recommended, smaller size)
flutter build apk --release --split-per-abi
```

Output location: `build/app/outputs/flutter-apk/`

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/bundle/release/`

## Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## Code Analysis
```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Format specific file
flutter format lib/main.dart
```

## Troubleshooting

### Common Issues

#### 1. "SDK location not found"
```bash
# Create local.properties file in android/
echo "sdk.dir=/path/to/android/sdk" > android/local.properties
```

#### 2. "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 3. "Java version mismatch"
```bash
# Check Java version
java -version

# Should show Java 17. If not, install Java 17 and set JAVA_HOME
```

#### 4. "Flutter doctor shows issues"
```bash
# Re-run doctor with verbose mode
flutter doctor -v

# Follow the specific instructions for each issue
```

### Performance Issues

#### Slow build times
```bash
# Enable Gradle daemon
echo "org.gradle.daemon=true" >> android/gradle.properties
echo "org.gradle.parallel=true" >> android/gradle.properties
```

#### Large APK size
```bash
# Use split APKs
flutter build apk --release --split-per-abi

# Enable R8 (already configured in build.gradle)
# Check proguard rules in android/app/proguard-rules.pro
```

## Development Tips

### Hot Reload
- Press `r` in terminal while app is running
- Or use IDE's hot reload button
- For major changes, use hot restart: `R`

### Debug Mode
```bash
# Run in debug mode with logging
flutter run --debug

# View logs
flutter logs
```

### Connected Devices
```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

## Environment Variables

Optional environment variables you can set:

```bash
# Flutter
export FLUTTER_ROOT=/path/to/flutter
export PATH=$PATH:$FLUTTER_ROOT/bin

# Android
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Java
export JAVA_HOME=/path/to/java17
export PATH=$PATH:$JAVA_HOME/bin
```

## IDE Setup

### VS Code
Install these extensions:
- Flutter
- Dart
- Flutter Widget Snippets

### Android Studio
Install these plugins:
- Flutter
- Dart

## Next Steps

1. Read [README.md](README.md) for app features
2. Check [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
3. Review code in `lib/` to understand architecture
4. Run the app and explore features
5. Start coding! 🚀

## Support

- Issues: https://github.com/imriadh/VisionBreak/issues
- Discussions: https://github.com/imriadh/VisionBreak/discussions
- Email: (add your email if desired)

Happy coding! 💻✨
