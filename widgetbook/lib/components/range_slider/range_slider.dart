import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumRangeSlider)
Widget BuildRangeSliderPresentation(BuildContext context) {
  return SizedBox(
    width: 280,
    child: SpectrumRangeSlider(
      label: Text('Price'),
      value: const RangeValues(30, 70),
      formatValue: (value) => '\$${value.round()}',
      labelPosition: context.knobs.object.segmented<SpectrumLabelPosition>(
        label: 'labelPosition',
        options: SpectrumLabelPosition.values,
        initialOption: SpectrumLabelPosition.top,
        labelBuilder: (SpectrumLabelPosition value) => value.name,
        description: 'Where the label is placed.',
      ),
      onChangeEnd: (value) => log('BuildRangeSliderPresentation range: $value.'),
    ),
  );
}
