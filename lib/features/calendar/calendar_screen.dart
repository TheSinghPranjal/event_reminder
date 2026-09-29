import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const EmptyState(
        icon: Icons.calendar_month_rounded,
        title: 'Your calendar is looking clear.',
        message: 'Add an event or connect Google Calendar to fill it in.',
      ),
    );
  }
}
