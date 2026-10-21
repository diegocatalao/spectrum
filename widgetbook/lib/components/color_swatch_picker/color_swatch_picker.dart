import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorSwatchPicker)
Widget BuildColorSwatchPickerPresentation(BuildContext context) {
  const palette = [
    Color(0xFFE34850),
    Color(0xFFF29423),
    Color(0xFFF9D72E),
    Color(0xFF2D9D78),
    Color(0xFF0D66D0),
    Color(0xFF6E3BD0),
    Color(0xFFD83790),
    Color(0xFF6E6E6E),
  ];

  return SizedBox(
    width: 160,
    child: SpectrumColorSwatchPicker(
      value: palette[4],
      density: context.knobs.object.dropdown<VisualDensity>(
        label: 'density',
        options: [VisualDensity.compact, VisualDensity.standard, VisualDensity.comfortable],
        initialOption: VisualDensity.standard,
        labelBuilder: (VisualDensity value) {
          if (value == VisualDensity.compact) {
            return 'compact';
          } else if (value == VisualDensity.comfortable) {
            return 'spacious';
          } else {
            return 'regular';
          }
        },
        description: 'The space between the swatches.',
      ),
      rounding: context.knobs.object.segmented<SpectrumColorSwatchRounding>(
        label: 'rounding',
        options: SpectrumColorSwatchRounding.values,
        initialOption: SpectrumColorSwatchRounding.small,
        labelBuilder: (SpectrumColorSwatchRounding value) => value.name,
        description: 'The corners of the swatches.',
      ),
      onChange: (value) => log('BuildColorSwatchPickerPresentation selected: $value.'),
      children: [for (final color in palette) SpectrumColorSwatch(color: color)],
    ),
  );
}
