# VisionBreak - Quick Start Guide 🚀

Get VisionBreak up and running in under 5 minutes!

## ⚡ Super Quick Start

### Option 1: Use Pre-built APK (Fastest)
1. Go to [Releases](../../releases)
2. Download `app-arm64-v8a-release.apk`
3. Install on your Android device
4. Done! 🎉

### Option 2: Build from Source (Developers)

```bash
# 1. Clone and navigate
git clone https://github.com/imriadh/VisionBreak.git
cd VisionBreak

# 2. Get dependencies
flutter pub get

# 3. Build APK
flutter build apk --release --split-per-abi

# 4. Find APK in build/app/outputs/flutter-apk/
```

## 🎯 Using the App

### Eye Care Timer 👁️
1. Open the app
2. Tap "Eye Care" in bottom navigation
3. Set your preferred interval (default: 20 minutes)
4. Tap "Start"
5. Notification will alert you when it's time for a break

**Tip**: Follow the 20-20-20 rule - every 20 minutes, look at something 20 feet away for 20 seconds.

### Sleep Cycle Alarm 😴
1. Tap "Sleep" in bottom navigation
2. See suggested wake times based on 90-minute cycles
3. Tap a time to set the alarm
4. Wake up refreshed at the end of a sleep cycle!
5. Rate your sleep quality when you wake up

**Tip**: Waking between cycles feels more refreshing than mid-cycle.

### Pomodoro Timer 🎯
1. Tap "Pomodoro" in bottom navigation
2. Adjust work/break duration if needed
3. Tap "Start" to begin focus session
4. Work until the timer completes
5. Take a break when prompted
6. Track your daily productivity

**Tip**: After 4 pomodoros, you get a longer break!

## 📱 Features at a Glance

| Feature | Duration | Customizable | Notifications |
|---------|----------|--------------|---------------|
| Eye Timer | 15-60 min | ✅ | ✅ |
| Sleep Alarm | 90 min cycles | ❌ | ✅ |
| Pomodoro | 5-60 min | ✅ | ✅ |

## 🛠️ For Developers

### Prerequisites
- Flutter SDK (stable)
- Android SDK 34
- Java 17

### Development Commands
```bash
# Run in debug mode
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

### Project Structure
```
lib/
├── core/          # Shared functionality
├── features/      # Feature modules
│   ├── eye_timer/
│   ├── sleep/
│   └── pomodoro/
└── main.dart
```

## 🔧 Common Issues & Solutions

### "App not installed"
- Enable "Install from Unknown Sources" in Android settings
- Try uninstalling any previous version first

### "Notifications not showing"
- Go to Settings → Apps → VisionBreak → Notifications
- Enable all notification channels

### "Alarm didn't ring"
- Check battery optimization settings
- Allow VisionBreak to run in background
- Grant alarm/notification permissions

## 📚 More Information

- **Full Documentation**: [README.md](README.md)
- **Setup Guide**: [SETUP.md](SETUP.md)
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)

## 🤝 Get Help

- 🐛 Found a bug? [Open an issue](../../issues)
- 💡 Have an idea? [Start a discussion](../../discussions)
- ⭐ Like the app? Give us a star!

## 📊 Stats

- **APK Size**: < 20MB (per ABI)
- **Min Android**: 7.0 (API 24)
- **Target Android**: 14 (API 34)
- **Dependencies**: 12 packages
- **Features**: 3 core features

## ✨ Tips for Best Experience

1. **Grant All Permissions**: For full functionality
2. **Disable Battery Optimization**: Ensures timers work reliably
3. **Keep Notifications On**: Stay aware of breaks and alarms
4. **Use Daily**: Build healthy habits with consistency
5. **Customize Settings**: Adjust timers to your needs

## 🎨 Screenshots

(Add screenshots here in future update)

## 💖 Support the Project

If you find VisionBreak useful:
- ⭐ Star the repository
- 🔄 Share with friends
- 🐛 Report bugs
- 💻 Contribute code
- 📝 Improve documentation

---

**Ready to start?** Download from [Releases](../../releases) or build from source!

Made with ❤️ for better wellness and productivity ✨
