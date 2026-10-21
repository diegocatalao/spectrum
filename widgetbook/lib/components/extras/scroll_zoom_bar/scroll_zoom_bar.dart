import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumScrollZoomBar)
Widget BuildScrollZoomBarPresentation(BuildContext context) {
  return SizedBox(
    width: 480,
    child: SpectrumScrollZoomBar(
      value: const RangeValues(0.2, 0.6),
      onChange: (value) => log('BuildScrollZoomBarPresentation visible: $value.'),
    ),
  );
}
