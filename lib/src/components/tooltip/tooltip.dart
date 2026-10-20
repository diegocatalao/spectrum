import 'package:flutter/material.dart';

/// Spectrum Tooltip: the short text shown by a SpectrumTooltipTrigger when its
/// trigger is hovered or focused.
class SpectrumTooltip extends StatelessWidget {
  /// Text of the tooltip.
  final Text child;

  const SpectrumTooltip({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.labelSmall ?? const TextStyle();

    // Spectrum 2 tooltip text: 12px regular in gray-25 over the neutral
    // background, wrapping after 160px.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160 - 16),
      child: DefaultTextStyle(
        style: style.copyWith(fontWeight: FontWeight.w400, letterSpacing: 0, color: colors.surface),
        child: child,
      ),
    );
  }
}
