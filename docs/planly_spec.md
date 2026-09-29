# Planly: Smart Calendar, Events & Reminders (Flutter + Riverpod + Google Calendar)

Planly is a premium personal calendar, event management and reminder app. It brings Google Calendar events, birthdays, anniversaries, meetings, appointments, personal plans, holidays and reminders into one organized experience.
IMPORTANT: Birthdays are just ONE event category. The focus is events, calendar management, reminders and sync. Do not design/build it as a birthday-tracking app.

## Design system
- Mobile portrait 9:16. Theme: modern, minimal, premium. Corners 16-24 px.
- Primary #4361EE, Secondary #8B5CF6, Background #F8FAFF, Text #172033. Font Inter / Plus Jakarta Sans.
- Five-tab bottom nav: Home, Calendar, Events, Reminders, Settings.
- Event categories: Meetings, Birthdays, Anniversaries, Appointments, Personal, Work, Family, Holidays, Travel, Health, Custom. Each gets a distinct icon and color.
- Design reference: Stitch project "Planly Calendar & Reminders" (screenshots in docs/design/). Match that visual style.

## Screens
### Phase 1: Splash, onboarding, Google connection
01 Splash: white bg, centered gradient (blue to purple) calendar logo, name, tagline "Every moment, beautifully planned." Logo scale+fade animation, small loader while initializing local storage and checking auth.
02 Onboarding "Your life, beautifully organized." Calendar illustration with meeting/travel/birthday/reminder icons floating. Dots, Skip, Continue.
03 Onboarding "All your calendars. One place." Overlapping Personal/Work/Family/Google Calendar cards, card-stacking animation.
04 Onboarding "Stay ahead of every event." Three floating notifications (meeting in 30 min, doctor tomorrow, birthday this weekend). Get Started button.
05 Google Sign-In: "Connect your Google account", Continue with Google, Continue without Google. Loading, cancel and error states.
06 Calendar Permissions: "Your calendar, your control." Explain read + create/edit permissions. Allow Calendar Access / Not Now. Privacy note.
07 Select Calendars: cards with real Google Calendar colors, checkboxes, Select All, Continue, search field.
08 Initial Sync: real stages (connecting, fetching calendars, importing events, categorizing, preparing notifications) with REAL counts, never fabricated percentages.
09 Setup Complete: animated checkmark + subtle confetti, "Your calendar is ready!", real imported counts, Explore My Planner.
### Phase 2: Home and daily planning
10 Home Dashboard: greeting, date, avatar, notification icon; 7-day date selector; summary card (today's events, pending reminders, next event); Sync Calendar control with last-sync time; color-coded timeline; compact Upcoming.
11 Home Quick Actions: FAB + morphs to X, dimmed backdrop; Create Event, Create Reminder, Add Birthday/Anniversary, Add Category; tap outside dismisses.
12 Today's Timeline: hourly markers, live current-time line, timed blocks, separate all-day section, tap to open, long-press actions. No artificial times for all-day birthdays/holidays.
13 Upcoming Events: grouped Today/Tomorrow/This Week/Later; title, time, category icon, calendar color, location; filter chips All/Work/Personal/Birthdays/etc.
14 Daily Summary: totals, completed reminders, next event, free periods, important dates; progress rings computed locally from real data.
### Phase 3: Calendar
15 Month view: month/year header, arrows, Today, Month/Week/Day/Agenda selector, grid with event dots, animated selected date, list below, horizontal swipe.
16 Week view: seven columns, fixed all-day area, hourly grid, positioned blocks, overlaps in different colors, swipe between weeks.
17 Day view: time labels, moving current-time indicator, all-day above, tap empty slot opens Create Event with date/time preselected.
18 Agenda view: grouped chronological list, sticky date headers, badges, time ranges, filters, windowed loading.
19 Calendar Filters: draggable bottom sheet, calendars and categories separately, visibility switches, Select All/Reset/Apply, live update.
### Phase 4: Event management
20 All Events: "My Events", search, filter; tabs Upcoming/Past/All; cards with category, time, calendar, sync status; FAB; staggered entrance.
21 Event Categories: two-column grid with icon, tint, real event count; opens filtered list.
22 Create Event: title, description, category, start/end date+time, all-day toggle, location, recurrence, calendar selector, notifications; inline validation; sticky button. Save to Google when calendar is writable and connected.
23 Category Picker: searchable chips, selected has colored border + check; Create Custom Category (name, icon, color).
24 Event Details: category-colored header; date, time, calendar, location, description, recurrence, attendees; Edit, Delete, Add Reminder; discreet sync status.
25 Edit Event: prefilled; unsaved-change detection; sticky Save with loading/success; read-only events disable editing and explain why.
26 Delete Confirmation: bottom sheet; recurring: This occurrence / Entire series; Cancel/Delete; Undo where possible.
27 Recurrence Setup: Does Not Repeat, Daily, Weekly, Monthly, Yearly, Custom (interval, weekdays, end date); human-readable preview.
### Phase 5: Reminders and notifications
28 Reminders Dashboard: tabs Today/Upcoming/Completed/All; checkbox, title, date/time, priority, sync status; check animation + haptic; FAB.
29 Create Reminder: title, notes, date, time, category, priority, recurrence, lead time, Google Calendar sync toggle (synced reminders are represented as calendar events).
30 Reminder Details: title, notes, due, repeat, notification time, status, sync; Complete, Edit, Snooze, Delete.
31 Notification Preferences: master toggle, default event alert, birthday alert, reminder alert, daily summary, quiet hours; explain OS permission limits.
32 Reminder Alert Selection: At event time, 5m, 15m, 30m, 1h, 1d, Custom; preview text.
33 Notification Center: tabs Upcoming/Recent/Sync; swipe to dismiss; Mark All Read.
### Phase 6: Birthdays and special occasions (as event categories)
34 Birthday Events: filtered category view (NOT a bottom-nav tab), "Birthdays & Celebrations", groups Today/This Week/This Month/Later, subtle celebratory accent.
35 Birthday/Event Details: name, date, next occurrence, source calendar, reminder prefs; Set Reminder, View in Calendar; only supported edits.
36 Add Birthday/Anniversary: name, date, type, optional year, annual repeat, calendar, reminder prefs. Never require age/birth year.
37 Special Occasion Reminder: Same Day, 1 Day, 3 Days, 1 Week Before, Custom; local notification, do not alter the Google event unless asked.
### Phase 7: Search, sync, connectivity
38 Global Search: autofocus, filters All/Events/Reminders/Birthdays/Work/Personal, instant results from local cache grouped by type, recent searches, empty state.
39 Sync Dashboard: Google connection card, account, last successful sync, selected calendars, pending changes, animated Sync Now, real counts (downloaded/created/updated/deleted/failed).
40 Sync In Progress: live stages (Fetching Calendars, Downloading Changes, Uploading Changes, Finalizing), progress only when measurable, safe cancel/background.
41 Sync Successful: green check, "Everything is up to date", last sync time, change summary, Done / View Sync Details.
42 Sync Failed: clear explanation, Try Again, Continue Offline, indicate partial success.
43 Offline Mode: cached data, subtle offline banner, pending count, manual sync when connected; don't imply guaranteed background sync.
44 Google Reconnection: authorization renewal; Reconnect Google / Continue Offline; preserve local data + queued changes.
### Phase 8: Settings
45 Settings Main: profile card; groups Google Account, Calendars, Sync, Notifications, Categories, Appearance, Data & Privacy, About.
46 Google Account: avatar, name, email, status; Manage Calendars, Reconnect, Switch Account, Disconnect; warn on switch (account-specific data isolated).
47 Manage Calendars: color, name, visibility toggle, sync selection; read-only vs writable.
48 Sync Preferences: manual, on app open, pull-to-refresh, permitted background refresh, sync range, last sync; explain platform limits.
49 Category Management: default + custom categories, create/rename/recolor/delete custom; confirm destructive changes.
50 Appearance: Light/Dark/System, live preview, compact/comfortable density, reduced animation; updates immediately via Riverpod.
51 Data and Privacy: local data management, export, import, clear cache, delete local data; distinguish local deletion from Google deletion.
52 About: logo, version, description, Privacy Policy, Terms, Licenses, Google Calendar integration info.
### Phase 9: Supporting screens
53 Empty Calendar ("Your calendar is looking clear."), 54 Empty Reminders ("Nothing to remind you about yet."), 55 No Search Results, 56 Permission Denied (Grant Access / Continue Locally), 57 Account Disconnect Confirmation (Google events remain in Google, local reminders remain, sync stops), 58 Dark Mode (deep navy, accessible contrast, category-colored cards, blue Sync button).

## Interaction behavior (all driven by Riverpod, never fake sync success)
Tap Sync: animated progress + real Google API sync. Pull down calendar: refresh. Tap date: animate + update list. Swipe: navigate day/week/month. Tap event: details. Long-press: contextual actions. Tap +: quick-action menu. Complete reminder: animated check. Change category: instant filter. Change theme: update all screens. Offline changes: queue safely for future sync.

## Architecture (feature-first)
lib/app (app.dart, router.dart, theme/), lib/core (constants, errors, widgets, utils), lib/features (splash, onboarding, auth, home, calendar, events, categories, reminders, notifications, search, sync, settings), lib/data (local, google, repositories), lib/services (calendar_sync_service.dart, notification_service.dart).
Use flutter_riverpod, go_router, Drift/SQLite, Google auth + separate Calendar authorization, Google Calendar API, flutter_local_notifications.

## Technical requirements
- Use Google Calendar's real event type to recognize birthdays; a calendar named "Birthdays" does not guarantee every event is a birthday or editable.
- Google-generated birthday calendars, subscribed calendars and holidays may be read-only: display but restrict edits.
- Identify synced events by Google account + calendar ID + event ID.
- Incremental sync tokens where supported; handle invalidated tokens, recurring-event exceptions; keep deletion tombstones and pending operations.
- Google Sign-In alone does not grant Calendar access; request Calendar authorization separately.
- Note OAuth consent/verification requirements before public release.
- Keep local reminder completion state separate from Google event data unless explicitly mapped.
- Offline reminders and notifications must work without Google connectivity.
