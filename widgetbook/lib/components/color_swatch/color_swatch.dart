import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorSwatch)
Widget BuildColorSwatchPresentation(BuildContext context) {
  return SpectrumColorSwatch(
    color: Color(
      context.knobs.int.slider(label: 'alpha', initialValue: 255, min: 0, max: 255, description: 'The opacity.') << 24 |
          0x0D66D0,
    ),
    colorName: 'Blue',
    rounding: context.knobs.object.segmented<SpectrumColorSwatchRounding>(
      label: 'rounding',
      options: SpectrumColorSwatchRounding.values,
      initialOption: SpectrumColorSwatchRounding.small,
      labelBuilder: (SpectrumColorSwatchRounding value) => value.name,
      description: 'The corners of the swatch.',
    ),
  );
}

@widgetbook.UseCase(name: 'Transparent and Empty', type: SpectrumColorSwatch)
Widget BuildColorSwatchTransparent(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: [
      SpectrumColorSwatch(color: const Color(0xFFE34850), colorName: 'Red'),
      SpectrumColorSwatch(color: const Color(0x80E34850), colorName: 'Red at 50%'),
      SpectrumColorSwatch(color: const Color(0x00000000), colorName: 'No color'),
    ],
  );
}
