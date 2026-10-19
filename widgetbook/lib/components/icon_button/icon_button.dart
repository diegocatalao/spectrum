import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumIconButton)
Widget BuildIconButtonPresentation(BuildContext context) {
  final isDisabled = context.knobs.object.segmented<bool>(
    label: 'isDisabled',
    options: [true, false],
    initialOption: false,
    description: 'Whether the button is disabled, which removes its onPressed.',
  );
  final VoidCallback? onPressed;

  if (isDisabled) {
    // When isDisabled is True, onPressed is null, which disables the button.
    onPressed = null;
  } else {
    // Otherwise the tap is logged in the console.
    onPressed = () => log('BuildIconButtonPresentation button was tapped.');
  }

  return SpectrumIconButton(
    icon: SpectrumIcon(
      context.knobs.object.dropdown<SpectrumIcons>(
        label: 'icon',
        options: SpectrumIcons.values,
        initialOption: SpectrumIcons.edit,
        labelBuilder: (SpectrumIcons value) => value.name,
        description: 'The icon of the button.',
      ),
    ),
    tooltip: context.knobs.string(
      label: 'tooltip',
      initialValue: 'Edit',
      description: 'The text shown on hover and read by screen readers.',
    ),
    emphasized: context.knobs.object.segmented<bool>(
      label: 'emphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the button uses the accent background.',
    ),
    onPressed: onPressed,
  );
}
