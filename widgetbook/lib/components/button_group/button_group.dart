import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumButtonGroup)
Widget BuildButtonGroupPresentation(BuildContext context) {
  return SpectrumButtonGroup(
    orientation: context.knobs.object.segmented<Axis>(
      label: 'orientation',
      options: Axis.values,
      initialOption: Axis.horizontal,
      labelBuilder: (Axis value) => value.name,
      description: 'Direction of the buttons. Horizontal groups turn vertical on overflow.',
    ),
    alignment: context.knobs.object.segmented<OverflowBarAlignment>(
      label: 'alignment',
      options: OverflowBarAlignment.values,
      initialOption: OverflowBarAlignment.start,
      labelBuilder: (OverflowBarAlignment value) => value.name,
      description: 'Position of the buttons inside the group.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether every button of the group is disabled.',
    ),
    children: [
      SpectrumButton(
        content: 'Rate now',
        variant: SpectrumButtonVariant.accent,
        onTap: () => log("BuildButtonGroupPresentation button 'RATE NOW' was tapped."),
      ),
      SpectrumButton(
        content: 'No, thanks',
        variant: SpectrumButtonVariant.secondary,
        isOutline: true,
        onTap: () => log("BuildButtonGroupPresentation button 'NO, THANKS' was tapped."),
      ),
      SpectrumButton(
        content: 'Remind me later',
        variant: SpectrumButtonVariant.secondary,
        isOutline: true,
        onTap: () => log("BuildButtonGroupPresentation button 'REMIND ME LATER' was tapped."),
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'Overflow', type: SpectrumButtonGroup)
Widget BuildButtonGroupOverflow(BuildContext context) {
  // A narrow container where the buttons do not fit in a row,
  // so the group moves all of them to a column.
  return SizedBox(
    width: context.knobs.double.slider(
      label: 'width',
      initialValue: 240,
      min: 120,
      max: 600,
      description: 'Width available to the group.',
    ),
    child: SpectrumButtonGroup(
      children: [
        SpectrumButton(content: 'Rate now', variant: SpectrumButtonVariant.accent, onTap: () {}),
        SpectrumButton(content: 'No, thanks', variant: SpectrumButtonVariant.secondary, isOutline: true, onTap: () {}),
        SpectrumButton(
          content: 'Remind me later',
          variant: SpectrumButtonVariant.secondary,
          isOutline: true,
          onTap: () {},
        ),
      ],
    ),
  );
}
