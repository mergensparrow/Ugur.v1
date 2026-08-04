# Ugur Stage 7

Version: **1.5.0+7**

Stage 7 is the visual fidelity pass for the five main application tabs. The working Stage 6 flows are retained.

## Implemented

- Home upper section rebuilt around the approved navy/gold premium reference.
- Fixed Ugur brand header with working notification badge.
- Unified city selector, dynamic popular places and hotel search block.
- Home lower section rebuilt with a large featured destination, secondary cards and two-column city tiles.
- New five-item rounded-square bottom navigation with navy/gold selected state.
- Favorites redesigned with decorative header, filter tabs, status-rich hotel cards and operator action.
- Requests redesigned with segmented filters, active request progress tracker and completed request cards.
- Notifications redesigned with grouped cards, unread indicators, read-all action and retained clear action.
- Profile redesigned for both registered and guest modes with premium cards and settings sections.

## Preserved from Stage 6

- Authentication, registration and guest flows.
- Persistent user profile.
- Dynamic city-specific places and hotels.
- Popular place details and nearby hotels.
- Catalog filters and review modal.
- Persistent hotel favorites.
- Notification read and clear state.
- Hotel detail actions and availability request workflow.

## Build note

The project is a Flutter source archive. Build the Android APK through the existing GitHub Actions workflow after changing the archive filename to `ugur_flutter_v1_stage7.zip`.
