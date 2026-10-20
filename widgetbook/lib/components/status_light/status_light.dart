import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumStatusLight)
Widget BuildStatusLightPresentation(BuildContext context) {
  return SpectrumStatusLight(
    variant: context.knobs.object.dropdown<SpectrumStatusVariant>(
      label: 'variant',
      options: SpectrumStatusVariant.values,
      initialOption: SpectrumStatusVariant.positive,
      labelBuilder: (SpectrumStatusVariant value) => value.name,
      description: 'The color of the dot.',
    ),
    isLive: context.knobs.object.segmented<bool>(
      label: 'isLive',
      options: [true, false],
      initialOption: false,
      description: 'Whether screen readers announce the label when it changes.',
    ),
    child: Text(
      context.knobs.string(label: 'content', initialValue: 'Approved', description: 'The label of the status.'),
    ),
  );
}

@widgetbook.UseCase(name: 'Semantic Variants', type: SpectrumStatusLight)
Widget BuildStatusLightSemanticVariants(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      SpectrumStatusLight(variant: SpectrumStatusVariant.informative, child: Text('Active')),
      SpectrumStatusLight(variant: SpectrumStatusVariant.neutral, child: Text('Archived')),
      SpectrumStatusLight(variant: SpectrumStatusVariant.positive, child: Text('Approved')),
      SpectrumStatusLight(variant: SpectrumStatusVariant.notice, child: Text('Needs approval')),
      SpectrumStatusLight(variant: SpectrumStatusVariant.negative, child: Text('Rejected')),
    ],
  );
}

@widgetbook.UseCase(name: 'Categorical Variants', type: SpectrumStatusLight)
Widget BuildStatusLightCategoricalVariants(BuildContext context) {
  // The semantic variants are left out, since they have their own use case.
  final categories = SpectrumStatusVariant.values.skip(5);

  return Wrap(
    spacing: 16,
    runSpacing: 8,
    children: [for (final variant in categories) SpectrumStatusLight(variant: variant, child: Text(variant.name))],
  );
}

@widgetbook.UseCase(name: 'Long Label', type: SpectrumStatusLight)
Widget BuildStatusLightLongLabel(BuildContext context) {
  return SizedBox(
    width: 160,
    child: SpectrumStatusLight(
      variant: SpectrumStatusVariant.notice,
      child: Text('Waiting for the approval of the design team'),
    ),
  );
}
