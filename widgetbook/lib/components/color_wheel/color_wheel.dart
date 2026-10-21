import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorWheel)
Widget BuildColorWheelPresentation(BuildContext context) {
  return SpectrumColorWheel(
    value: const Color(0xFFE34850),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the wheel is disabled.',
    ),
    onChangeEnd: (value) => log('BuildColorWheelPresentation color: $value.'),
  );
}
