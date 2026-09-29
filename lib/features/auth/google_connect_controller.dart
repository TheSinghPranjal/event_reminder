import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/google/google_models.dart';
import '../../data/providers.dart';

enum ConnectStatus { idle, working, cancelled, failed }

class ConnectState {
  const ConnectState(this.status, {this.message});

  final ConnectStatus status;
  final String? message;

  bool get isWorking => status == ConnectStatus.working;
}

/// Drives "Continue with Google" and the separate Calendar authorization.
class GoogleConnectController extends Notifier<ConnectState> {
  GoogleAccountInfo? _account;

  @override
  ConnectState build() => const ConnectState(ConnectStatus.idle);

  /// Returns true when an account is connected.
  Future<bool> signIn() async {
    if (state.isWorking) return false;
    state = const ConnectState(ConnectStatus.working);
    try {
      final account = await ref.read(googleAuthServiceProvider).signIn();
      if (account == null) {
        state = const ConnectState(
          ConnectStatus.cancelled,
          message: 'Sign-in was cancelled. You can try again any time.',
        );
        return false;
      }
      await ref.read(accountRepositoryProvider).connect(account);
      await ref.read(settingsRepositoryProvider).markOnboardingCompleted();
      _account = account;
      state = const ConnectState(ConnectStatus.idle);
      return true;
    } on GoogleApiException catch (e) {
      state = ConnectState(ConnectStatus.failed, message: e.message);
    } catch (_) {
      state = const ConnectState(
        ConnectStatus.failed,
        message: 'Couldn\'t reach Google. Check your connection and try again.',
      );
    }
    return false;
  }

  /// Asks for Calendar scopes. Returns whether access was granted.
  Future<bool> requestCalendarAccess() async {
    if (state.isWorking) return false;
    state = const ConnectState(ConnectStatus.working);
    try {
      final account = _account ?? await _activeAccountInfo();
      if (account == null) {
        state = const ConnectState(
          ConnectStatus.failed,
          message: 'Connect a Google account first.',
        );
        return false;
      }
      final granted = await ref
          .read(googleAuthServiceProvider)
          .requestCalendarAccess(account);
      await ref
          .read(accountRepositoryProvider)
          .setCalendarAccess(account.id, granted: granted);
      state = granted
          ? const ConnectState(ConnectStatus.idle)
          : const ConnectState(
              ConnectStatus.cancelled,
              message:
                  'Calendar access wasn\'t granted. Planly can still work '
                  'with local events and reminders.',
            );
      return granted;
    } on GoogleApiException catch (e) {
      state = ConnectState(ConnectStatus.failed, message: e.message);
      return false;
    }
  }

  Future<GoogleAccountInfo?> _activeAccountInfo() async {
    final row = await ref.read(accountRepositoryProvider).watchActive().first;
    if (row == null) return null;
    return GoogleAccountInfo(
      id: row.id,
      email: row.email,
      displayName: row.displayName,
      photoUrl: row.photoUrl,
      isStub: row.isStub,
    );
  }

  /// "Continue without Google": finish onboarding locally.
  Future<void> skip() =>
      ref.read(settingsRepositoryProvider).markOnboardingCompleted();
}

final googleConnectControllerProvider =
    NotifierProvider.autoDispose<GoogleConnectController, ConnectState>(
      GoogleConnectController.new,
    );
