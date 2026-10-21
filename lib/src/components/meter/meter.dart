import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Meaning of a SpectrumMeter, which picks the color of its fill.
enum SpectrumMeterVariant { informative, positive, notice, negative }

/// Spectrum Meter: a bar that shows a quantity within a known range, like the
/// used storage of an account, with a color for its meaning.
class SpectrumMeter extends StatelessWidget {
  /// Label shown above the bar, or on its left when labelPosition is side.
  final Text? label;

  /// Current value, between minValue and maxValue.
  final double value;

  /// Value of an empty bar.
  final double minValue;

  /// Value of a full bar.
  final double maxValue;

  /// Text shown on the right of the label instead of the percentage, like "50 of 100 GB".
  final Text? valueLabel;

  /// Meaning of the value, informative by default.
  final SpectrumMeterVariant variant;

  /// Where the label is placed.
  final SpectrumLabelPosition labelPosition;

  /// Fixed white or black colors for meters over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  /// Width of the bar, 208px by default as the Spectrum 2 fields.
  final double width;

  const SpectrumMeter({
    super.key,
    this.label,
    this.value = 0,
    this.minValue = 0,
    this.maxValue = 100,
    this.valueLabel,
    this.variant = SpectrumMeterVariant.informative,
    this.labelPosition = SpectrumLabelPosition.top,
    this.staticColor,
    this.width = 208,
  });

  /// Fill of the variant, its "visual" color from the Spectrum 2 tokens.
  Color _fillOf(bool isDark) {
    if (variant == SpectrumMeterVariant.positive) {
      return isDark ? SpectrumDarkColors.green900 : SpectrumColors.green800;
    } else if (variant == SpectrumMeterVariant.notice) {
      return isDark ? SpectrumDarkColors.orange900 : SpectrumColors.orange800;
    } else if (variant == SpectrumMeterVariant.negative) {
      return isDark ? SpectrumDarkColors.red900 : SpectrumColors.red800;
    } else {
      return isDark ? SpectrumDarkColors.blue900 : SpectrumColors.blue800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final range = maxValue - minValue;
    final progress = range <= 0 ? 0.0 : ((value - minValue) / range).clamp(0.0, 1.0);
    final Color track, fill, content;

    if (staticColor == SpectrumStaticColor.black) {
      // When staticColor is black, the meter uses translucent black over light images.
      track = SpectrumColors.black.withValues(alpha: 0.3);
      fill = SpectrumColors.black.withValues(alpha: 0.9);
      content = SpectrumColors.black;
    } else if (staticColor == SpectrumStaticColor.white) {
      // When staticColor is white, the meter uses translucent white over dark images.
      track = SpectrumColors.white.withValues(alpha: 0.3);
      fill = SpectrumColors.white.withValues(alpha: 0.9);
      content = SpectrumColors.white;
    } else {
      // Otherwise the track is gray-300, the fill has the color of the variant
      // and the texts are gray-700, as the Spectrum 2 field labels.
      track = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
      fill = _fillOf(isDark);
      content = colors.onSurfaceVariant;
    }

    final valueText = valueLabel ?? Text('${(progress * 100).round()}%');

    // Spectrum 2 meter track: 6px high and fully rounded, with the fill from the start.
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 6,
        color: track,
        alignment: AlignmentDirectional.centerStart,
        child: AnimatedFractionallySizedBox(
          duration: SpectrumMotion.duration,
          curve: SpectrumMotion.curve,
          widthFactor: progress,
          heightFactor: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(999)),
          ),
        ),
      ),
    );

    final Widget layout;

    if (labelPosition == SpectrumLabelPosition.side) {
      // When labelPosition is side, the label, the bar and the value share one line, 12px apart.
      layout = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          ?label,
          SizedBox(width: width, child: bar),
          valueText,
        ],
      );
    } else {
      // Otherwise the label and the value are above the bar, at its two ends.
      layout = SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(child: label ?? const SizedBox.shrink()),
                valueText,
              ],
            ),
            bar,
          ],
        ),
      );
    }

    // Tells screen readers that this is a meter, with its value.
    return Semantics(
      label: label?.data,
      value: '${(progress * 100).round()}%',
      child: DefaultTextStyle(
        style: style.copyWith(color: content),
        child: layout,
      ),
    );
  }
}
