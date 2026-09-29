import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Icons.category_rounded),
              title: const Text('Categories'),
              subtitle: const Text('Default and custom event categories'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.go(Routes.settingsCategories),
            ),
          ),
        ],
      ),
    );
  }
}
