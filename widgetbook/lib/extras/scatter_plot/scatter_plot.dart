import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _groups = [
  SpectrumChartSeries(
    name: 'Team A',
    points: [
      SpectrumChartPoint(2, 12),
      SpectrumChartPoint(3, 18),
      SpectrumChartPoint(4, 17),
      SpectrumChartPoint(5, 26),
      SpectrumChartPoint(6, 28),
      SpectrumChartPoint(7, 35),
      SpectrumChartPoint(8, 33),
    ],
  ),
  SpectrumChartSeries(
    name: 'Team B',
    points: [
      SpectrumChartPoint(1, 8),
      SpectrumChartPoint(2.5, 10),
      SpectrumChartPoint(3.5, 14),
      SpectrumChartPoint(5.5, 16),
      SpectrumChartPoint(6.5, 22),
      SpectrumChartPoint(7.5, 21),
      SpectrumChartPoint(9, 27),
    ],
  ),
];

@widgetbook.UseCase(name: 'Presentation', type: SpectrumScatterPlot)
Widget BuildScatterPlotPresentation(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumScatterPlot(
      series: _groups,
      pointRadius: context.knobs.double.slider(
        label: 'pointRadius',
        initialValue: 4,
        min: 2,
        max: 10,
        description: 'Radius of the dots.',
      ),
      formatX: (value) => '${value.toInt()}h',
    ),
  );
}
