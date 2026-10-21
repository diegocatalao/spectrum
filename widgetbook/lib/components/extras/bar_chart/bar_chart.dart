import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _quarters = ['Q1', 'Q2', 'Q3', 'Q4'];

const _sales = [
  SpectrumBarSeries(name: 'Online', values: [40, 52, 61, 70]),
  SpectrumBarSeries(name: 'Stores', values: [35, 30, 38, 45]),
  SpectrumBarSeries(name: 'Partners', values: [10, 14, 12, 20]),
];

@widgetbook.UseCase(name: 'Presentation', type: SpectrumBarChart)
Widget BuildBarChartPresentation(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumBarChart(
      categories: _quarters,
      series: _sales,
      isStacked: context.knobs.object.segmented<bool>(
        label: 'isStacked',
        options: [true, false],
        initialOption: false,
        description: 'Whether the series are stacked in one bar per category.',
      ),
      formatY: (value) => '\$${value.toInt()}K',
    ),
  );
}

@widgetbook.UseCase(name: 'Single Series', type: SpectrumBarChart)
Widget BuildBarChartSingleSeries(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumBarChart(categories: _quarters, series: [_sales.first]),
  );
}
