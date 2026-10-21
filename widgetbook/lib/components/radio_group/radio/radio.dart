import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumRadio)
Widget BuildRadioPresentation(BuildContext context) {
  return SpectrumRadioGroup(
    value: context.knobs.object.segmented<String>(
      label: 'selected',
      options: ['first', 'second'],
      initialOption: 'first',
      description: 'The radio selected in the group.',
    ),
    children: [
      SpectrumRadio(value: 'first', child: Text('First option')),
      SpectrumRadio(
        value: 'second',
        isDisabled: context.knobs.object.segmented<bool>(
          label: 'isDisabled',
          options: [true, false],
          initialOption: false,
          description: 'Whether the second radio is disabled.',
        ),
        child: Text('Second option'),
      ),
    ],
  );
}
