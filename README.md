# AxisCore

Flutter MVP app shell for the AxisCore 90-day training product.

## What is implemented

- Feature-first Flutter architecture under `lib/src`.
- Riverpod app session state and repository boundaries.
- GoRouter routes for onboarding, result, home, protocol, progress, and reset.
- Local SharedPreferences persistence for profile, assessment, progress, and reset events.
- Deterministic assessment, protocol, progress, and panic/reset engines.
- Widget tests for the first user loop.

## Run locally

```bash
flutter pub get
flutter run
```

## Verify

```bash
flutter analyze
flutter test
flutter build apk --debug
```

## Current scope

This is intentionally local-first. Supabase, RevenueCat, AI coach, push notifications, community pods, and media content are left behind repository/data-source boundaries for future slices.
