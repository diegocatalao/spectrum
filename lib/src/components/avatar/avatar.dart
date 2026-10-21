import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Avatar: a round picture that represents a person or a team.
class SpectrumAvatar extends StatelessWidget {
  /// Address of the picture.
  final Uri src;

  /// Text read by screen readers, like the name of the person. Without it, the
  /// avatar is treated as decorative.
  final String? alt;

  /// Diameter of the avatar, 24px by default.
  final double size;

  /// Draws a ring in the background color around the avatar, to separate it from
  /// a colored background or from the avatars next to it.
  final bool isOverBackground;

  const SpectrumAvatar({super.key, required this.src, this.alt, this.size = 24, this.isOverBackground = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color ring;

    if (isOverBackground && isDark) {
      // When isOverBackground is True, the ring has the color of the layer behind it.
      ring = colors.surfaceContainer;
    } else if (isOverBackground) {
      ring = colors.surface;
    } else {
      // Otherwise there is no ring.
      ring = Colors.transparent;
    }

    // Spectrum 2 avatar: a round image, with a 1px ring over backgrounds, or 2px
    // from 64px on.
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: ring, spreadRadius: size >= 64 ? 2 : 1)],
      ),
      child: SpectrumImage(
        uri: src,
        semanticLabel: alt,
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}
