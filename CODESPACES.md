# GitHub Codespaces Guide for VisionBreak

## Quick Setup

### 1. Install Flutter & Android SDK

Run the setup script:

```bash
chmod +x setup-codespaces.sh
./setup-codespaces.sh
```

This will:
- Install Flutter SDK
- Install Android SDK
- Configure environment variables
- Accept Android licenses

**Time required**: ~5-10 minutes

### 2. Reload Your Terminal

After setup completes:

```bash
source ~/.bashrc
```

Or close and reopen your terminal.

### 3. Verify Installation

```bash
flutter --version
flutter doctor
```

You should see Flutter version information.

## Running the App in Codespaces

### Option 1: Web Version (Recommended for Codespaces)

Since Codespaces doesn't have an Android device or emulator, run the web version:

```bash
# Get dependencies
flutter pub get

# Enable web support (one-time)
flutter config --enable-web

# Run on web
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```

The app will be available at the forwarded port URL (VS Code will show a notification).

### Option 2: Build APK (For Download)

Build the Android APK that you can download and install on a real device:

```bash
# Build release APK
flutter build apk --release --split-per-abi

# APKs will be in: build/app/outputs/flutter-apk/
```

Download the APKs from:
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (Most devices)
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (Older devices)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (Intel devices)

## Development Workflow

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Formatting Code

```bash
flutter format .
```

### Hot Reload (Web)

When running `flutter run` for web, press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

## Troubleshooting

### Flutter Command Not Found

```bash
# Add Flutter to PATH manually
export PATH="$HOME/flutter/bin:$PATH"
source ~/.bashrc
```

### Android SDK Issues

```bash
# Reconfigure Android SDK
export ANDROID_SDK_ROOT="$HOME/android-sdk"
flutter config --android-sdk $ANDROID_SDK_ROOT
```

### Port Already in Use

```bash
# Use a different port
flutter run -d web-server --web-port=8081 --web-hostname=0.0.0.0
```

### Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk
```

## Accessing the Web App

1. When you run `flutter run -d web-server`, VS Code will show a notification
2. Click "Open in Browser" or go to the Ports tab
3. Find port 8080 and click the 🌐 icon
4. The app will open in your browser

## File Management

### Download APK from Codespaces

1. Build the APK: `flutter build apk --release --split-per-abi`
2. In VS Code Explorer, navigate to `build/app/outputs/flutter-apk/`
3. Right-click on the APK file
4. Select "Download"

### Upload to GitHub Releases

The GitHub Actions workflow will automatically build and release APKs when you push to main.

## Environment Variables

These are automatically set by the setup script:

```bash
FLUTTER_ROOT=$HOME/flutter
ANDROID_SDK_ROOT=$HOME/android-sdk
ANDROID_HOME=$ANDROID_SDK_ROOT
PATH includes Flutter and Android SDK paths
```

## Limitations in Codespaces

### ❌ Cannot Run:
- Android Emulator (requires KVM/hardware acceleration)
- iOS Simulator (requires macOS)
- Physical device connection

### ✅ Can Do:
- Build APKs for download
- Run web version of the app
- Run tests
- Code analysis
- Git operations
- Use GitHub Actions for CI/CD

## Tips for Best Experience

1. **Use Web Version for Testing**: Quick iterations without building APKs
2. **Use GitHub Actions for APK Builds**: Automatic builds on every push
3. **Download APKs Locally**: Test on real devices
4. **Commit Often**: Codespaces can be rebuilt anytime
5. **Use Port Forwarding**: Access the web app from any device on your network

## Resource Management

### Disk Space

Check available space:
```bash
df -h
```

Clean up Flutter cache:
```bash
flutter clean
rm -rf ~/.pub-cache  # Remove downloaded packages (will re-download on pub get)
```

### Codespace Size

The setup requires ~2-3GB of disk space:
- Flutter SDK: ~1.5GB
- Android SDK: ~500MB
- Dependencies: ~500MB

## Next Steps

1. ✅ Run setup script
2. ✅ Reload terminal
3. ✅ Run `flutter pub get`
4. ✅ Start web server: `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0`
5. ✅ Open the forwarded port in your browser
6. 🎉 Start developing!

## Support

- Flutter Web docs: https://flutter.dev/web
- Flutter Codespaces: https://github.com/flutter/flutter/wiki/Developing-in-Codespaces
- VisionBreak Issues: https://github.com/imriadh/VisionBreak/issues

Happy coding in the cloud! ☁️✨
