import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDatePicker)
Widget BuildDatePickerPresentation(BuildContext context) {
  return SizedBox(
    width: 260,
    child: SpectrumDatePicker(
      label: Text('Delivery date'),
      value: DateTime.now(),
      isDateUnavailable: (day) => day.weekday == DateTime.sunday,
      onChange: (value) => log('BuildDatePickerPresentation date: $value.'),
    ),
  );
}
