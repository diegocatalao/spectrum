import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Colors of a SpectrumBadge: the semantic ones (accent, informative, neutral,
/// positive, notice and negative) and the categorical ones.
enum SpectrumBadgeVariant {
  accent,
  informative,
  neutral,
  positive,
  notice,
  negative,
  gray,
  red,
  orange,
  yellow,
  chartreuse,
  celery,
  green,
  seafoam,
  cyan,
  blue,
  indigo,
  purple,
  fuchsia,
  magenta,
  pink,
  turquoise,
  brown,
  cinnamon,
  silver,
}

/// How a SpectrumBadge is filled: a strong color, a light color, or only a
/// colored border (outline, for the semantic variants).
enum SpectrumBadgeFillStyle { bold, subtle, outline }

/// Background colors of each variant from the Spectrum 2 tokens: bold in the light
/// and dark themes, then subtle in the light and dark themes.
const Map<SpectrumBadgeVariant, (Color, Color, Color, Color)> _palette = {
  SpectrumBadgeVariant.accent: (
    SpectrumColors.blue900,
    SpectrumDarkColors.blue800,
    SpectrumColors.blue200,
    SpectrumDarkColors.blue300,
  ),
  SpectrumBadgeVariant.informative: (
    SpectrumColors.blue900,
    SpectrumDarkColors.blue800,
    SpectrumColors.blue200,
    SpectrumDarkColors.blue300,
  ),
  SpectrumBadgeVariant.neutral: (
    SpectrumColors.gray700,
    SpectrumDarkColors.gray500,
    SpectrumColors.gray100,
    SpectrumDarkColors.gray300,
  ),
  SpectrumBadgeVariant.positive: (
    SpectrumColors.green900,
    SpectrumDarkColors.green800,
    SpectrumColors.green200,
    SpectrumDarkColors.green300,
  ),
  SpectrumBadgeVariant.notice: (
    SpectrumColors.orange600,
    SpectrumDarkColors.orange900,
    SpectrumColors.orange200,
    SpectrumDarkColors.orange300,
  ),
  SpectrumBadgeVariant.negative: (
    SpectrumColors.red900,
    SpectrumDarkColors.red800,
    SpectrumColors.red200,
    SpectrumDarkColors.red300,
  ),
  SpectrumBadgeVariant.gray: (
    SpectrumColors.gray700,
    SpectrumDarkColors.gray500,
    SpectrumColors.gray100,
    SpectrumDarkColors.gray300,
  ),
  SpectrumBadgeVariant.red: (
    SpectrumColors.red900,
    SpectrumDarkColors.red800,
    SpectrumColors.red200,
    SpectrumDarkColors.red300,
  ),
  SpectrumBadgeVariant.orange: (
    SpectrumColors.orange600,
    SpectrumDarkColors.orange900,
    SpectrumColors.orange200,
    SpectrumDarkColors.orange300,
  ),
  SpectrumBadgeVariant.yellow: (
    SpectrumColors.yellow400,
    SpectrumDarkColors.yellow1100,
    SpectrumColors.yellow200,
    SpectrumDarkColors.yellow300,
  ),
  SpectrumBadgeVariant.chartreuse: (
    SpectrumColors.chartreuse500,
    SpectrumDarkColors.chartreuse1000,
    SpectrumColors.chartreuse200,
    SpectrumDarkColors.chartreuse300,
  ),
  SpectrumBadgeVariant.celery: (
    SpectrumColors.celery600,
    SpectrumDarkColors.celery900,
    SpectrumColors.celery200,
    SpectrumDarkColors.celery300,
  ),
  SpectrumBadgeVariant.green: (
    SpectrumColors.green900,
    SpectrumDarkColors.green800,
    SpectrumColors.green200,
    SpectrumDarkColors.green300,
  ),
  SpectrumBadgeVariant.seafoam: (
    SpectrumColors.seafoam900,
    SpectrumDarkColors.seafoam800,
    SpectrumColors.seafoam200,
    SpectrumDarkColors.seafoam300,
  ),
  SpectrumBadgeVariant.cyan: (
    SpectrumColors.cyan900,
    SpectrumDarkColors.cyan800,
    SpectrumColors.cyan200,
    SpectrumDarkColors.cyan300,
  ),
  SpectrumBadgeVariant.blue: (
    SpectrumColors.blue900,
    SpectrumDarkColors.blue800,
    SpectrumColors.blue200,
    SpectrumDarkColors.blue300,
  ),
  SpectrumBadgeVariant.indigo: (
    SpectrumColors.indigo900,
    SpectrumDarkColors.indigo800,
    SpectrumColors.indigo200,
    SpectrumDarkColors.indigo300,
  ),
  SpectrumBadgeVariant.purple: (
    SpectrumColors.purple900,
    SpectrumDarkColors.purple800,
    SpectrumColors.purple200,
    SpectrumDarkColors.purple300,
  ),
  SpectrumBadgeVariant.fuchsia: (
    SpectrumColors.fuchsia900,
    SpectrumDarkColors.fuchsia800,
    SpectrumColors.fuchsia200,
    SpectrumDarkColors.fuchsia300,
  ),
  SpectrumBadgeVariant.magenta: (
    SpectrumColors.magenta900,
    SpectrumDarkColors.magenta800,
    SpectrumColors.magenta200,
    SpectrumDarkColors.magenta300,
  ),
  SpectrumBadgeVariant.pink: (
    SpectrumColors.pink900,
    SpectrumDarkColors.pink800,
    SpectrumColors.pink200,
    SpectrumDarkColors.pink300,
  ),
  SpectrumBadgeVariant.turquoise: (
    SpectrumColors.turquoise900,
    SpectrumDarkColors.turquoise800,
    SpectrumColors.turquoise200,
    SpectrumDarkColors.turquoise300,
  ),
  SpectrumBadgeVariant.brown: (
    SpectrumColors.brown900,
    SpectrumDarkColors.brown800,
    SpectrumColors.brown200,
    SpectrumDarkColors.brown300,
  ),
  SpectrumBadgeVariant.cinnamon: (
    SpectrumColors.cinnamon900,
    SpectrumDarkColors.cinnamon800,
    SpectrumColors.cinnamon200,
    SpectrumDarkColors.cinnamon300,
  ),
  SpectrumBadgeVariant.silver: (
    SpectrumColors.silver900,
    SpectrumDarkColors.silver800,
    SpectrumColors.silver200,
    SpectrumDarkColors.silver300,
  ),
};

/// Variants whose bold background is light, so their text is black instead of white.
const _lightBold = {
  SpectrumBadgeVariant.notice,
  SpectrumBadgeVariant.orange,
  SpectrumBadgeVariant.yellow,
  SpectrumBadgeVariant.chartreuse,
  SpectrumBadgeVariant.celery,
};

/// Spectrum Badge: a small colored label, with a text, an icon or both, that
/// shows a status or a category, like "New" or "Beta".
class SpectrumBadge extends StatelessWidget {
  /// Text of the badge.
  final Text? child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Color of the badge, neutral by default.
  final SpectrumBadgeVariant variant;

  /// How the badge is filled, bold by default. Outline is only available for the
  /// semantic variants, and the categorical ones fall back to subtle.
  final SpectrumBadgeFillStyle fillStyle;

  /// Cuts a long text with an ellipsis instead of wrapping it.
  final bool isTruncated;

  const SpectrumBadge({
    super.key,
    this.child,
    this.icon,
    this.variant = SpectrumBadgeVariant.neutral,
    this.fillStyle = SpectrumBadgeFillStyle.bold,
    this.isTruncated = false,
  }) : assert(child != null || icon != null);

  /// Border of the outline badge, the "visual" color of the semantic variant.
  Color? _outlineOf(bool isDark) {
    if (variant == SpectrumBadgeVariant.accent || variant == SpectrumBadgeVariant.informative) {
      return isDark ? SpectrumDarkColors.blue900 : SpectrumColors.blue800;
    } else if (variant == SpectrumBadgeVariant.neutral) {
      return isDark ? SpectrumDarkColors.gray600 : SpectrumColors.gray500;
    } else if (variant == SpectrumBadgeVariant.positive) {
      return isDark ? SpectrumDarkColors.green900 : SpectrumColors.green800;
    } else if (variant == SpectrumBadgeVariant.notice) {
      return isDark ? SpectrumDarkColors.orange900 : SpectrumColors.orange800;
    } else if (variant == SpectrumBadgeVariant.negative) {
      return isDark ? SpectrumDarkColors.red900 : SpectrumColors.red800;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (boldLight, boldDark, subtleLight, subtleDark) = _palette[variant]!;
    final outline = _outlineOf(isDark);
    final Color background, border, content;

    if (fillStyle == SpectrumBadgeFillStyle.bold) {
      // When fillStyle is bold, the badge is filled with the strong color, with a
      // white text, or a black text over the light colors.
      background = isDark ? boldDark : boldLight;
      border = Colors.transparent;
      content = _lightBold.contains(variant) ? SpectrumColors.black : SpectrumColors.white;
    } else if (fillStyle == SpectrumBadgeFillStyle.outline && outline != null) {
      // When fillStyle is outline, the badge keeps the elevated background with a
      // 2px border in the color of the variant and the default text.
      background = isDark ? colors.surfaceContainer : colors.surface;
      border = outline;
      content = colors.inverseSurface;
    } else {
      // Otherwise (subtle) the badge is filled with the light color of the variant,
      // with the default text.
      background = isDark ? subtleDark : subtleLight;
      border = Colors.transparent;
      content = colors.inverseSurface;
    }

    final Widget? text;

    if (child != null) {
      // When there is a text, it is Flexible so it wraps or truncates.
      text = Flexible(child: child!);
    } else {
      // Otherwise nothing is added, since an empty child would still receive the spacing.
      text = null;
    }

    // Spectrum 2 badge in the M size: at least 32px high, 12px from the edges,
    // with 8px corners and the icon 6px before the text.
    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 2),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: content),
        child: DefaultTextStyle(
          style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: content),
          maxLines: isTruncated ? 1 : null,
          overflow: isTruncated ? TextOverflow.ellipsis : TextOverflow.clip,
          child: Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: [?icon, ?text]),
        ),
      ),
    );
  }
}
