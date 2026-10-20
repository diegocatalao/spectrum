import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumProgressCircle)
Widget BuildProgressCirclePresentation(BuildContext context) {
  return SpectrumProgressCircle(
    semanticLabel: 'Loading',
    value: context.knobs.double.slider(label: 'value', initialValue: 40, min: 0, max: 100, description: 'The value.'),
    isIndeterminate: context.knobs.object.segmented<bool>(
      label: 'isIndeterminate',
      options: [true, false],
      initialOption: false,
      description: 'Whether the circle shows an operation with an unknown duration.',
    ),
    staticColor: context.knobs.objectOrNull.dropdown<SpectrumStaticColor>(
      label: 'staticColor',
      options: SpectrumStaticColor.values,
      labelBuilder: (SpectrumStaticColor value) => value.name,
      description: 'Fixed white or black colors over images or colored backgrounds.',
    ),
  );
}
