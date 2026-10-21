import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorField)
Widget BuildColorFieldPresentation(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumColorField(
      label: Text('Brand color'),
      value: const Color(0xFF2D9D78),
      description: Text('Type a color like #2D9D78.'),
      errorMessage: Text('Type a valid hexadecimal color.'),
      onChange: (value) => log('BuildColorFieldPresentation color: $value.'),
    ),
  );
}
