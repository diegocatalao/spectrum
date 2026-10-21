import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSlider)
Widget BuildSliderPresentation(BuildContext context) {
  return SizedBox(
    width: 280,
    child: SpectrumSlider(
      label: Text('Volume'),
      value: 40,
      isEmphasized: context.knobs.object.segmented<bool>(
        label: 'isEmphasized',
        options: [true, false],
        initialOption: false,
        description: 'Whether the fill is blue.',
      ),
      isThick: context.knobs.object.segmented<bool>(
        label: 'isThick',
        options: [true, false],
        initialOption: false,
        description: 'Whether the track is 16px thick.',
      ),
      isPrecise: context.knobs.object.segmented<bool>(
        label: 'isPrecise',
        options: [true, false],
        initialOption: false,
        description: 'Whether the thumb is a narrow bar.',
      ),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether the slider is disabled.',
      ),
      onChangeEnd: (value) => log('BuildSliderPresentation value: $value.'),
    ),
  );
}

@widgetbook.UseCase(name: 'Fill Offset', type: SpectrumSlider)
Widget BuildSliderFillOffset(BuildContext context) {
  return SizedBox(
    width: 280,
    child: SpectrumSlider(
      label: Text('Exposure'),
      minValue: -5,
      maxValue: 5,
      step: 0.1,
      value: 1.5,
      fillOffset: 0,
      formatValue: (value) => value > 0 ? '+${value.toStringAsFixed(1)}' : value.toStringAsFixed(1),
    ),
  );
}
