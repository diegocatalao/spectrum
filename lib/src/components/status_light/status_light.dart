import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Colors of the Spectrum 2 status light: the semantic ones, for statuses with a
/// meaning, and the categorical ones, to color code categories and labels.
enum SpectrumStatusVariant {
  informative,
  neutral,
  positive,
  notice,
  negative,
  celery,
  chartreuse,
  cyan,
  fuchsia,
  purple,
  magenta,
  indigo,
  seafoam,
  yellow,
  pink,
  turquoise,
  cinnamon,
  brown,
  silver;

  /// Returns the "visual" color of the variant from the Spectrum 2 tokens, which is
  /// one step darker in the dark theme so the dot keeps its contrast.
  Color colorsOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (this == informative) {
      return isDark ? SpectrumDarkColors.blue900 : SpectrumColors.blue800;
    } else if (this == neutral) {
      return isDark ? SpectrumDarkColors.gray600 : SpectrumColors.gray500;
    } else if (this == positive) {
      return isDark ? SpectrumDarkColors.green900 : SpectrumColors.green800;
    } else if (this == notice) {
      return isDark ? SpectrumDarkColors.orange900 : SpectrumColors.orange800;
    } else if (this == negative) {
      return isDark ? SpectrumDarkColors.red900 : SpectrumColors.red800;
    } else if (this == celery) {
      return isDark ? SpectrumDarkColors.celery800 : SpectrumColors.celery700;
    } else if (this == chartreuse) {
      return isDark ? SpectrumDarkColors.chartreuse900 : SpectrumColors.chartreuse600;
    } else if (this == cyan) {
      return isDark ? SpectrumDarkColors.cyan900 : SpectrumColors.cyan600;
    } else if (this == fuchsia) {
      return isDark ? SpectrumDarkColors.fuchsia900 : SpectrumColors.fuchsia800;
    } else if (this == purple) {
      return isDark ? SpectrumDarkColors.purple900 : SpectrumColors.purple800;
    } else if (this == magenta) {
      return isDark ? SpectrumDarkColors.magenta900 : SpectrumColors.magenta800;
    } else if (this == indigo) {
      return isDark ? SpectrumDarkColors.indigo900 : SpectrumColors.indigo800;
    } else if (this == seafoam) {
      return isDark ? SpectrumDarkColors.seafoam800 : SpectrumColors.seafoam700;
    } else if (this == yellow) {
      return isDark ? SpectrumDarkColors.yellow1100 : SpectrumColors.yellow600;
    } else if (this == pink) {
      return isDark ? SpectrumDarkColors.pink900 : SpectrumColors.pink800;
    } else if (this == turquoise) {
      return isDark ? SpectrumDarkColors.turquoise900 : SpectrumColors.turquoise800;
    } else if (this == cinnamon) {
      return isDark ? SpectrumDarkColors.cinnamon900 : SpectrumColors.cinnamon800;
    } else if (this == brown) {
      return isDark ? SpectrumDarkColors.brown900 : SpectrumColors.brown800;
    } else {
      return isDark ? SpectrumDarkColors.silver900 : SpectrumColors.silver800;
    }
  }
}

/// Spectrum Status Light: a colored dot followed by a label, describing the
/// status of something, like "Approved", or the category it belongs to.
class SpectrumStatusLight extends StatelessWidget {
  /// Label shown on the right of the dot.
  final Text child;

  /// Color of the dot. Statuses with a meaning should use the semantic variants.
  final SpectrumStatusVariant variant;

  /// Announces the label to screen readers whenever it changes. Use it only when
  /// the status changes at runtime and no other status light changes at the same time.
  final bool isLive;

  const SpectrumStatusLight({
    super.key,
    required this.child,
    this.variant = SpectrumStatusVariant.neutral,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final Color content;

    if (variant == SpectrumStatusVariant.neutral) {
      // When variant is neutral, the label is a lighter gray (gray-600), so the
      // neutral status looks less important than the colored ones.
      content = Theme.of(context).brightness == Brightness.dark ? SpectrumDarkColors.gray600 : SpectrumColors.gray600;
    } else {
      // Otherwise the label keeps the default text color (gray-800) and only
      // the dot shows the color of the variant.
      content = colors.onSurface;
    }

    // The height of one line of the label, so the dot is centered on the
    // first line even when the label wraps to more lines.
    final lineHeight = (style.fontSize ?? 14) * (style.height ?? 1);

    return Semantics(
      liveRegion: isLive,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // Spectrum 2 "text-to-visual" gap of the M size.
        spacing: 6,
        children: [
          // Spectrum 2 status light dot: 10px in the M size, hidden from screen
          // readers, since the label already describes the status.
          ExcludeSemantics(
            child: SizedBox(
              height: lineHeight,
              child: Center(
                widthFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: variant.colorsOf(context), shape: BoxShape.circle),
                  child: const SizedBox.square(dimension: 10),
                ),
              ),
            ),
          ),
          // The label is Flexible, so a long text wraps instead of overflowing.
          Flexible(
            child: DefaultTextStyle(
              style: style.copyWith(color: content),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
