import 'package:google_sign_in/google_sign_in.dart';

import 'google_auth_service.dart';
import 'google_config.dart';
import 'google_models.dart';

/// Google Sign-In backed by the `google_sign_in` plugin.
class SignInGoogleAuthService implements GoogleAuthService {
  SignInGoogleAuthService({GoogleSignIn? signIn})
    : _signIn = signIn ?? GoogleSignIn.instance;

  final GoogleSignIn _signIn;
  Future<void>? _initialized;
  GoogleSignInAccount? _current;

  Future<void> _ensureInitialized() => _initialized ??= _signIn.initialize(
    clientId: GoogleConfig.clientId,
    serverClientId: GoogleConfig.serverClientId.isEmpty
        ? null
        : GoogleConfig.serverClientId,
  );

  /// The signed-in Google account, restoring a previous session silently.
  Future<GoogleSignInAccount?> currentAccount() async {
    await _ensureInitialized();
    return _current ??= await _signIn.attemptLightweightAuthentication();
  }

  @override
  bool get isStub => false;

  @override
  Future<GoogleAccountInfo?> signIn() async {
    await _ensureInitialized();
    try {
      final account = await _signIn.authenticate(
        scopeHint: GoogleConfig.calendarScopes,
      );
      _current = account;
      return GoogleAccountInfo(
        id: account.id,
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      throw GoogleApiException(_describe(e));
    }
  }

  @override
  Future<bool> requestCalendarAccess(GoogleAccountInfo account) async {
    final user = await currentAccount();
    if (user == null || user.id != account.id) {
      throw const GoogleApiException(
        'Sign in to this Google account again to grant Calendar access.',
      );
    }
    try {
      final existing = await user.authorizationClient.authorizationForScopes(
        GoogleConfig.calendarScopes,
      );
      if (existing != null) return true;
      await user.authorizationClient.authorizeScopes(
        GoogleConfig.calendarScopes,
      );
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return false;
      throw GoogleApiException(_describe(e));
    }
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    _current = null;
    await _signIn.signOut();
  }

  static String _describe(GoogleSignInException e) => switch (e.code) {
    GoogleSignInExceptionCode.clientConfigurationError ||
    GoogleSignInExceptionCode.providerConfigurationError =>
      'Google Sign-In isn\'t configured correctly for this build.',
    _ => 'Couldn\'t reach Google. Check your connection and try again.',
  };
}
