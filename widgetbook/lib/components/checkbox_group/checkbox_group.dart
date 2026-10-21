import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCheckboxGroup)
Widget BuildCheckboxGroupPresentation(BuildContext context) {
  return SpectrumCheckboxGroup(
    label: Text('Favorite sports'),
    description: Text('Select all that apply.'),
    errorMessage: Text('Select at least one sport.'),
    value: const [0],
    orientation: context.knobs.object.segmented<Axis>(
      label: 'orientation',
      options: Axis.values,
      initialOption: Axis.vertical,
      labelBuilder: (Axis value) => value.name,
      description: 'Checkboxes stacked or side by side.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the checked boxes are blue.',
    ),
    isInvalid: context.knobs.object.segmented<bool>(
      label: 'isInvalid',
      options: [true, false],
      initialOption: false,
      description: 'Whether the group shows the error.',
    ),
    onChange: (value) => log('BuildCheckboxGroupPresentation checked: $value.'),
    children: [
      SpectrumCheckbox(child: Text('Soccer')),
      SpectrumCheckbox(child: Text('Baseball')),
      SpectrumCheckbox(child: Text('Basketball')),
    ],
  );
}
