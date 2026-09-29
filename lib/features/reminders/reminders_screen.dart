import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: const EmptyState(
        icon: Icons.notifications_active_rounded,
        title: 'Nothing to remind you about yet.',
        message: 'Reminders you create will appear here.',
      ),
    );
  }
}
