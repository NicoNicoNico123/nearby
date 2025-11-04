# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Nearby** is a Flutter-based social dining app for location-based meal discovery and group coordination. Users can find nearby people for dining, create groups with specific intents, chat in real-time, and manage profiles with privacy controls.

## Development Commands

### Essential Commands
```bash
# Development
flutter run                    # Run app in debug mode
flutter run --release         # Run in release mode
flutter run --profile         # Run with profiling

# Code Quality
flutter analyze               # Static analysis
flutter format                # Format code
flutter test                 # Run unit tests
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies

# Platform Builds
flutter build apk           # Android APK
flutter build appbundle      # Android App Bundle
flutter build ios            # iOS app (requires Xcode)
flutter build web            # Web app
```

### Testing
```bash
flutter test                          # Run all tests
flutter test test/widget_test.dart    # Run specific test file
flutter test --coverage              # Run with coverage
```

## Architecture

### Tech Stack
- **Framework**: Flutter (SDK 3.9.2+)
- **Language**: Dart
- **State Management**: Default Flutter state management (currently)
- **Platforms**: iOS, Android, Web

### Project Structure
```
lib/
├── main.dart              # Entry point (replace default template)
├── (feature modules)      # To be implemented
├── (shared widgets)       # To be implemented
├── (models)              # To be implemented
├── (services)            # To be implemented
└── (utils)               # To be implemented
```

### Key Features to Implement
- Location-based user discovery
- Group creation and management
- Real-time chat system
- Profile management with privacy controls
- Points-based virtual economy
- QR code check-in system

## Development Guidelines

### Code Style Requirements
1. **Dark Theme**: Must use unified dark theme - no hard-coded style values
2. **Responsive Design**: Use flex layouts, avoid fixed sizes
3. **Logging**: Use `log` from `dart:developer` instead of `print`
4. **Widget Architecture**: Prefer small composable widgets over large ones
5. **Theme Constants**: All styles must use theme constants

### File Organization
- Proper separation of concerns
- Feature-based module structure
- Shared widgets and utilities
- Clear model definitions

## Key Resources

### UI Reference Screens
Location: `UI reference/` directory - comprehensive design specifications for all app screens including:
- Discover page and feed
- Group info and messaging
- Settings and user profile
- Welcome/onboarding screens

### Product Specifications
Location: `specs/initial-requirements.md` - detailed feature requirements, user stories, and technical specifications.

### Configuration Files
- `pubspec.yaml`: Main project configuration and dependencies
- `analysis_options.yaml`: Code linting with flutter_lints
- `.gitignore`: Version control exclusions

## Development Status

**Current State**: Early development with default Flutter template scaffold. UI designs and specifications are complete and ready for implementation.

**Next Steps**:
1. Replace main.dart with actual app structure
2. Implement theming system (dark theme required)
3. Set up feature-based folder structure
4. Implement core features based on UI references
5. Set up backend integration

## Testing Strategy

- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Use `flutter test` for comprehensive testing

## Environment Notes

- Flutter SDK 3.35.5 (stable) installed
- Android development tools available
- iOS development possible (Xcode available but simulator has issues)
- Multiple deployment targets available