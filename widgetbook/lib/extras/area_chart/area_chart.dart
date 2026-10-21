import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _visits = [
  SpectrumChartSeries(
    name: 'Desktop',
    points: [
      SpectrumChartPoint(1, 30),
      SpectrumChartPoint(2, 42),
      SpectrumChartPoint(3, 38),
      SpectrumChartPoint(4, 55),
      SpectrumChartPoint(5, 61),
      SpectrumChartPoint(6, 58),
    ],
  ),
  SpectrumChartSeries(
    name: 'Mobile',
    points: [
      SpectrumChartPoint(1, 12),
      SpectrumChartPoint(2, 20),
      SpectrumChartPoint(3, 28),
      SpectrumChartPoint(4, 26),
      SpectrumChartPoint(5, 35),
      SpectrumChartPoint(6, 44),
    ],
  ),
];

@widgetbook.UseCase(name: 'Presentation', type: SpectrumAreaChart)
Widget BuildAreaChartPresentation(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumAreaChart(
      series: _visits,
      isCurved: context.knobs.object.segmented<bool>(
        label: 'isCurved',
        options: [true, false],
        initialOption: false,
        description: 'Whether the lines are smooth curves.',
      ),
      showPoints: context.knobs.object.segmented<bool>(
        label: 'showPoints',
        options: [true, false],
        initialOption: false,
        description: 'Whether every point shows a dot.',
      ),
      formatX: (value) => 'Week ${value.toInt()}',
    ),
  );
}

@widgetbook.UseCase(name: 'Single Series', type: SpectrumAreaChart)
Widget BuildAreaChartSingleSeries(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumAreaChart(series: [_visits.first], minY: 0),
  );
}
