import 'package:flutter/foundation.dart';

/// OAuth client IDs, passed at build time:
///
/// ```
/// flutter run \
///   --dart-define=GOOGLE_IOS_CLIENT_ID=<ios-client-id>.apps.googleusercontent.com \
///   --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>.apps.googleusercontent.com
/// ```
///
/// When the IDs a platform needs are missing, the app falls back to the
/// developer stub (which never fakes a successful sync).
abstract final class GoogleConfig {
  static const iosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
  static const serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  /// List calendars (readonly) and create/update/delete events.
  static const calendarScopes = [
    'https://www.googleapis.com/auth/calendar.readonly',
    'https://www.googleapis.com/auth/calendar.events',
  ];


  static bool get isConfigured {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => iosClientId.isNotEmpty,
      TargetPlatform.android => serverClientId.isNotEmpty,
      _ => false,
    };
  }

  static String? get clientId => switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => iosClientId,
    _ => null,
  };
}
