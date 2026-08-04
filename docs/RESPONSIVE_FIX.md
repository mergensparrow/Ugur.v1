# Responsive layout fix

This revision aligns the phone UI with the six approved visual mock-ups while
retaining safe responsive behaviour on narrow Android devices.

## Updated areas

- Manrope and Lora are bundled with the app, so typography no longer changes
  with the Android device or manufacturer font set.
- The home discovery panel restores the mock-up proportions: a wider content
  area, taller place cards, four-card rhythm, and larger vertical spacing.
- The featured destination caption has bounded single-line text, preventing the
  previous 1 px vertical overflow.
- The two-column “Другие города” grid uses a fixed safe row extent and compact
  icon/text geometry, preventing the previous 18 px overflow.
- Bottom navigation restores 48 px icon tiles, stronger labels, and the active
  gold indicator used in the approved screens.
- Favorites, requests, notifications, and profile restore the header, card,
  image, row, and type proportions visible in the approved mock-ups.
- Demo availability states now match the approved favourites example: one
  available hotel, one unavailable hotel, and one requiring clarification.
- Widget regression coverage now includes 320, 360, 411, and 480 px
  main-shell widths.

## Verification

Run on a machine with Flutter installed:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

The included GitHub Actions workflow runs the same analyzer, test, and APK
build sequence.
