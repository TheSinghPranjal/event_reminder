/// Built-in categories seeded on first launch. Order here is display order.
///
/// Users add their own categories on top of these (the spec's "Custom").
const defaultCategories =
    <({String slug, String name, String iconKey, int color})>[
      (
        slug: 'meetings',
        name: 'Meetings',
        iconKey: 'meetings',
        color: 0xFF4361EE,
      ),
      (
        slug: 'birthdays',
        name: 'Birthdays',
        iconKey: 'birthdays',
        color: 0xFFEC4899,
      ),
      (
        slug: 'anniversaries',
        name: 'Anniversaries',
        iconKey: 'anniversaries',
        color: 0xFFE11D48,
      ),
      (
        slug: 'appointments',
        name: 'Appointments',
        iconKey: 'appointments',
        color: 0xFF0EA5E9,
      ),
      (
        slug: 'personal',
        name: 'Personal',
        iconKey: 'personal',
        color: 0xFF8B5CF6,
      ),
      (slug: 'work', name: 'Work', iconKey: 'work', color: 0xFF334155),
      (slug: 'family', name: 'Family', iconKey: 'family', color: 0xFFF97316),
      (
        slug: 'holidays',
        name: 'Holidays',
        iconKey: 'holidays',
        color: 0xFF10B981,
      ),
      (slug: 'travel', name: 'Travel', iconKey: 'travel', color: 0xFF06B6D4),
      (slug: 'health', name: 'Health', iconKey: 'health', color: 0xFF22C55E),
    ];
