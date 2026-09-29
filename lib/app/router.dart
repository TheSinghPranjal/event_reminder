import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/calendar_permission_screen.dart';
import '../features/auth/connect_google_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/categories/presentation/categories_screen.dart';
import '../features/events/event_details_screen.dart';
import '../features/events/event_editor_screen.dart';
import '../features/events/events_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/reminders/reminders_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/sync/presentation/initial_sync_screen.dart';
import '../features/sync/presentation/select_calendars_screen.dart';
import '../features/sync/presentation/setup_complete_screen.dart';
import 'routes.dart';
import 'shell/app_shell.dart';

/// Where the app starts. Tests override this to skip the splash.
final initialLocationProvider = Provider<String>((ref) => Routes.splash);

GoRoute _route(String path, Widget screen) =>
    GoRoute(path: path, builder: (context, state) => screen);

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: ref.watch(initialLocationProvider),
    routes: [
      _route(Routes.splash, const SplashScreen()),
      _route(Routes.onboarding, const OnboardingScreen()),
      _route(Routes.connect, const ConnectGoogleScreen()),
      _route(Routes.calendarPermission, const CalendarPermissionScreen()),
      _route(Routes.selectCalendars, const SelectCalendarsScreen()),
      _route(Routes.initialSync, const InitialSyncScreen()),
      _route(Routes.setupComplete, const SetupCompleteScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [_route(Routes.home, const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [_route(Routes.calendar, const CalendarScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.events,
                builder: (context, state) => const EventsScreen(),
                routes: [
                  _route('categories', const CategoriesScreen()),
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const EventEditorScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return EventDetailsScreen(eventId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final id = int.parse(state.pathParameters['id']!);
                          return EventEditorScreen(eventId: id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [_route(Routes.reminders, const RemindersScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [_route('categories', const CategoriesScreen())],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
  ref.onDispose(router.dispose);
  return router;
});
