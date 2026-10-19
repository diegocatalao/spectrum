import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

bool _IsOpenKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isOpen',
    options: [true, false],
    initialOption: true,
    description: 'Whether the bar is shown.',
  );
}

bool _IsEmphasizedKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isEmphasized',
    options: [true, false],
    initialOption: false,
    description: 'Whether the bar uses the accent blue instead of the gray surface.',
  );
}

int _SelectedCountKnobsFn(BuildContext context) {
  return context.knobs.int.slider(
    label: 'selectedCount',
    initialValue: 2,
    min: 0,
    max: 100,
    description: 'Number of selected items, shown as "N items selected".',
  );
}

@widgetbook.UseCase(name: 'Presentation', type: SpectrumActionBar)
Widget BuildActionBarPresentation(BuildContext context) {
  return SpectrumActionBar(
    isOpen: _IsOpenKnobsFn(context),
    isEmphasized: _IsEmphasizedKnobsFn(context),
    selectedCount: _SelectedCountKnobsFn(context),
    onClose: () => log("BuildActionBarPresentation close button was tapped."),
    children: [
      SpectrumActionButton(
        icon: SpectrumIcon(SpectrumIcons.edit),
        label: "Edit",
        onTap: () => log("BuildActionBarPresentation button 'EDIT' was tapped."),
      ),
      SpectrumActionButton(
        icon: SpectrumIcon(SpectrumIcons.delete),
        label: "Delete",
        onTap: () => log("BuildActionBarPresentation button 'DELETE' was tapped."),
      ),
      SpectrumActionButton(
        icon: SpectrumIcon(SpectrumIcons.more),
        label: "More",
        onTap: () => log("BuildActionBarPresentation button 'MORE' was tapped."),
      ),
    ],
  );
}
