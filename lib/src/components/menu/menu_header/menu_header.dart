import 'package:flutter/material.dart';

/// Spectrum Menu Header: the bold title of a SpectrumMenuSection, with an
/// optional description below it.
class SpectrumMenuHeader extends StatelessWidget {
  /// Title of the section.
  final Text child;

  /// Text shown below the title.
  final Text? description;

  const SpectrumMenuHeader({super.key, required this.child, this.description});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.bodySmall ?? const TextStyle();

    // Spectrum 2 section header: at least 32px high, aligned with the texts of the
    // items, 12px from the edges, with the bold 14px title in gray-800.
    return ExcludeSemantics(
      child: Container(
        constraints: const BoxConstraints(minHeight: 32),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: style.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
              child: child,
            ),
            // The description is 12px (the size of Detail S) in gray-700.
            Visibility(
              visible: description != null,
              child: DefaultTextStyle(
                style: style.copyWith(fontSize: textTheme.labelSmall?.fontSize, color: colors.onSurfaceVariant),
                child: description ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
