import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';
import '../../core/widgets/planly_header.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PlanlyHeader(title: 'Reminders'),
            Expanded(
              child: EmptyState(
                icon: Icons.notifications_active_rounded,
                title: 'Nothing to remind you about yet.',
                message: 'Reminders you create will appear here.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
