import 'google_models.dart';

/// Google identity + Calendar authorization.
///
/// Sign-in alone does not grant Calendar access; [requestCalendarAccess] asks
/// for the Calendar scopes separately.
abstract interface class GoogleAuthService {
  /// True when this implementation is the developer stub.
  bool get isStub;

  /// Returns null when the user cancels. Throws [GoogleApiException] on error.
  Future<GoogleAccountInfo?> signIn();

  /// Returns whether the Calendar scopes were granted.
  Future<bool> requestCalendarAccess(GoogleAccountInfo account);

  Future<void> signOut();
}
