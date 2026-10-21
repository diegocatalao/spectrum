import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// One slice of a SpectrumDonutChart.
class SpectrumDonutSlice {
  /// Name of the slice, shown in the legend.
  final String name;

  /// Value of the slice; its share of the total sets its size.
  final double value;

  /// Color of the slice. The next color of the categorical palette by default.
  final Color? color;

  const SpectrumDonutSlice({required this.name, required this.value, this.color});
}

/// Spectrum Donut Chart: the parts of a whole as slices of a ring, with an optional
/// value and label in the middle.
class SpectrumDonutChart extends StatefulWidget {
  /// Slices of the ring, clockwise from the top.
  final List<SpectrumDonutSlice> slices;

  /// Big number in the middle of the ring, like the total.
  final String? value;

  /// Label below the value in the middle of the ring.
  final Text? label;

  /// Width and height of the ring.
  final double size;

  /// Thickness of the ring.
  final double thickness;

  /// Shows the legend below the chart.
  final bool showLegend;

  /// Text read by screen readers for the whole chart.
  final String? semanticLabel;

  const SpectrumDonutChart({
    super.key,
    required this.slices,
    this.value,
    this.label,
    this.size = 200,
    this.thickness = 24,
    this.showLegend = true,
    this.semanticLabel,
  });

  @override
  State<SpectrumDonutChart> createState() => _SpectrumDonutChartState();
}

/// Keeps the slice under the pointer, which grows to stand out.
class _SpectrumDonutChartState extends State<SpectrumDonutChart> {
  int? _touched;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final sliceColors = [
      for (final (index, slice) in widget.slices.indexed) SpectrumChartStyle.colorOf(context, index, slice.color),
    ];
    final List<(String, Color)> legend;

    if (widget.showLegend) {
      legend = [for (final (index, slice) in widget.slices.indexed) (slice.name, sliceColors[index])];
    } else {
      legend = const [];
    }

    final sections = <PieChartSectionData>[];

    for (final (index, slice) in widget.slices.indexed) {
      final double radius;

      if (_touched == index) {
        // When a slice is hovered or touched, it grows 4px outwards.
        radius = widget.thickness + 4;
      } else {
        radius = widget.thickness;
      }

      sections.add(
        PieChartSectionData(value: slice.value, color: sliceColors[index], radius: radius, showTitle: false),
      );
    }

    return SpectrumChartFrame(
      height: widget.size,
      semanticLabel: widget.semanticLabel,
      legend: legend,
      // The value and the label sit in the hole of the ring, above the chart.
      chart: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: widget.size,
            child: PieChart(
              PieChartData(
                sections: sections,
                startDegreeOffset: -90,
                sectionsSpace: 2,
                centerSpaceRadius: widget.size / 2 - widget.thickness - 4,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    final index = response?.touchedSection?.touchedSectionIndex;

                    setState(() {
                      if (!event.isInterestedForInteractions || index == null || index < 0) {
                        _touched = null;
                      } else {
                        _touched = index;
                      }
                    });
                  },
                ),
              ),
              duration: SpectrumMotion.duration1000,
              curve: SpectrumMotion.curve,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: widget.value != null,
                child: Text(
                  widget.value ?? '',
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: colors.onSurface),
                ),
              ),
              Visibility(
                visible: widget.label != null,
                child: DefaultTextStyle(
                  style: SpectrumChartStyle.labelStyle(context),
                  child: widget.label ?? const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
