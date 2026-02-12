# VisionBreak Architecture Documentation

## Overview

VisionBreak follows **Clean Architecture** principles with a feature-based folder structure. The app is built using Flutter with Riverpod for state management.

## Project Structure

```
lib/
├── core/                   # Core functionality shared across features
│   ├── theme/             # App themes and styling
│   │   └── app_theme.dart
│   ├── utils/             # Utility classes and services
│   │   ├── notification_service.dart
│   │   └── time_formatter.dart
│   └── constants/         # App-wide constants
│       └── app_constants.dart
│
├── features/              # Feature modules
│   ├── eye_timer/        # Eye Care Timer feature
│   │   ├── presentation/ # UI layer
│   │   │   └── eye_timer_page.dart
│   │   └── providers/    # State management
│   │       └── eye_timer_provider.dart
│   │
│   ├── sleep/            # Sleep Cycle Alarm feature
│   │   ├── models/       # Data models
│   │   │   ├── sleep_record.dart
│   │   │   └── sleep_record.g.dart
│   │   ├── presentation/ # UI layer
│   │   │   └── sleep_page.dart
│   │   └── providers/    # State management
│   │       └── sleep_provider.dart
│   │
│   └── pomodoro/         # Pomodoro Timer feature
│       ├── presentation/ # UI layer
│       │   └── pomodoro_page.dart
│       └── providers/    # State management
│           └── pomodoro_provider.dart
│
├── widgets/              # Reusable widgets (future)
└── main.dart            # App entry point
```

## Architecture Patterns

### State Management - Riverpod

Each feature uses **StateNotifier** with **Riverpod** for state management:

```dart
// State class
class FeatureState {
  final Data data;
  final Status status;
  
  FeatureState({required this.data, required this.status});
  
  FeatureState copyWith({Data? data, Status? status}) {
    return FeatureState(
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }
}

// Notifier class
class FeatureNotifier extends StateNotifier<FeatureState> {
  FeatureNotifier() : super(FeatureState(...));
  
  void updateData(Data newData) {
    state = state.copyWith(data: newData);
  }
}

// Provider
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier(),
);
```

### Data Persistence

- **SharedPreferences**: Simple key-value storage for settings
- **Hive**: NoSQL database for structured data (sleep records)

### Notifications

Centralized notification service using `flutter_local_notifications`:
- Separate channels for each feature
- Custom actions (pause, resume, stop)
- Persistent notifications for active timers

## Core Components

### 1. Theme System

**Location**: `lib/core/theme/app_theme.dart`

Features:
- Material Design 3
- Light and Dark themes
- Custom color schemes
- Gradient definitions
- Typography system

```dart
// Usage
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
)
```

### 2. Notification Service

**Location**: `lib/core/utils/notification_service.dart`

Responsibilities:
- Initialize notification channels
- Show/cancel notifications
- Handle notification actions
- Manage foreground services

```dart
// Usage
await NotificationService().initialize();
await NotificationService().showEyeTimerNotification(
  title: 'Eye Break',
  body: 'Time to rest your eyes',
);
```

### 3. Time Formatter

**Location**: `lib/core/utils/time_formatter.dart`

Utility functions for formatting time:
- Duration to MM:SS
- DateTime to HH:MM
- 12-hour format with AM/PM

## Feature Details

### Eye Care Timer

**Purpose**: Reminds users to take breaks using the 20-20-20 rule

**Components**:
- `EyeTimerState`: Holds timer state
- `EyeTimerNotifier`: Manages timer logic
- `EyeTimerPage`: UI with circular progress

**Flow**:
1. User sets interval (15-60 minutes)
2. Starts timer
3. Countdown with visual progress
4. Notification at completion
5. Auto-resets for next cycle

### Sleep Cycle Alarm

**Purpose**: Calculates optimal wake times based on 90-minute cycles

**Components**:
- `SleepRecord`: Model for sleep data
- `SleepState`: Holds suggested times and records
- `SleepNotifier`: Calculates cycles and manages alarms
- `SleepPage`: UI with wake time suggestions

**Flow**:
1. App calculates wake times from current time
2. User selects desired wake time
3. Native alarm is scheduled
4. User rates sleep quality after waking
5. Record is saved to history

### Pomodoro Timer

**Purpose**: Productivity timer with work/break cycles

**Components**:
- `PomodoroState`: Timer state and stats
- `PomodoroNotifier`: Phase management
- `PomodoroPage`: UI with controls

**Flow**:
1. User starts work session (25 min default)
2. Timer counts down
3. Break session starts after completion
4. Long break after 4 pomodoros
5. Stats updated in real-time

## Design Patterns

### 1. State Pattern
Each feature has distinct states (idle, running, paused)

### 2. Observer Pattern
Riverpod providers notify UI of state changes

### 3. Singleton Pattern
Services like NotificationService use singleton instance

### 4. Factory Pattern
Hive adapters for data serialization

## Data Flow

```
User Action → UI → Provider → State Update → UI Rebuild
                      ↓
                  Side Effects
                  (Notification, Storage, etc.)
```

## Performance Optimizations

### 1. Widget Optimization
- `const` constructors wherever possible
- `ConsumerWidget` for selective rebuilds
- Efficient list rendering

### 2. Build Optimization
- ABI split for smaller APKs
- R8 code shrinking
- ProGuard rules for unused code removal
- Asset optimization

### 3. Memory Management
- Timer cleanup in dispose()
- Lazy initialization of services
- Efficient state updates with copyWith

## Testing Strategy

### Unit Tests
- Provider logic
- State transformations
- Utility functions

### Widget Tests
- UI rendering
- User interactions
- Navigation

### Integration Tests
- Feature flows
- Notification delivery
- Data persistence

## Security Considerations

### Permissions
Minimal permissions requested:
- Notifications (for alerts)
- Alarms (for wake-up)
- Foreground service (for active timers)

### Data Privacy
- All data stored locally
- No network requests
- No analytics or tracking
- No personal information collected

## Future Enhancements

### Planned Features
1. **Statistics Dashboard**
   - Weekly/monthly charts
   - Streak tracking
   - Goal setting

2. **Customization**
   - Custom notification sounds
   - Theme customization
   - Timer presets

3. **Widgets**
   - Home screen widgets
   - Lock screen timer

4. **Cloud Sync** (optional)
   - Backup/restore
   - Multi-device sync

5. **Smart Features**
   - Adaptive suggestions
   - Usage patterns analysis
   - Break reminders based on screen time

## Contributing

When adding new features:
1. Follow the existing architecture
2. Create new feature folder in `features/`
3. Implement state with Riverpod
4. Add tests
5. Update documentation

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Android Notifications Guide](https://developer.android.com/develop/ui/views/notifications)

---

Last Updated: 2026-02-12
