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

bool _IsPendingKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isPending',
    options: [true, false],
    initialOption: false,
    description: 'Whether the button shows a loading circle after one second and ignores taps.',
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
    isQuiet: _IsQuietKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    isPending: _IsPendingKnobsFn(context),
    staticColor: context.knobs.objectOrNull.dropdown<SpectrumStaticColor>(
      label: 'staticColor',
      options: SpectrumStaticColor.values,
      labelBuilder: (SpectrumStaticColor value) => value.name,
      description: 'Fixed white or black colors for buttons over images or colored backgrounds.',
    ),
    onTap: () => log('BuildActionButtonPresentation button was tapped.'),
    child: Text(
      context.knobs.string(label: 'content', initialValue: 'Edit', description: 'The text of the button.'),
    ),
  );
}

@widgetbook.UseCase(name: 'Icon Only', type: SpectrumActionButton)
Widget BuildActionButtonIconOnly(BuildContext context) {
  return SpectrumActionButton(
    icon: SpectrumIcon(SpectrumIcons.textBold),
    isQuiet: _IsQuietKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    isPending: _IsPendingKnobsFn(context),
    onTap: () => log('BuildActionButtonIconOnly button was tapped.'),
  );
}
