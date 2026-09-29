import 'package:flutter/material.dart';

/// Visible label for anything produced by a developer stub, so stub data is
/// never mistaken for real Google data.
class StubNotice extends StatelessWidget {
  const StubNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E);
    return Semantics(
      container: true,
      label: 'Developer stub. $message',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3A2A0A) : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
          ),
        ),
        child: ExcludeSemantics(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.construction_rounded, size: 18, color: fg),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Developer stub · ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: message),
                    ],
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(color: fg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
