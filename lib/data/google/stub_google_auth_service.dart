import 'google_auth_service.dart';
import 'google_models.dart';

/// DEVELOPER STUB: stands in for Google Sign-In until OAuth is configured.
///
/// It returns an account explicitly marked as a stub. It never talks to
/// Google and the UI labels everything it produces.
class StubGoogleAuthService implements GoogleAuthService {
  const StubGoogleAuthService({
    this.latency = const Duration(milliseconds: 700),
  });

  final Duration latency;

  static const account = GoogleAccountInfo(
    id: 'stub-account',
    email: 'stub@planly.invalid',
    displayName: 'Stub account',
    isStub: true,
  );

  @override
  bool get isStub => true;

  @override
  Future<GoogleAccountInfo?> signIn() async {
    await Future<void>.delayed(latency);
    return account;
  }

  @override
  Future<bool> requestCalendarAccess(GoogleAccountInfo account) async {
    await Future<void>.delayed(latency);
    return true;
  }

  @override
  Future<void> signOut() async {}
}
