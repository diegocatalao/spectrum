import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumToggleButton)
Widget BuildToggleButtonPresentation(BuildContext context) {
  return SpectrumToggleButton(
    icon: SpectrumIcon(SpectrumIcons.star),
    isSelected: context.knobs.object.segmented<bool>(
      label: 'isSelected',
      options: [true, false],
      initialOption: false,
      description: 'Whether the button starts selected.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the selected button is filled with the accent blue.',
    ),
    isQuiet: context.knobs.object.segmented<bool>(
      label: 'isQuiet',
      options: [true, false],
      initialOption: false,
      description: 'Whether the unselected button has no background.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the button is disabled.',
    ),
    onChanged: (value) => log('BuildToggleButtonPresentation selected: $value.'),
    child: Text(context.knobs.string(label: 'content', initialValue: 'Favorite', description: 'The text.')),
  );
}
