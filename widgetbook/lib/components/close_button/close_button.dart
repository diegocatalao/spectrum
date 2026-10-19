import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCloseButton)
Widget BuildCloseButtonPresentation(BuildContext context) {
  return SpectrumCloseButton(
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the button is disabled.',
    ),
    onTap: () => log('BuildCloseButtonPresentation button was tapped.'),
  );
}
