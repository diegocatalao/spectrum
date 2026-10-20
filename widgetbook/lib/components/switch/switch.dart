import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSwitch)
Widget BuildSwitchPresentation(BuildContext context) {
  final description = context.knobs.string(
    label: 'description',
    initialValue: '',
    description: 'The text below the switch. Empty hides it.',
  );

  return SpectrumSwitch(
    isSelected: context.knobs.object.segmented<bool>(
      label: 'isSelected',
      options: [true, false],
      initialOption: false,
      description: 'Whether the switch starts on.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the track is filled with the accent blue when on.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the switch is disabled.',
    ),
    onChanged: (value) => log('BuildSwitchPresentation selected: $value.'),
    description: description.isEmpty ? null : Text(description),
    child: Text(
      context.knobs.string(label: 'content', initialValue: 'Low power mode', description: 'The label of the switch.'),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: SpectrumSwitch)
Widget BuildSwitchStates(BuildContext context) {
  // One row per style and one column per state, to compare all the switches at once.
  final rows = [('Default', false, false), ('Emphasized', true, false), ('Disabled', false, true)];

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 16,
    children: [
      for (final (name, isEmphasized, isDisabled) in rows)
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            SizedBox(width: 96, child: Text(name)),
            SpectrumSwitch(isEmphasized: isEmphasized, isDisabled: isDisabled),
            SpectrumSwitch(isSelected: true, isEmphasized: isEmphasized, isDisabled: isDisabled),
          ],
        ),
    ],
  );
}
