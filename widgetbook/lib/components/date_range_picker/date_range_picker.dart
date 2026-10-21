import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDateRangePicker)
Widget BuildDateRangePickerPresentation(BuildContext context) {
  final today = DateTime.now();

  return SizedBox(
    width: 340,
    child: SpectrumDateRangePicker(
      label: Text('Trip dates'),
      value: DateTimeRange(start: today, end: today.add(const Duration(days: 6))),
      onChange: (value) => log('BuildDateRangePickerPresentation range: $value.'),
    ),
  );
}
