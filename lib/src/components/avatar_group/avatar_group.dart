import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Avatar Group: avatars overlapping each other, like the members of a
/// team, with an optional label on their right.
class SpectrumAvatarGroup extends StatelessWidget {
  /// Avatars of the group, from the first (at the front) to the last.
  final List<SpectrumAvatar> children;

  /// Text shown on the right of the avatars, like "Design team".
  final String? label;

  /// Diameter of every avatar, 24px by default.
  final double size;

  const SpectrumAvatarGroup({super.key, required this.children, this.label, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final avatars = <Widget>[];

    for (final (index, avatar) in children.indexed) {
      // Each avatar overlaps a quarter of the previous one and gets the background
      // ring, so the avatars stay apart. The first one is on top, as in Spectrum 2.
      avatars.add(
        Positioned(
          left: index * size * 3 / 4,
          child: SpectrumAvatar(src: avatar.src, alt: avatar.alt, size: size, isOverBackground: true),
        ),
      );
    }

    final width = children.isEmpty ? 0.0 : size + (children.length - 1) * size * 3 / 4;

    // Tells screen readers the label of the group, with the avatars inside it.
    return Semantics(
      container: true,
      label: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          SizedBox(
            width: width,
            height: size,
            child: Stack(clipBehavior: Clip.none, children: avatars.reversed.toList()),
          ),
          // Spectrum 2 label: 8px after the avatars, in gray-800.
          Visibility(
            visible: label != null,
            child: ExcludeSemantics(
              child: Text(
                label ?? '',
                style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: colors.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
