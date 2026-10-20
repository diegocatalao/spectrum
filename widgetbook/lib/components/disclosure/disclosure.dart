import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

bool _IsExpandedKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isExpanded',
    options: [true, false],
    initialOption: false,
    description: 'Whether the panel starts expanded.',
  );
}

bool _IsQuietKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isQuiet',
    options: [true, false],
    initialOption: false,
    description: 'Whether the disclosure should be displayed with a quiet style.',
  );
}

bool _IsDisabledKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isDisabled',
    options: [true, false],
    initialOption: false,
    description: 'Whether the disclosure is grayed out and ignores hover and tap.',
  );
}

bool _HasActionsKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'actions',
    options: [true, false],
    initialOption: false,
    description: 'Whether action buttons are shown on the right of the header.',
  );
}

String _TitleKnobsFn(BuildContext context) {
  return context.knobs.string(
    label: 'title',
    initialValue: 'Personal Information',
    description: 'Text shown on the right of the chevron.',
  );
}

VisualDensity _DensityKnobsFn(BuildContext context) {
  return context.knobs.object.dropdown<VisualDensity>(
    label: 'density',
    options: [VisualDensity.comfortable, VisualDensity.compact, VisualDensity.standard],
    initialOption: VisualDensity.standard,
    description: 'Vertical and horizontal compactness of the header.',
    // VisualDensity has no name, so its toString() would be shown,
    // with the horizontal and vertical values in a long text.
    labelBuilder: (VisualDensity value) {
      switch (value) {
        case VisualDensity.comfortable:
          return 'comfortable';
        case VisualDensity.compact:
          return 'compact';
        case VisualDensity.standard:
        default:
          return 'standard';
      }
    },
  );
}

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDisclosure)
Widget BuildDisclosurePresentation(BuildContext context) {
  final List<SpectrumActionButton> actions;

  if (_HasActionsKnobsFn(context)) {
    // When the actions knob is True, an Edit button is shown on the right
    // of the header, outside of its hover area, to check the spacing
    // between the title and the actions.
    actions = [
      SpectrumActionButton(
        icon: SpectrumIcon(SpectrumIcons.edit),
        child: Text("Edit"),
        onTap: () => log("BuildDisclosurePresentation button 'EDIT' was tapped."),
      ),
    ];
  } else {
    // When the actions knob is False, the header only has
    // the chevron and the title, as in most disclosures.
    actions = [];
  }

  return SpectrumDisclosure(
    density: _DensityKnobsFn(context),
    isExpanded: _IsExpandedKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    onExpandedChange: (value) => log("BuildDisclosurePresentation expanded: $value."),
    header: SpectrumDisclosureHeader(
      actions: actions,
      child: SpectrumDisclosureTitle(child: Text(_TitleKnobsFn(context))),
    ),
    panel: SpectrumDisclosurePanel(child: Text('Personal information from here.')),
  );
}
