import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// A named series of a SpectrumBarChart, with one value per category.
class SpectrumBarSeries {
  /// Name of the series, shown in the legend and in the tooltip.
  final String name;

  /// Values of the series, in the order of the categories.
  final List<double> values;

  /// Color of the series. The next color of the categorical palette by default.
  final Color? color;

  const SpectrumBarSeries({required this.name, required this.values, this.color});
}

/// Spectrum Bar Chart: bars that compare values between categories, side by side or
/// stacked when there is more than one series.
class SpectrumBarChart extends StatelessWidget {
  /// Names of the categories, shown below their bars.
  final List<String> categories;

  /// Series of the chart, each one drawn in the next categorical color.
  final List<SpectrumBarSeries> series;

  /// Height of the chart, without the legend.
  final double height;

  /// Stacks the series in one bar per category instead of placing them side by side.
  final bool isStacked;

  /// Shows the legend below the chart. By default only when there is more than one series.
  final bool? showLegend;

  /// Largest value of the vertical axis. Taken from the data by default.
  final double? maxY;

  /// Formats the labels of the vertical axis and the tooltips.
  final SpectrumChartFormat? formatY;

  /// Text read by screen readers for the whole chart.
  final String? semanticLabel;

  const SpectrumBarChart({
    super.key,
    required this.categories,
    required this.series,
    this.height = 240,
    this.isStacked = false,
    this.showLegend,
    this.maxY,
    this.formatY,
    this.semanticLabel,
  });

  double _valueOf(SpectrumBarSeries item, int category) {
    if (category < item.values.length) {
      return item.values[category];
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final tooltipStyle = SpectrumChartStyle.tooltipStyle(context);
    final seriesColors = [
      for (final (index, item) in series.indexed) SpectrumChartStyle.colorOf(context, index, item.color),
    ];
    final List<(String, Color)> legend;

    if (showLegend ?? series.length > 1) {
      // When the legend is shown, it names every series with its color.
      legend = [for (final (index, item) in series.indexed) (item.name, seriesColors[index])];
    } else {
      legend = const [];
    }

    final groups = <BarChartGroupData>[];

    for (final (category, _) in categories.indexed) {
      final List<BarChartRodData> rods;

      if (isStacked) {
        // When isStacked is True, every category has one bar with the series stacked
        // from the bottom, each one in its own color.
        final items = <BarChartRodStackItem>[];
        var total = 0.0;

        for (final (index, item) in series.indexed) {
          final value = _valueOf(item, category);
          items.add(BarChartRodStackItem(total, total + value, seriesColors[index]));
          total += value;
        }

        rods = [
          BarChartRodData(
            toY: total,
            width: 24,
            rodStackItems: items,
            color: Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
        ];
      } else {
        // Otherwise the series stand side by side, 2px apart, inside the category.
        rods = [
          for (final (index, item) in series.indexed)
            BarChartRodData(
              toY: _valueOf(item, category),
              width: series.length > 1 ? 12 : 24,
              color: seriesColors[index],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            ),
        ];
      }

      groups.add(BarChartGroupData(x: category, barRods: rods, barsSpace: 2));
    }

    return SpectrumChartFrame(
      height: height,
      semanticLabel: semanticLabel,
      legend: legend,
      chart: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barGroups: groups,
          gridData: SpectrumChartStyle.grid(context),
          borderData: SpectrumChartStyle.border(context),
          titlesData: SpectrumChartStyle.titles(
            context,
            formatY: formatY,
            labelOfX: (value) {
              final index = value.toInt();

              if (index >= 0 && index < categories.length) {
                return categories[index];
              }

              return null;
            },
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => SpectrumChartStyle.tooltipColor(context),
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final String text;

                if (isStacked) {
                  // A stacked bar lists every series of its category.
                  text = [
                    for (final item in series)
                      '${item.name}: ${(formatY ?? SpectrumChartStyle.format)(_valueOf(item, group.x))}',
                  ].join('\n');
                } else {
                  text = '${series[rodIndex].name}: ${(formatY ?? SpectrumChartStyle.format)(rod.toY)}';
                }

                return BarTooltipItem(text, tooltipStyle);
              },
            ),
          ),
        ),
        duration: SpectrumMotion.duration1000,
        curve: SpectrumMotion.curve,
      ),
    );
  }
}
