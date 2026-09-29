import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Five-tab scaffold. Each tab keeps its own navigation stack.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month_rounded),
      label: 'Calendar',
    ),
    NavigationDestination(
      icon: Icon(Icons.event_note_outlined),
      selectedIcon: Icon(Icons.event_note_rounded),
      label: 'Events',
    ),
    NavigationDestination(
      icon: Icon(Icons.notifications_none_rounded),
      selectedIcon: Icon(Icons.notifications_rounded),
      label: 'Reminders',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: scheme.outline)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          destinations: _destinations,
          // Re-tapping the active tab pops it back to its root.
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }
}
