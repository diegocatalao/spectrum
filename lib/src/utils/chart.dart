import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// One point of a chart series, at [x] on the horizontal axis and [y] on the vertical one.
class SpectrumChartPoint {
  /// Position on the horizontal axis.
  final double x;

  /// Position on the vertical axis.
  final double y;

  const SpectrumChartPoint(this.x, this.y);
}

/// A named series of points, drawn as one line, area or group of dots.
class SpectrumChartSeries {
  /// Name of the series, shown in the legend and in the tooltip.
  final String name;

  /// Points of the series, in the order of the horizontal axis.
  final List<SpectrumChartPoint> points;

  /// Color of the series. The next color of the categorical palette by default.
  final Color? color;

  const SpectrumChartSeries({required this.name, required this.points, this.color});
}

/// Formats a value of an axis or a tooltip, like "12" or "12.5".
typedef SpectrumChartFormat = String Function(double value);

/// Shared look of the Spectrum charts built on fl_chart: categorical colors, gray-200
/// grid lines, Detail S axis labels and gray-900 tooltips.
abstract final class SpectrumChartStyle {
  /// Color of the series at [index]: its own color or the categorical palette in order.
  static Color colorOf(BuildContext context, int index, Color? color) {
    if (color != null) {
      return color;
    }

    final palette = Theme.of(context).brightness == Brightness.dark
        ? SpectrumDarkColors.categorical
        : SpectrumColors.categorical;
    return palette[index % palette.length];
  }

  /// Shows whole numbers without decimals and the rest with one decimal.
  static String format(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  /// Style of the axis labels: Detail S in gray-700.
  static TextStyle labelStyle(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return (Theme.of(context).textTheme.labelSmall ?? const TextStyle()).copyWith(color: colors.onSurfaceVariant);
  }

  /// Background of the tooltips: gray-900, like the Spectrum tooltip.
  static Color tooltipColor(BuildContext context) => Theme.of(context).colorScheme.inverseSurface;

  /// Text of the tooltips: Detail S in gray-25 over the gray-900 background.
  static TextStyle tooltipStyle(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return (Theme.of(context).textTheme.labelSmall ?? const TextStyle()).copyWith(color: colors.surface);
  }

  /// Horizontal gray-200 grid lines only, so the values are read across the chart.
  static FlGridData grid(BuildContext context) {
    final line = Theme.of(context).colorScheme.outlineVariant;
    return FlGridData(
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) => FlLine(color: line, strokeWidth: 1),
    );
  }

  /// A gray-400 baseline under the chart, without the other borders.
  static FlBorderData border(BuildContext context) {
    return FlBorderData(
      border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
    );
  }

  /// Labels on the left and bottom axes, formatted by [formatX] and [formatY].
  /// [labelOfX] replaces the bottom labels, like the categories of a bar chart.
  static FlTitlesData titles(
    BuildContext context, {
    SpectrumChartFormat? formatX,
    SpectrumChartFormat? formatY,
    String? Function(double value)? labelOfX,
  }) {
    final style = labelStyle(context);
    const hidden = AxisTitles(sideTitles: SideTitles(showTitles: false));

    return FlTitlesData(
      topTitles: hidden,
      rightTitles: hidden,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => SideTitleWidget(
            meta: meta,
            child: Text((formatY ?? format)(value), style: style),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          interval: labelOfX == null ? null : 1,
          getTitlesWidget: (value, meta) {
            final String text;

            if (labelOfX != null) {
              // When the axis has categories, each one is shown below its bars.
              text = labelOfX(value) ?? '';
            } else {
              text = (formatX ?? format)(value);
            }

            return SideTitleWidget(
              meta: meta,
              child: Text(text, style: style),
            );
          },
        ),
      ),
    );
  }
}

/// Legend of a Spectrum chart: a row of 8px color dots with the series names, wrapping
/// to new lines when it does not fit.
class SpectrumChartLegend extends StatelessWidget {
  /// Name and color of each entry.
  final List<(String, Color)> entries;

  const SpectrumChartLegend({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface);

    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        for (final (name, color) in entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              Text(name, style: style),
            ],
          ),
      ],
    );
  }
}

/// Lays out a chart with its height and the legend below it.
class SpectrumChartFrame extends StatelessWidget {
  /// The fl_chart widget.
  final Widget chart;

  /// Height of the chart, without the legend.
  final double height;

  /// Entries of the legend, hidden when empty.
  final List<(String, Color)> legend;

  /// Text read by screen readers for the whole chart.
  final String? semanticLabel;

  const SpectrumChartFrame({
    super.key,
    required this.chart,
    required this.height,
    this.legend = const [],
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          SizedBox(height: height, child: chart),
          Visibility(
            visible: legend.isNotEmpty,
            child: SpectrumChartLegend(entries: legend),
          ),
        ],
      ),
    );
  }
}

/// Builds the fl_chart data of the line and area charts, with one line per series.
LineChartData spectrumLineChartData(
  BuildContext context, {
  required List<SpectrumChartSeries> series,
  bool isArea = false,
  bool isCurved = false,
  bool showPoints = false,
  double? minY,
  double? maxY,
  SpectrumChartFormat? formatX,
  SpectrumChartFormat? formatY,
}) {
  final colors = Theme.of(context).colorScheme;
  final tooltipStyle = SpectrumChartStyle.tooltipStyle(context);

  return LineChartData(
    minY: minY,
    maxY: maxY,
    gridData: SpectrumChartStyle.grid(context),
    borderData: SpectrumChartStyle.border(context),
    titlesData: SpectrumChartStyle.titles(context, formatX: formatX, formatY: formatY),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (spot) => SpectrumChartStyle.tooltipColor(context),
        tooltipBorderRadius: BorderRadius.circular(8),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        getTooltipItems: (spots) => [
          for (final spot in spots)
            LineTooltipItem(
              '${series[spot.barIndex].name}: ${(formatY ?? SpectrumChartStyle.format)(spot.y)}',
              tooltipStyle,
            ),
        ],
      ),
    ),
    lineBarsData: [
      for (final (index, item) in series.indexed)
        LineChartBarData(
          spots: [for (final point in item.points) FlSpot(point.x, point.y)],
          color: SpectrumChartStyle.colorOf(context, index, item.color),
          barWidth: 2,
          isCurved: isCurved,
          preventCurveOverShooting: true,
          // Points are 4px dots ringed with the background, so they stand out on the line.
          dotData: FlDotData(
            show: showPoints,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 4,
              color: bar.color ?? colors.primary,
              strokeWidth: 2,
              strokeColor: colors.surface,
            ),
          ),
          // An area fills below its line with the series color at 20%.
          belowBarData: BarAreaData(
            show: isArea,
            color: SpectrumChartStyle.colorOf(context, index, item.color).withValues(alpha: 0.2),
          ),
        ),
    ],
  );
}
