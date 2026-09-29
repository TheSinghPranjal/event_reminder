# Planly (event_reminder)

A Flutter calendar + reminder app with optional Google Sign-In and two-way
Google Calendar sync.

## Getting Started

```bash
flutter pub get
flutter run
```

Without OAuth client IDs the app uses a developer stub for Google Sign-In
(you can walk through onboarding, but event import will honestly fail).

## Google Sign-In & Calendar setup

### 1. Google Cloud Console

1. Create a project (or pick an existing one).
2. Enable the **Google Calendar API**.
3. Configure the **OAuth consent screen** (External). Add yourself as a
   **test user** — Calendar scopes are sensitive, so unverified apps only
   work for listed test users.
4. Create three OAuth clients under **Credentials**:
   - **iOS** — bundle ID `com.thelazybearclub.eventReminder`. Note the
     client ID and the **iOS URL scheme** (reversed client ID,
     `com.googleusercontent.apps.…`).
   - **Android** — package
     `com.the_lazy_bear_club.event_reminder` plus your debug SHA-1:

     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore \
       -alias androiddebugkey -storepass android -keypass android
     ```

     Later, add the release keystore SHA-1 the same way.
   - **Web application** — its client ID is used as
     `GOOGLE_SERVER_CLIENT_ID` (required by `google_sign_in` 7.x on Android).

### 2. Local config files

```bash
cp google_oauth.example.json google_oauth.json
cp ios/Flutter/GoogleOAuth.xcconfig.example ios/Flutter/GoogleOAuth.xcconfig
```

Fill both with your real IDs. Both files are gitignored.

### 3. Run with OAuth

```bash
flutter run --dart-define-from-file=google_oauth.json
```

Or use the **Planly (with Google OAuth)** launch config in
[`.vscode/launch.json`](.vscode/launch.json).

iOS also needs `GoogleOAuth.xcconfig` so `Info.plist` can expand
`GIDClientID` and the reversed URL scheme.

## Architecture notes

- **State:** Riverpod · **Routing:** go_router · **Local DB:** Drift (SQLite)
- Google auth + Calendar live under `lib/data/google/`; sync orchestration in
  `lib/services/calendar_sync_service.dart` and
  `lib/services/event_push_service.dart`.
- See [`docs/planly_spec.md`](docs/planly_spec.md) for the full product spec.
