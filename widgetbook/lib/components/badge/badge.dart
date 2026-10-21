import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumBadge)
Widget BuildBadgePresentation(BuildContext context) {
  return SpectrumBadge(
    icon: SpectrumIcon(SpectrumIcons.star),
    variant: context.knobs.object.dropdown<SpectrumBadgeVariant>(
      label: 'variant',
      options: SpectrumBadgeVariant.values,
      initialOption: SpectrumBadgeVariant.accent,
      labelBuilder: (SpectrumBadgeVariant value) => value.name,
      description: 'The color of the badge.',
    ),
    fillStyle: context.knobs.object.segmented<SpectrumBadgeFillStyle>(
      label: 'fillStyle',
      options: SpectrumBadgeFillStyle.values,
      initialOption: SpectrumBadgeFillStyle.bold,
      labelBuilder: (SpectrumBadgeFillStyle value) => value.name,
      description: 'How the badge is filled. Outline is only for the semantic variants.',
    ),
    child: Text(context.knobs.string(label: 'content', initialValue: 'New', description: 'The text of the badge.')),
  );
}

@widgetbook.UseCase(name: 'Variants', type: SpectrumBadge)
Widget BuildBadgeVariants(BuildContext context) {
  final fillStyle = context.knobs.object.segmented<SpectrumBadgeFillStyle>(
    label: 'fillStyle',
    options: SpectrumBadgeFillStyle.values,
    initialOption: SpectrumBadgeFillStyle.bold,
    labelBuilder: (SpectrumBadgeFillStyle value) => value.name,
    description: 'How the badges are filled.',
  );

  return SizedBox(
    width: 520,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final variant in SpectrumBadgeVariant.values)
          SpectrumBadge(variant: variant, fillStyle: fillStyle, child: Text(variant.name)),
      ],
    ),
  );
}
