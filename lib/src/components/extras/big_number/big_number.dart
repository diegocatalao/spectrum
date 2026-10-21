import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Direction of the change shown by a SpectrumBigNumber.
enum SpectrumTrend { up, down, neutral }

/// Spectrum Big Number: a key number of a dashboard, with its label and an optional
/// trend, like "Visits 12.4K ↑ 8%".
class SpectrumBigNumber extends StatelessWidget {
  /// The number, already formatted, like "12.4K".
  final String value;

  /// Label above the number.
  final Text label;

  /// Text of the change next to the trend arrow, like "8%".
  final String? change;

  /// Direction of the change, which picks its arrow and color.
  final SpectrumTrend trend;

  /// Paints a rising trend in red and a falling one in green, for numbers where lower is better.
  final bool isLowerBetter;

  const SpectrumBigNumber({
    super.key,
    required this.value,
    required this.label,
    this.change,
    this.trend = SpectrumTrend.neutral,
    this.isLowerBetter = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final positive = isDark ? SpectrumDarkColors.green900 : SpectrumColors.green900;
    final negative = colors.error;
    final Color trendColor;
    final SpectrumIcons? arrow;

    if (trend == SpectrumTrend.up) {
      // A rising trend is good, unless lower is better.
      trendColor = isLowerBetter ? negative : positive;
      arrow = SpectrumIcons.arrowUp;
    } else if (trend == SpectrumTrend.down) {
      trendColor = isLowerBetter ? positive : negative;
      arrow = SpectrumIcons.arrowDown;
    } else {
      trendColor = colors.onSurfaceVariant;
      arrow = null;
    }

    return Semantics(
      container: true,
      label: '${label.data ?? ''} $value ${change ?? ''}',
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            DefaultTextStyle(
              style: (textTheme.bodySmall ?? const TextStyle()).copyWith(color: colors.onSurfaceVariant),
              child: label,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: 12,
              children: [
                // The number in the extra large heading, gray-900.
                Text(
                  value,
                  style: (textTheme.displaySmall ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                ),
                Visibility(
                  visible: change != null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 2,
                    children: [
                      Visibility(
                        visible: arrow != null,
                        child: SpectrumIcon(arrow ?? SpectrumIcons.arrowUp, size: 14, color: trendColor),
                      ),
                      Text(
                        change ?? '',
                        style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                          color: trendColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
