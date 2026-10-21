import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumToggleButtonGroup)
Widget BuildToggleButtonGroupPresentation(BuildContext context) {
  return SpectrumToggleButtonGroup(
    selects: context.knobs.object.segmented<SpectrumSelects>(
      label: 'selects',
      options: [SpectrumSelects.single, SpectrumSelects.multiple],
      initialOption: SpectrumSelects.single,
      labelBuilder: (SpectrumSelects value) => value.name,
      description: 'Whether one or many buttons can be selected.',
    ),
    density: context.knobs.object.segmented<VisualDensity>(
      label: 'density',
      options: [VisualDensity.compact, VisualDensity.standard],
      initialOption: VisualDensity.standard,
      labelBuilder: (VisualDensity value) => value == VisualDensity.compact ? 'compact' : 'regular',
      description: 'The space between the buttons.',
    ),
    axis: context.knobs.object.segmented<Axis>(
      label: 'axis',
      options: Axis.values,
      initialOption: Axis.horizontal,
      labelBuilder: (Axis value) => value.name,
      description: 'The direction of the buttons.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the selected buttons are filled with the accent blue.',
    ),
    selected: const [0],
    onSelectionChange: (value) => log('BuildToggleButtonGroupPresentation selected: $value.'),
    children: [
      SpectrumToggleButton(icon: SpectrumIcon(SpectrumIcons.textAlignLeft), child: Text('Left')),
      SpectrumToggleButton(icon: SpectrumIcon(SpectrumIcons.textAlignCenter), child: Text('Center')),
      SpectrumToggleButton(icon: SpectrumIcon(SpectrumIcons.textAlignRight), child: Text('Right')),
    ],
  );
}
