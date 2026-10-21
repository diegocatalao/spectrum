import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDateField)
Widget BuildDateFieldPresentation(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumDateField(
      label: Text('Birth date'),
      description: Text('Type the day, the month and the year.'),
      errorMessage: Text('Enter a date in 2026.'),
      minValue: DateTime(2026),
      maxValue: DateTime(2026, 12, 31),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether the field is disabled.',
      ),
      onChange: (value) => log('BuildDateFieldPresentation date: $value.'),
    ),
  );
}
