import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCard)
Widget BuildCardPresentation(BuildContext context) {
  return SpectrumCard(
    variant: context.knobs.object.segmented<SpectrumCardVariant>(
      label: 'variant',
      options: SpectrumCardVariant.values,
      initialOption: SpectrumCardVariant.primary,
      labelBuilder: (SpectrumCardVariant value) => value.name,
      description: 'How the card stands out from the page.',
    ),
    density: context.knobs.object.segmented<VisualDensity>(
      label: 'density',
      options: [VisualDensity.compact, VisualDensity.standard, VisualDensity.comfortable],
      initialOption: VisualDensity.standard,
      labelBuilder: (VisualDensity value) {
        if (value == VisualDensity.compact) {
          return 'compact';
        } else if (value == VisualDensity.comfortable) {
          return 'spacious';
        } else {
          return 'regular';
        }
      },
      description: 'The space inside the card.',
    ),
    onTap: () => log('BuildCardPresentation card was tapped.'),
    preview: SpectrumCardPreview(
      child: SpectrumImage(uri: Uri.parse('https://picsum.photos/seed/card/480/320'), width: 480, height: 320),
    ),
    title: Text(context.knobs.string(label: 'title', initialValue: 'Desert sunset', description: 'The title.')),
    description: Text(
      context.knobs.string(label: 'description', initialValue: 'PNG • 2/3/2024', description: 'The description.'),
    ),
    menu: SpectrumActionMenu(
      icon: SpectrumIcon(SpectrumIcons.more),
      isQuiet: true,
      label: 'Actions',
      children: [
        SpectrumMenuItem(child: Text('Rename')),
        SpectrumMenuItem(child: Text('Delete')),
      ],
    ),
    footer: SpectrumCardFooter(
      children: [
        SpectrumStatusLight(variant: SpectrumStatusVariant.positive, child: Text('Published')),
        SpectrumButton(content: 'Open', variant: SpectrumButtonVariant.secondary, onTap: () {}),
      ],
    ),
  );
}
