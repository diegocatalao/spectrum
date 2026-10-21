import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Scatter Plot: points placed by two values, to show how they relate, with
/// one color per series.
class SpectrumScatterPlot extends StatelessWidget {
  /// Series of the chart, each one drawn as dots in the next categorical color.
  final List<SpectrumChartSeries> series;

  /// Height of the chart, without the legend.
  final double height;

  /// Radius of the dots.
  final double pointRadius;

  /// Shows the legend below the chart. By default only when there is more than one series.
  final bool? showLegend;

  /// Formats the labels of the horizontal and vertical axes.
  final SpectrumChartFormat? formatX, formatY;

  /// Text read by screen readers for the whole chart.
  final String? semanticLabel;

  const SpectrumScatterPlot({
    super.key,
    required this.series,
    this.height = 240,
    this.pointRadius = 4,
    this.showLegend,
    this.formatX,
    this.formatY,
    this.semanticLabel,
  });

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

    // Each dot remembers its series, so the tooltip can name it.
    final spots = <ScatterSpot>[];
    final names = <ScatterSpot, String>{};

    for (final (index, item) in series.indexed) {
      for (final point in item.points) {
        final spot = ScatterSpot(
          point.x,
          point.y,
          // Dots are 80% opaque, so the overlapping ones stay visible.
          dotPainter: FlDotCirclePainter(radius: pointRadius, color: seriesColors[index].withValues(alpha: 0.8)),
        );
        spots.add(spot);
        names[spot] = item.name;
      }
    }

    return SpectrumChartFrame(
      height: height,
      semanticLabel: semanticLabel,
      legend: legend,
      chart: ScatterChart(
        ScatterChartData(
          scatterSpots: spots,
          gridData: SpectrumChartStyle.grid(context),
          borderData: SpectrumChartStyle.border(context),
          titlesData: SpectrumChartStyle.titles(context, formatX: formatX, formatY: formatY),
          scatterTouchData: ScatterTouchData(
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipColor: (spot) => SpectrumChartStyle.tooltipColor(context),
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              getTooltipItems: (spot) => ScatterTooltipItem(
                '${names[spot] ?? ''}\n'
                '${(formatX ?? SpectrumChartStyle.format)(spot.x)}, ${(formatY ?? SpectrumChartStyle.format)(spot.y)}',
                textStyle: tooltipStyle,
              ),
            ),
          ),
        ),
        duration: SpectrumMotion.duration1000,
        curve: SpectrumMotion.curve,
      ),
    );
  }
}
