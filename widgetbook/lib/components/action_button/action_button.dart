import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

bool _IsQuietKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isQuiet',
    options: [true, false],
    initialOption: false,
    description: 'Whether the gray background only appears on hover and tap.',
  );
}

bool _IsDisabledKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isDisabled',
    options: [true, false],
    initialOption: false,
    description: 'Whether the button is disabled.',
  );
}

@widgetbook.UseCase(name: 'Presentation', type: SpectrumActionButton)
Widget BuildActionButtonPresentation(BuildContext context) {
  return SpectrumActionButton(
    icon: SpectrumIcon(
      context.knobs.object.dropdown<SpectrumIcons>(
        label: 'icon',
        options: SpectrumIcons.values,
        initialOption: SpectrumIcons.edit,
        labelBuilder: (SpectrumIcons value) => value.name,
        description: 'The icon shown on the left of the text.',
      ),
    ),
    label: 'Edit',
    toggles: context.knobs.object.segmented<bool>(
      label: 'toggles',
      options: [true, false],
      initialOption: false,
      description: 'Whether each tap switches the selection on and off.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the selected button uses the accent blue.',
    ),
    isQuiet: _IsQuietKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    onTap: () => log('BuildActionButtonPresentation button was tapped.'),
    child: Text(context.knobs.string(label: 'content', initialValue: 'Edit', description: 'The text of the button.')),
  );
}

@widgetbook.UseCase(name: 'Icon Only', type: SpectrumActionButton)
Widget BuildActionButtonIconOnly(BuildContext context) {
  // Without a text, the label is the only name screen readers can read.
  return SpectrumActionButton(
    icon: SpectrumIcon(SpectrumIcons.textBold),
    label: 'Bold',
    toggles: true,
    isQuiet: _IsQuietKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
  );
}

@widgetbook.UseCase(name: 'Hold', type: SpectrumActionButton)
Widget BuildActionButtonHold(BuildContext context) {
  // onLongPress shows the hold affordance triangle in the bottom right corner.
  return SpectrumActionButton(
    icon: SpectrumIcon(SpectrumIcons.more),
    label: 'More',
    isQuiet: _IsQuietKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    onTap: () => log('BuildActionButtonHold button was tapped.'),
    onLongPress: () => log('BuildActionButtonHold button was held.'),
  );
}
