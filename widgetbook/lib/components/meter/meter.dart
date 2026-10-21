import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumMeter)
Widget BuildMeterPresentation(BuildContext context) {
  return SpectrumMeter(
    label: Text(context.knobs.string(label: 'label', initialValue: 'Storage space', description: 'The label.')),
    value: context.knobs.double.slider(label: 'value', initialValue: 35, min: 0, max: 100, description: 'The value.'),
    variant: context.knobs.object.segmented<SpectrumMeterVariant>(
      label: 'variant',
      options: SpectrumMeterVariant.values,
      initialOption: SpectrumMeterVariant.informative,
      labelBuilder: (SpectrumMeterVariant value) => value.name,
      description: 'The meaning of the value.',
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

@widgetbook.UseCase(name: 'Value Label', type: SpectrumMeter)
Widget BuildMeterValueLabel(BuildContext context) {
  return SpectrumMeter(
    label: Text('Storage space'),
    value: 92,
    variant: SpectrumMeterVariant.negative,
    valueLabel: Text('92 of 100 GB'),
  );
}
