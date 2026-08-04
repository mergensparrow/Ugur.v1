#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parents[1]

required = [
    'pubspec.yaml',
    'lib/main.dart',
    'lib/screens/welcome_screen.dart',
    'lib/screens/login_screen.dart',
    'lib/screens/register_screen.dart',
    'lib/screens/reviews_screen.dart',
    'lib/data/app_state.dart',
    'lib/screens/home_screen.dart',
    'lib/screens/city_picker_screen.dart',
    'lib/screens/place_detail_screen.dart',
    'lib/screens/hotel_catalog_screen.dart',
    'lib/screens/hotel_detail_screen.dart',
    'lib/screens/room_prices_screen.dart',
    'lib/screens/availability_request_screen.dart',
    'lib/screens/favorites_screen.dart',
    'lib/screens/notifications_screen.dart',
    'lib/screens/profile_screen.dart',
    'lib/screens/personal_profile_screen.dart',
    'lib/screens/edit_profile_screen.dart',
    'lib/screens/language_screen.dart',
    'lib/screens/notification_settings_screen.dart',
    'lib/screens/support_screen.dart',
    'lib/screens/privacy_screen.dart',
    'lib/screens/ui_settings_screen.dart',
    '.github/workflows/android.yml',
    '.github/workflows/deploy-web.yml',
    '.gitignore',
    'assets/images/place_alem.jpg',
    'assets/images/place_monument.jpg',
    'assets/images/place_arch.jpg',
    'assets/images/place_park.jpg',
    'DESIGN_LOCK.json',
    'docs/STAGE17_REPORT.md',
    'docs/STAGE18A_REPORT.md',
    'docs/GITHUB_UPLOAD.md',
]

forbidden = [
    'views',
    'package.json',
    'package-lock.json',
    'server.js',
    'app.js',
    'index.js',
    '.github/workflows/build-apk.yml',
    '.github/workflows/stale.yml',
]

errors: list[str] = []

for rel in required:
    if not (root / rel).exists():
        errors.append(f'missing: {rel}')

for rel in forbidden:
    if (root / rel).exists():
        errors.append(f'legacy file/folder must be removed: {rel}')

for legacy_template in root.rglob('*.ejs'):
    errors.append(f'legacy EJS template must be removed: {legacy_template.relative_to(root)}')

for dart in root.glob('lib/**/*.dart'):
    text = dart.read_text(encoding='utf-8')
    for match in re.finditer(r"import\s+'([^']+)';", text):
        target = match.group(1)
        if target.startswith('package:') or target.startswith('dart:'):
            continue
        resolved = (dart.parent / target).resolve()
        if not resolved.exists():
            errors.append(f'broken import: {dart.relative_to(root)} -> {target}')

pubspec_path = root / 'pubspec.yaml'
if pubspec_path.exists():
    pubspec = pubspec_path.read_text(encoding='utf-8')
    if 'version: 1.6.1+20' not in pubspec:
        errors.append('pubspec version must be 1.6.1+20')

android_path = root / '.github/workflows/android.yml'
if android_path.exists():
    android = android_path.read_text(encoding='utf-8')
    for phrase in [
        'python3 tool/validate_project.py',
        'ugur-v1.6.1-build20-debug-apk',
        'ugur-v1.6.1-build20-debug.apk',
    ]:
        if phrase not in android:
            errors.append(f'android workflow missing: {phrase}')

web_path = root / '.github/workflows/deploy-web.yml'
if web_path.exists():
    web = web_path.read_text(encoding='utf-8')
    for phrase in [
        'python3 tool/validate_project.py',
        'GITHUB_REPOSITORY#*/',
        'flutter test',
        'actions/deploy-pages@v4',
    ]:
        if phrase not in web:
            errors.append(f'web workflow missing: {phrase}')

lock_path = root / 'DESIGN_LOCK.json'
if lock_path.exists():
    try:
        lock = json.loads(lock_path.read_text(encoding='utf-8'))
    except json.JSONDecodeError as exc:
        errors.append(f'invalid DESIGN_LOCK.json: {exc}')
    else:
        lock_text = json.dumps(lock, ensure_ascii=False)
        for phrase in [
            'room_prices',
            'availability_request',
            'personal_profile',
            'place_detail',
            'dynamic city-specific hotels and places',
            'stage6_scope',
            'in-catalog review modal',
            'ui_settings',
            'mobile Safari and GitHub Pages viewport correction',
            'hidden five-tap designer panel',
            'copyable JSON export',
            'stage18a_scope',
            'no changes to lib Dart files',
        ]:
            if phrase not in lock_text:
                errors.append(f'design lock missing: {phrase}')
        if lock.get('current_stage') != 'stage18a':
            errors.append('DESIGN_LOCK current_stage must be stage18a')
        if lock.get('do_not_change_without_owner_approval') is not True:
            errors.append('design lock approval protection must remain enabled')

if errors:
    print('VALIDATION FAILED')
    for error in errors:
        print('-', error)
    sys.exit(1)

print('VALIDATION OK')
print('Stage: 18A')
print('Version: 1.6.1+20')
print('Dart files:', len(list(root.glob('lib/**/*.dart'))))
print('Legacy Node/EJS files: none')
