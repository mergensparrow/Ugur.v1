#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK не найден. Установите Flutter stable или используйте GitHub Actions."
  exit 1
fi

flutter create \
  --platforms=android \
  --org tm.ugur \
  --project-name ugur \
  .

flutter pub get

echo "Android-платформа подготовлена."
