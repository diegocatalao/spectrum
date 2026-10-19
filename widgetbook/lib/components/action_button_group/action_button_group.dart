import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumActionButtonGroup)
Widget BuildActionButtonGroupPresentation(BuildContext context) {
  return SpectrumActionButtonGroup(
    label: 'Text formatting',
    isQuiet: context.knobs.object.segmented<bool>(
      label: 'isQuiet',
      options: [true, false],
      initialOption: false,
      description: 'Whether every button of the group is quiet.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether selected buttons use the accent blue.',
    ),
    isCompact: context.knobs.object.segmented<bool>(
      label: 'isCompact',
      options: [true, false],
      initialOption: false,
      description: 'Whether the buttons touch each other without spacing.',
    ),
    isVertical: context.knobs.object.segmented<bool>(
      label: 'isVertical',
      options: [true, false],
      initialOption: false,
      description: 'Whether the buttons are stacked in a column.',
    ),
    selects: context.knobs.object.segmented<SpectrumSelects>(
      label: 'selects',
      options: SpectrumSelects.values,
      initialOption: SpectrumSelects.multiple,
      labelBuilder: (SpectrumSelects value) => value.name,
      description: 'How the group manages the selection of its buttons.',
    ),
    // The selection comes from the knob, so it can be changed in the panel.
    selected: context.knobs.iterable
        .segmented<int>(
          label: 'selected',
          options: [0, 1, 2],
          initialOption: [0],
          description: 'Indexes of the selected buttons.',
        )
        .toList(),
    onChanged: (value) => log('BuildActionButtonGroupPresentation selection changed to $value.'),
    children: [
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.textBold)),
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.textItalic)),
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.textUnderline)),
    ],
  );
}
