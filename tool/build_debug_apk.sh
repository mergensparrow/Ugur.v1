#!/usr/bin/env bash
set -euo pipefail

./tool/prepare_android.sh
flutter analyze
flutter test
flutter build apk --debug

echo "APK: build/app/outputs/flutter-apk/app-debug.apk"
