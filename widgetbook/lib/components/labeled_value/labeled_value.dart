import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumLabeledValue)
Widget BuildLabeledValuePresentation(BuildContext context) {
  return SizedBox(
    width: 320,
    child: SpectrumForm(
      children: [
        SpectrumLabeledValue(label: Text('File name'), value: Text('Sunset.png')),
        SpectrumLabeledValue(label: Text('Size'), value: Text('2.4 MB')),
        SpectrumTextField(label: Text('Title'), value: 'Desert sunset'),
      ],
    ),
  );
}
