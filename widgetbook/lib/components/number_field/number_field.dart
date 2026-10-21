import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumNumberField)
Widget BuildNumberFieldPresentation(BuildContext context) {
  return SizedBox(
    width: 200,
    child: SpectrumNumberField(
      label: Text('Width'),
      value: 24,
      minValue: 0,
      maxValue: 100,
      step: context.knobs.double.slider(label: 'step', initialValue: 1, min: 0.5, max: 10, description: 'The step.'),
      hideStepper: context.knobs.object.segmented<bool>(
        label: 'hideStepper',
        options: [true, false],
        initialOption: false,
        description: 'Whether the decrease and increase buttons are hidden.',
      ),
      description: Text('Between 0 and 100.'),
      onChanged: (value) => log('BuildNumberFieldPresentation value: $value.'),
    ),
  );
}
