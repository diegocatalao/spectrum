import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _traffic = [
  SpectrumDonutSlice(name: 'Search', value: 45),
  SpectrumDonutSlice(name: 'Direct', value: 25),
  SpectrumDonutSlice(name: 'Social', value: 18),
  SpectrumDonutSlice(name: 'Email', value: 12),
];

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDonutChart)
Widget BuildDonutChartPresentation(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SpectrumDonutChart(
      slices: _traffic,
      value: '12.4K',
      label: const Text('Visits'),
      thickness: context.knobs.double.slider(
        label: 'thickness',
        initialValue: 24,
        min: 8,
        max: 60,
        description: 'Thickness of the ring.',
      ),
      showLegend: context.knobs.object.segmented<bool>(
        label: 'showLegend',
        options: [true, false],
        initialOption: true,
        description: 'Whether the legend is shown below the ring.',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Without Value', type: SpectrumDonutChart)
Widget BuildDonutChartWithoutValue(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24),
    child: SpectrumDonutChart(slices: _traffic),
  );
}
