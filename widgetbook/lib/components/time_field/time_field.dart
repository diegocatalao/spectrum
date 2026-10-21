import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTimeField)
Widget BuildTimeFieldPresentation(BuildContext context) {
  return SizedBox(
    width: 200,
    child: SpectrumTimeField(
      label: Text('Event time'),
      value: const TimeOfDay(hour: 14, minute: 30),
      is24Hours: context.knobs.object.segmented<bool>(
        label: 'is24Hours',
        options: [true, false],
        initialOption: false,
        description: 'Whether the hours go from 0 to 23.',
      ),
      onChange: (value) => log('BuildTimeFieldPresentation time: $value.'),
    ),
  );
}
