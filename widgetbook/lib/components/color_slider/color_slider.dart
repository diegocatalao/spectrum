import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorSlider)
Widget BuildColorSliderPresentation(BuildContext context) {
  return SpectrumColorSlider(
    value: const Color(0xFF2D9D78),
    channel: context.knobs.object.segmented<SpectrumColorChannel>(
      label: 'channel',
      options: SpectrumColorChannel.values,
      initialOption: SpectrumColorChannel.hue,
      labelBuilder: (SpectrumColorChannel value) => value.name,
      description: 'The channel changed by the slider.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the slider is disabled.',
    ),
    onChangeEnd: (value) => log('BuildColorSliderPresentation color: $value.'),
  );
}
