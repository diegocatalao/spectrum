import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Histogram: the distribution of a set of values, counted in bins of the
/// same width and drawn as touching bars.
class SpectrumHistogram extends StatelessWidget {
  /// Values to distribute in the bins.
  final List<double> values;

  /// Number of bins between the smallest and the largest value.
  final int binCount;

  /// Height of the chart.
  final double height;

  /// Color of the bars. The first color of the categorical palette by default.
  final Color? color;

  /// Formats the start of the bins below the bars.
  final SpectrumChartFormat? formatX;

  /// Text read by screen readers for the whole chart.
  final String? semanticLabel;

  const SpectrumHistogram({
    super.key,
    required this.values,
    this.binCount = 10,
    this.height = 240,
    this.color,
    this.formatX,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final format = formatX ?? SpectrumChartStyle.format;
    final tooltipStyle = SpectrumChartStyle.tooltipStyle(context);
    final barColor = SpectrumChartStyle.colorOf(context, 0, color);
    final bins = math.max(1, binCount);
    final double minValue, binWidth;

    if (values.isEmpty) {
      // When there are no values, the bins are empty and cover 0 to 1.
      minValue = 0;
      binWidth = 1 / bins;
    } else {
      minValue = values.reduce(math.min);
      final maxValue = values.reduce(math.max);
      // A set of equal values still gets bins of some width.
      binWidth = maxValue > minValue ? (maxValue - minValue) / bins : 1;
    }

    final counts = List<int>.filled(bins, 0);

    for (final value in values) {
      // The largest value belongs to the last bin instead of a new one.
      final index = ((value - minValue) / binWidth).floor().clamp(0, bins - 1);
      counts[index]++;
    }

    // Labels every few bins, so they do not overlap.
    final labelStep = (bins / 6).ceil();

    return SpectrumChartFrame(
      height: height,
      semanticLabel: semanticLabel,
      // The bars touch with a 1px gap, so their width follows the space of the chart.
      chart: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = math.max(1.0, (constraints.maxWidth - 40) / bins - 1);

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              groupsSpace: 1,
              gridData: SpectrumChartStyle.grid(context),
              borderData: SpectrumChartStyle.border(context),
              titlesData: SpectrumChartStyle.titles(
                context,
                labelOfX: (value) {
                  final index = value.toInt();

                  if (index % labelStep == 0) {
                    return format(minValue + index * binWidth);
                  }

                  return null;
                },
              ),
              barGroups: [
                for (final (index, count) in counts.indexed)
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        width: barWidth,
                        color: barColor,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
              ],
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => SpectrumChartStyle.tooltipColor(context),
                  tooltipBorderRadius: BorderRadius.circular(8),
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final start = minValue + group.x * binWidth;
                    return BarTooltipItem(
                      '${format(start)} – ${format(start + binWidth)}: ${rod.toY.toInt()}',
                      tooltipStyle,
                    );
                  },
                ),
              ),
            ),
            duration: SpectrumMotion.duration1000,
            curve: SpectrumMotion.curve,
          );
        },
      ),
    );
  }
}
