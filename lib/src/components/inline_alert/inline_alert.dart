import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Meaning of a SpectrumInlineAlert, which picks its colors and icon.
enum SpectrumInlineAlertVariant { neutral, informative, positive, notice, negative }

/// How a SpectrumInlineAlert is drawn: only a colored border, a light fill or a strong fill.
enum SpectrumInlineAlertFillStyle { border, subtleFill, boldFill }

/// Spectrum Inline Alert: a message next to the content it is about, like the
/// errors of a form, with a heading, a text and an icon for its meaning.
class SpectrumInlineAlert extends StatelessWidget {
  /// Title of the alert.
  final Text? heading;

  /// Text of the alert, below the heading.
  final Widget child;

  /// Meaning of the alert, neutral by default.
  final SpectrumInlineAlertVariant variant;

  /// How the alert is drawn, with a border by default.
  final SpectrumInlineAlertFillStyle fillStyle;

  const SpectrumInlineAlert({
    super.key,
    this.heading,
    required this.child,
    this.variant = SpectrumInlineAlertVariant.neutral,
    this.fillStyle = SpectrumInlineAlertFillStyle.border,
  });

  /// Returns the color of the given step of the variant, from the light or the
  /// dark palette, like 800 for the informative border.
  Color _tone(BuildContext context, int step) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (variant == SpectrumInlineAlertVariant.informative) {
      return _pick(
        isDark,
        step,
        SpectrumColors.blue200,
        SpectrumColors.blue700,
        SpectrumColors.blue800,
        SpectrumColors.blue900,
        SpectrumDarkColors.blue200,
        SpectrumDarkColors.blue700,
        SpectrumDarkColors.blue800,
        SpectrumDarkColors.blue900,
      );
    } else if (variant == SpectrumInlineAlertVariant.positive) {
      return _pick(
        isDark,
        step,
        SpectrumColors.green200,
        SpectrumColors.green700,
        SpectrumColors.green800,
        SpectrumColors.green900,
        SpectrumDarkColors.green200,
        SpectrumDarkColors.green700,
        SpectrumDarkColors.green800,
        SpectrumDarkColors.green900,
      );
    } else if (variant == SpectrumInlineAlertVariant.notice) {
      return _pick(
        isDark,
        step,
        SpectrumColors.orange200,
        SpectrumColors.orange700,
        SpectrumColors.orange800,
        SpectrumColors.orange900,
        SpectrumDarkColors.orange200,
        SpectrumDarkColors.orange700,
        SpectrumDarkColors.orange800,
        SpectrumDarkColors.orange900,
      );
    } else if (variant == SpectrumInlineAlertVariant.negative) {
      return _pick(
        isDark,
        step,
        SpectrumColors.red200,
        SpectrumColors.red700,
        SpectrumColors.red800,
        SpectrumColors.red900,
        SpectrumDarkColors.red200,
        SpectrumDarkColors.red700,
        SpectrumDarkColors.red800,
        SpectrumDarkColors.red900,
      );
    } else {
      return _pick(
        isDark,
        step,
        SpectrumColors.gray100,
        SpectrumColors.gray700,
        SpectrumColors.gray700,
        SpectrumColors.gray800,
        SpectrumDarkColors.gray100,
        SpectrumDarkColors.gray700,
        SpectrumDarkColors.gray700,
        SpectrumDarkColors.gray800,
      );
    }
  }

  /// Picks the color of the step (200, 700, 800 or 900) from the palette of the theme.
  Color _pick(
    bool isDark,
    int step,
    Color l200,
    Color l700,
    Color l800,
    Color l900,
    Color d200,
    Color d700,
    Color d800,
    Color d900,
  ) {
    if (step == 200) {
      return isDark ? d200 : l200;
    } else if (step == 700) {
      return isDark ? d700 : l700;
    } else if (step == 800) {
      return isDark ? d800 : l800;
    } else {
      return isDark ? d900 : l900;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Color background, border, title, body, icon;

    if (fillStyle == SpectrumInlineAlertFillStyle.boldFill) {
      // When fillStyle is boldFill, the alert is filled with the strong color of the
      // variant, and the texts and the icon are white (black over the notice orange).
      final onFill = variant == SpectrumInlineAlertVariant.notice ? SpectrumColors.black : SpectrumColors.white;
      background = _tone(context, 800);
      border = Colors.transparent;
      title = onFill;
      body = onFill;
      icon = onFill;
    } else if (fillStyle == SpectrumInlineAlertFillStyle.subtleFill) {
      // When fillStyle is subtleFill, the alert is filled with the light color of the
      // variant, with the default texts and the icon in the color of the variant.
      background = _tone(context, 200);
      border = Colors.transparent;
      title = colors.inverseSurface;
      body = colors.onSurface;
      icon = _tone(context, 900);
    } else {
      // Otherwise the alert keeps the background color with a 2px border in the
      // color of the variant, and the icon in that color too.
      background = colors.surface;
      border = _tone(
        context,
        variant == SpectrumInlineAlertVariant.positive || variant == SpectrumInlineAlertVariant.notice ? 700 : 800,
      );
      title = colors.inverseSurface;
      body = colors.onSurface;
      icon = _tone(context, 900);
    }

    final SpectrumIcons? asset;

    if (variant == SpectrumInlineAlertVariant.informative) {
      asset = SpectrumIcons.info;
    } else if (variant == SpectrumInlineAlertVariant.positive) {
      asset = SpectrumIcons.checkmarkCircle;
    } else if (variant == SpectrumInlineAlertVariant.notice) {
      asset = SpectrumIcons.alertCircle;
    } else if (variant == SpectrumInlineAlertVariant.negative) {
      asset = SpectrumIcons.alert;
    } else {
      // The neutral alert has no icon, as in Spectrum 2.
      asset = null;
    }

    // Tells screen readers to announce the alert when it appears.
    return Semantics(
      liveRegion: true,
      container: true,
      // Spectrum 2 inline alert: 24px of padding and 10px corners.
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // The heading is the small title of Spectrum 2, in gray-900.
                  Visibility(
                    visible: heading != null,
                    child: DefaultTextStyle(
                      style: (textTheme.titleMedium ?? const TextStyle()).copyWith(color: title),
                      child: heading ?? const SizedBox.shrink(),
                    ),
                  ),
                  DefaultTextStyle(
                    style: (textTheme.bodySmall ?? const TextStyle()).copyWith(color: body),
                    child: child,
                  ),
                ],
              ),
            ),
            // The icon of the variant floats at the end of the alert.
            Visibility(
              visible: asset != null,
              child: SpectrumIcon(asset ?? SpectrumIcons.info, size: 20, color: icon),
            ),
          ],
        ),
      ),
    );
  }
}
