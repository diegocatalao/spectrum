import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Line Chart: one or more series of values joined by lines, to show how
/// they change over a continuous axis, like time.
class SpectrumLineChart extends StatelessWidget {
  /// Series of the chart, each one drawn as a line in the next categorical color.
  final List<SpectrumChartSeries> series;

  /// Height of the chart, without the legend.
  final double height;

  /// Draws smooth curves instead of straight segments.
  final bool isCurved;

  /// Shows a dot on every point.
  final bool showPoints;

  /// Shows the legend below the chart. By default only when there is more than one series.
  final bool? showLegend;

  /// Smallest and largest values of the vertical axis. Taken from the data by default.
  final double? minY, maxY;

  /// Formats the labels of the horizontal and vertical axes.
  final SpectrumChartFormat? formatX, formatY;

  /// Text read by screen readers for the whole chart.
  final String? semanticLabel;

  const SpectrumLineChart({
    super.key,
    required this.series,
    this.height = 240,
    this.isCurved = false,
    this.showPoints = false,
    this.showLegend,
    this.minY,
    this.maxY,
    this.formatX,
    this.formatY,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final List<(String, Color)> legend;

    if (showLegend ?? series.length > 1) {
      // When the legend is shown, it names every series with its color.
      legend = [
        for (final (index, item) in series.indexed) (item.name, SpectrumChartStyle.colorOf(context, index, item.color)),
      ];
    } else {
      legend = const [];
    }

    return SpectrumChartFrame(
      height: height,
      semanticLabel: semanticLabel,
      legend: legend,
      chart: LineChart(
        spectrumLineChartData(
          context,
          series: series,
          isCurved: isCurved,
          showPoints: showPoints,
          minY: minY,
          maxY: maxY,
          formatX: formatX,
          formatY: formatY,
        ),
        duration: SpectrumMotion.duration1000,
        curve: SpectrumMotion.curve,
      ),
    );
  }
}
