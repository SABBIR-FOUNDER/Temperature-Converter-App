# Temperature Converter

A lightweight Flutter application that converts temperatures between Celsius and Fahrenheit.

## Features

- Celsius to Fahrenheit conversion.
- Fahrenheit to Celsius conversion.
- Accepts positive, negative, and decimal values.
- Validates empty and malformed input.
- Displays results to two decimal places with the correct unit.
- Material Design 3 interface with a responsive, mobile-first layout.
- No backend, database, internet connection, or third-party runtime packages required.

## Technology

- Flutter
- Dart
- Material Design 3
- `flutter_test` for unit and widget tests

## Requirements

- Flutter SDK (stable channel)
- Android Studio or VS Code with Flutter/Dart extensions
- Android SDK and an Android emulator or physical Android device

## Run the app

From the project root:

```bash
flutter pub get
flutter run
```

## Run tests and static analysis

```bash
flutter test
flutter analyze
```

## Build a debug APK

```bash
flutter build apk --debug
```

The APK is created at `build/app/outputs/flutter-apk/app-debug.apk`.

## GitHub publishing

Create an empty repository on GitHub, then run these commands from the project root (replace the URL with your repository URL):

```bash
git init
git add .
git commit -m "Initial temperature converter app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/temperature_converter.git
git push -u origin main
```

## Project structure

```text
temperature_converter/
├── android/                 # Android application and Gradle configuration
├── lib/
│   ├── main.dart            # App UI and interaction
│   └── temperature_converter.dart  # Conversion logic
├── test/
│   ├── temperature_converter_test.dart
│   └── widget_test.dart
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```
