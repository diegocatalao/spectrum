import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumActionButtonGroup)
Widget BuildActionButtonGroupPresentation(BuildContext context) {
  // A fixed width shows how the buttons shrink when they do not fit.
  return SpectrumActionButtonGroup(
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether every button of the group is disabled.',
    ),
    staticColor: context.knobs.objectOrNull.dropdown<SpectrumStaticColor>(
      label: 'staticColor',
      options: SpectrumStaticColor.values,
      labelBuilder: (SpectrumStaticColor value) => value.name,
      description: 'Fixed white or black colors for groups over images or colored backgrounds.',
    ),
    isQuiet: context.knobs.object.segmented<bool>(
      label: 'isQuiet',
      options: [true, false],
      initialOption: false,
      description: 'Whether every button of the group is quiet.',
    ),
    density: context.knobs.object.dropdown<VisualDensity>(
      label: 'density',
      options: [VisualDensity.standard, VisualDensity.compact, VisualDensity.comfortable],
      initialOption: VisualDensity.standard,
      description: 'Compact makes the buttons touch each other with rounded outer corners.',
      labelBuilder: (VisualDensity value) {
        switch (value) {
          case VisualDensity.compact:
            return 'compact';
          case VisualDensity.comfortable:
            return 'comfortable';
          case VisualDensity.standard:
          default:
            return 'standard';
        }
      },
    ),
    children: [
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.textBold), onTap: () {}),
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.textItalic), onTap: () {}),
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.textUnderline), onTap: () {}),
    ],
  );
}
