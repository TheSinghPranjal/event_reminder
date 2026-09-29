/// Route paths used with go_router.
abstract final class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';

  // Google connection + first sync flow.
  static const connect = '/connect';
  static const calendarPermission = '/connect/permission';
  static const selectCalendars = '/connect/calendars';
  static const initialSync = '/connect/sync';
  static const setupComplete = '/connect/done';

  // Tabs.
  static const home = '/home';
  static const calendar = '/calendar';
  static const events = '/events';
  static const eventCategories = '/events/categories';
  static const eventNew = '/events/new';
  static String eventDetails(int id) => '/events/$id';
  static String eventEdit(int id) => '/events/$id/edit';
  static const reminders = '/reminders';
  static const settings = '/settings';
  static const settingsCategories = '/settings/categories';
}
