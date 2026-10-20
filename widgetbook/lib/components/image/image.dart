import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumImage)
Widget BuildImagePresentation(BuildContext context) {
  return SpectrumImage(
    uri: Uri.parse("https://picsum.photos/400/300"),
    semanticLabel: context.knobs.string(
      label: 'semanticLabel',
      initialValue: 'A random picture',
      description: 'The text read by screen readers.',
    ),
    width: context.knobs.double.slider(label: 'width', initialValue: 400, min: 80, max: 600, description: 'The width.'),
    height: context.knobs.double.slider(
      label: 'height',
      initialValue: 300,
      min: 80,
      max: 600,
      description: 'The height.',
    ),
    fit: context.knobs.object.dropdown<BoxFit>(
      label: 'fit',
      options: BoxFit.values,
      initialOption: BoxFit.cover,
      labelBuilder: (BoxFit value) => value.name,
      description: 'How the image fills its box.',
    ),
    borderRadius: BorderRadius.circular(
      context.knobs.double.slider(
        label: 'borderRadius',
        initialValue: 8,
        min: 0,
        max: 32,
        description: 'The radius of the corners.',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Loading error', type: SpectrumImage)
Widget BuildImageOnError(BuildContext context) {
  return SpectrumImage(
    uri: Uri.parse("https://badsite.com/"),
    width: 400,
    height: 300,
    borderRadius: BorderRadius.circular(8),
  );
}
