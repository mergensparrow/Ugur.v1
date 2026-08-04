# Ugur Stage 8

Version: **1.5.5+12**

Stage 8 is a compact-phone density pass against the six approved main-tab mock-ups. No product flow or approved composition was replaced.

## Corrected

- Reduced oversized phone typography, cards and vertical gaps on Home, Favorites, Requests, Notifications and Profile.
- Reduced the rounded-square bottom navigation while preserving comfortable tap targets.
- Tightened the Home city-discovery panel and increased the visible rhythm of the popular-place carousel.
- Rebalanced Popular destinations captions and Other cities tiles to prevent compact Android overflows.
- Reduced Favorites header, filter bar, hotel cards and operator action density.
- Reduced Requests header, active progress card, chips, progress nodes and completed cards so the approved content hierarchy fits before the bottom navigation.
- Kept Notifications title on one line and tightened tabs and rows.
- Reduced Profile header, user card, settings rows and section spacing for closer mock-up fidelity.

## Preserved

- Stage 7 navy/gold/white visual language.
- All Stage 6 authentication, city, place, catalog, hotel, favorites, requests, notifications and profile behavior.
- Guest and registered profile variants.
- Fixed bottom navigation and existing persistence.

## Verification

Run on a Flutter machine:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```
