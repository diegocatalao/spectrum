import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumRating)
Widget BuildRatingPresentation(BuildContext context) {
  return SpectrumRating(
    value: context.knobs.int.slider(label: 'value', initialValue: 3, min: 0, max: 5, description: 'The score.'),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the stars are blue.',
    ),
    isReadOnly: context.knobs.object.segmented<bool>(
      label: 'isReadOnly',
      options: [true, false],
      initialOption: false,
      description: 'Whether the score can not be changed.',
    ),
    onChange: (value) => log('BuildRatingPresentation score: $value.'),
  );
}
