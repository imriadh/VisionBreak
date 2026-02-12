# VisionBreak 👁️😴🎯

A lightweight wellness app combining eye care timer, sleep cycle alarm, and Pomodoro productivity tracker.

## Features

### 👁 Eye Care Timer (20-20-20 Rule)
- Circular animated countdown timer
- Customizable interval (15–60 minutes)
- One-tap start with play/pause/reset controls
- Persistent notification with controls
- Follows the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds

### 😴 Sleep Cycle Alarm Clock
- 90-minute sleep cycle calculator
- Suggests optimal wake-up times
- Native Android alarm integration
- Morning rating system (5 emoji scale)
- Sleep quality tracking with history

### 🎯 Pomodoro Study Timer
- 25 min focus / 5 min break (customizable)
- Session counter with daily statistics
- Auto-switching between work and break phases
- Long breaks after 4 pomodoros
- Focus mode with minimal distraction UI

## Technical Stack

- **Framework:** Flutter (Stable channel)
- **State Management:** Riverpod
- **Local Storage:** Hive + SharedPreferences
- **Notifications:** flutter_local_notifications
- **Alarms:** android_alarm_manager_plus
- **UI:** Material Design 3 with custom animations
- **Target:** Android 7.0+ (API 24+)

## Installation

### From Release
1. Download the appropriate APK from [Releases](../../releases)
   - `app-arm64-v8a-release.apk` - For most modern devices (Recommended)
   - `app-armeabi-v7a-release.apk` - For older 32-bit devices
   - `app-x86_64-release.apk` - For emulators/Intel devices
2. Install the APK on your Android device

### Build from Source
```bash
# Clone the repository
git clone https://github.com/imriadh/VisionBreak.git
cd VisionBreak

# Install dependencies
flutter pub get

# Build release APK
flutter build apk --release --split-per-abi
```

The APKs will be available in `build/app/outputs/flutter-apk/`

## Development

### Prerequisites
- Flutter SDK (Stable channel)
- Android SDK 34
- Java 17

### Setup
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Project Structure
```
lib/
├── core/
│   ├── theme/          # App themes and colors
│   ├── utils/          # Utilities and services
│   └── constants/      # App constants
├── features/
│   ├── eye_timer/      # Eye care timer feature
│   ├── sleep/          # Sleep cycle alarm feature
│   └── pomodoro/       # Pomodoro timer feature
└── widgets/            # Reusable widgets
```

## Permissions

The app requires the following permissions:
- **VIBRATE** - For notification vibrations
- **RECEIVE_BOOT_COMPLETED** - To restore alarms after reboot
- **WAKE_LOCK** - To wake device for alarms
- **SCHEDULE_EXACT_ALARM** - For precise alarm timing
- **POST_NOTIFICATIONS** - To show notifications
- **FOREGROUND_SERVICE** - For timer notifications

## APK Size

Target size: < 20MB per APK (with ABI split enabled)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**imriadh** - [GitHub](https://github.com/imriadh)

## Acknowledgments

- Material Design 3 for beautiful UI components
- Flutter team for the amazing framework
- Contributors and testers

---

Made with ❤️ for better wellness and productivity
