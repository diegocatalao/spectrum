import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorLoupe)
Widget BuildColorLoupePresentation(BuildContext context) {
  return SpectrumColorLoupe(
    color: Color(
      context.knobs.int.slider(label: 'alpha', initialValue: 255, min: 0, max: 255, description: 'The opacity.') << 24 |
          0xE34850,
    ),
    isOpen: context.knobs.object.segmented<bool>(
      label: 'isOpen',
      options: [true, false],
      initialOption: true,
      description: 'Whether the loupe is shown.',
    ),
  );
}
