import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String greetingFor(DateTime now) {
    final hour = now.hour;
    if (hour < 5) return 'Good evening';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM').format(now),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(greetingFor(now), style: theme.textTheme.headlineMedium),
                ],
              ),
            ),
            const Expanded(
              child: EmptyState(
                icon: Icons.wb_sunny_rounded,
                title: 'Your day is wide open',
                message: 'Events and reminders for today will show up here.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
