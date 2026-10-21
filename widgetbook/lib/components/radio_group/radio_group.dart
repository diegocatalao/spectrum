import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumRadioGroup)
Widget BuildRadioGroupPresentation(BuildContext context) {
  return SpectrumRadioGroup(
    label: Text('Favorite pet'),
    description: Text('Choose one.'),
    errorMessage: Text('Choose a pet.'),
    value: 'dogs',
    orientation: context.knobs.object.segmented<Axis>(
      label: 'orientation',
      options: Axis.values,
      initialOption: Axis.vertical,
      labelBuilder: (Axis value) => value.name,
      description: 'Radios stacked or side by side.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the selected radio is blue.',
    ),
    isInvalid: context.knobs.object.segmented<bool>(
      label: 'isInvalid',
      options: [true, false],
      initialOption: false,
      description: 'Whether the group shows the error.',
    ),
    onChange: (value) => log('BuildRadioGroupPresentation selected: $value.'),
    children: [
      SpectrumRadio(value: 'dogs', child: Text('Dogs')),
      SpectrumRadio(value: 'cats', child: Text('Cats')),
      SpectrumRadio(value: 'dragons', isDisabled: true, child: Text('Dragons')),
    ],
  );
}
