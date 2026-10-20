import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumProgressBar)
Widget BuildProgressBarPresentation(BuildContext context) {
  return SpectrumProgressBar(
    label: Text(context.knobs.string(label: 'label', initialValue: 'Loading', description: 'The label of the bar.')),
    value: context.knobs.double.slider(label: 'value', initialValue: 40, min: 0, max: 100, description: 'The value.'),
    isIndeterminate: context.knobs.object.segmented<bool>(
      label: 'isIndeterminate',
      options: [true, false],
      initialOption: false,
      description: 'Whether the bar shows an operation with an unknown duration.',
    ),
    labelPosition: context.knobs.object.segmented<SpectrumLabelPosition>(
      label: 'labelPosition',
      options: SpectrumLabelPosition.values,
      initialOption: SpectrumLabelPosition.top,
      labelBuilder: (SpectrumLabelPosition value) => value.name,
      description: 'Where the label is placed.',
    ),
  );
}

@widgetbook.UseCase(name: 'Value Label', type: SpectrumProgressBar)
Widget BuildProgressBarValueLabel(BuildContext context) {
  return SpectrumProgressBar(label: Text('Uploading'), value: 3, maxValue: 10, valueLabel: Text('3 of 10 files'));
}

@widgetbook.UseCase(name: 'Static Color', type: SpectrumProgressBar)
Widget BuildProgressBarStaticColor(BuildContext context) {
  final staticColor = context.knobs.object.segmented<SpectrumStaticColor>(
    label: 'staticColor',
    options: SpectrumStaticColor.values,
    initialOption: SpectrumStaticColor.white,
    labelBuilder: (SpectrumStaticColor value) => value.name,
    description: 'Fixed white or black colors over images or colored backgrounds.',
  );

  // A dark gradient behind the white bar and a light one behind the black bar.
  final List<Color> gradient;

  if (staticColor == SpectrumStaticColor.white) {
    gradient = [const Color(0xFF0D66D0), const Color(0xFF6E3BD0)];
  } else {
    gradient = [const Color(0xFFFDE68A), const Color(0xFF9DE6C9)];
  }

  return Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: gradient),
      borderRadius: BorderRadius.circular(8),
    ),
    child: SpectrumProgressBar(label: Text('Loading'), value: 60, staticColor: staticColor),
  );
}
