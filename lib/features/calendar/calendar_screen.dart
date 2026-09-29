import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';
import '../../core/widgets/planly_header.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PlanlyHeader(title: 'Calendar'),
            Expanded(
              child: EmptyState(
                icon: Icons.calendar_month_rounded,
                title: 'Your calendar is looking clear.',
                message:
                    'Add an event or connect Google Calendar to fill it in.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
