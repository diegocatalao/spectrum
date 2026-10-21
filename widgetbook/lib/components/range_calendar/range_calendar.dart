import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumRangeCalendar)
Widget BuildRangeCalendarPresentation(BuildContext context) {
  final today = DateTime.now();

  return SpectrumRangeCalendar(
    value: DateTimeRange(start: today, end: today.add(const Duration(days: 4))),
    visibleMonths: context.knobs.int.slider(
      label: 'visibleMonths',
      initialValue: 2,
      min: 1,
      max: 3,
      description: 'Months.',
    ),
    isInvalid: context.knobs.object.segmented<bool>(
      label: 'isInvalid',
      options: [true, false],
      initialOption: false,
      description: 'Whether the selection is shown in red with the error message.',
    ),
    errorMessage: Text('The trip can not be longer than two weeks.'),
    onChange: (value) => log('BuildRangeCalendarPresentation selected: $value.'),
  );
}
