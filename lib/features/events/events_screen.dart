import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/planly_header.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlanlyHeader(title: 'My Events'),
            Expanded(
              child: EmptyState(
                icon: Icons.event_note_rounded,
                title: 'No events yet',
                message:
                    'Your meetings, birthdays, trips and plans will live here.',
                action: OutlinedButton.icon(
                  onPressed: () => context.go(Routes.eventCategories),
                  icon: const Icon(Icons.grid_view_rounded),
                  label: const Text('Browse categories'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
