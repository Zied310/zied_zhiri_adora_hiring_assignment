# Flutter Location Tracking Assignment
## Overview

This Flutter application demonstrates real-time device location tracking in foreground and background states.

## The project includes:
- Runtime location permission handling
- Foreground location retrieval
- Background location tracking using an Android foreground service
- Persistent notification updates with live coordinates
- Simple UI for enabling/disabling tracking

## Technical Details
- Flutter 3.27.4
- Dart 3.6.2

# Main Packages Used
- geolocator
- flutter_background_service
- flutter_local_notifications

## Background Tracking

Location tracking is implemented using an Android foreground service which continues execution even when the app is removed from recent apps. This allows continuous location updates without requiring the UI process to remain active.

Location updates are retrieved every 10 seconds and displayed through a persistent notification.

## Notes

Due to iOS system limitations, continuous background tracking behavior may differ from Android.
