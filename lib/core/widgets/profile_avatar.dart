import 'package:flutter/material.dart';

import '../../data/local/app_database.dart';

/// Avatar for a linked Google account (or a generic person icon).
///
/// Uses [NetworkImage] when [LinkedAccount.photoUrl] is present and the
/// account is not a stub. Image load failures fall back to initials / icon so
/// widget tests (no network) stay green.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.account,
    this.radius = 19,
    this.onTap,
  });

  final LinkedAccount? account;
  final double radius;
  final VoidCallback? onTap;

  static String? initialsOf(String? displayName) {
    if (displayName == null) return null;
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;
    if (parts.length == 1) {
      final s = parts.first;
      return s.substring(0, s.length.clamp(0, 2)).toUpperCase();
    }
    return ('${parts.first[0]}${parts.last[0]}').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final photoUrl = account != null && !account!.isStub
        ? account!.photoUrl
        : null;
    final initials = initialsOf(account?.displayName);

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primary,
      foregroundColor: Colors.white,
      backgroundImage: photoUrl != null && photoUrl.isNotEmpty
          ? NetworkImage(photoUrl)
          : null,
      onBackgroundImageError: photoUrl != null ? (_, _) {} : null,
      child: photoUrl != null && photoUrl.isNotEmpty
          ? null
          : initials != null
          ? Text(
              initials,
              style: TextStyle(
                fontSize: radius * 0.75,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            )
          : Icon(Icons.person_outline_rounded, size: radius * 1.15),
    );

    if (onTap == null) return avatar;
    return Semantics(
      button: true,
      label: account == null ? 'Profile' : 'Profile, ${account!.email}',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: avatar,
      ),
    );
  }
}
