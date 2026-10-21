import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumBigNumber)
Widget BuildBigNumberPresentation(BuildContext context) {
  return SpectrumBigNumber(
    label: Text('Visits this week'),
    value: context.knobs.string(label: 'value', initialValue: '12.4K', description: 'The number.'),
    change: '8%',
    trend: context.knobs.object.segmented<SpectrumTrend>(
      label: 'trend',
      options: SpectrumTrend.values,
      initialOption: SpectrumTrend.up,
      labelBuilder: (SpectrumTrend value) => value.name,
      description: 'The direction of the change.',
    ),
    isLowerBetter: context.knobs.object.segmented<bool>(
      label: 'isLowerBetter',
      options: [true, false],
      initialOption: false,
      description: 'Whether a rising number is bad.',
    ),
  );
}
