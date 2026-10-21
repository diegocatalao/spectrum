import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCalendar)
Widget BuildCalendarPresentation(BuildContext context) {
  final today = DateTime.now();

  return SpectrumCalendar(
    value: today,
    visibleMonths: context.knobs.int.slider(
      label: 'visibleMonths',
      initialValue: 1,
      min: 1,
      max: 3,
      description: 'Months.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the calendar is disabled.',
    ),
    isInvalid: context.knobs.object.segmented<bool>(
      label: 'isInvalid',
      options: [true, false],
      initialOption: false,
      description: 'Whether the selection is shown in red with the error message.',
    ),
    errorMessage: Text('Select a weekday.'),
    // Weekends are unavailable and the next 60 days are the only ones in bounds.
    isDateUnavailable: (day) => day.weekday >= DateTime.saturday,
    minValue: today,
    maxValue: today.add(const Duration(days: 60)),
    onChange: (value) => log('BuildCalendarPresentation selected: $value.'),
  );
}
