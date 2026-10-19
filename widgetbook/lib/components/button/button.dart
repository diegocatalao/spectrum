import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumButton)
Widget BuildButtonPresentation(BuildContext context) {
  return SpectrumButton(
    content: context.knobs.string(
      label: 'content',
      initialValue: 'Save',
      description: 'The content to display in the Button.',
    ),
    variant: context.knobs.object.dropdown<SpectrumButtonVariant>(
      label: 'variant',
      description: "The visual style of the button.",
      options: SpectrumButtonVariant.values,
      labelBuilder: (SpectrumButtonVariant value) => value.name,
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: "Whether the button is disabled.",
    ),
    isOutline: context.knobs.object.segmented<bool>(
      label: 'isOutline',
      options: [true, false],
      initialOption: false,
      description: "Whether the button draws only a border instead of a filled background.",
    ),
    isPending: context.knobs.object.segmented<bool>(
      label: 'isPending',
      options: [true, false],
      initialOption: false,
      description: "Whether the button shows a loading circle and ignores taps.",
    ),
    staticColor: context.knobs.objectOrNull.dropdown<SpectrumStaticColor>(
      label: 'staticColor',
      options: SpectrumStaticColor.values,
      labelBuilder: (SpectrumStaticColor value) => value.name,
      description: "Fixed white or black colors for buttons over images or colored backgrounds.",
    ),
    icon: SpectrumIcon(
      context.knobs.object.dropdown<SpectrumIcons>(
        label: 'Icon',
        options: SpectrumIcons.values,
        initialOption: SpectrumIcons.anchorSelect,
        description: "Whether the button is disabled.",
        labelBuilder: (value) => value.toString().replaceAll('SpectrumIcons.', ''),
      ),
    ),
    onTap: () => log("BuildButtonPresentation button was tapped."),
  );
}

@widgetbook.UseCase(name: 'Static Color', type: SpectrumButton)
Widget BuildButtonStaticColor(BuildContext context) {
  final staticColor = context.knobs.object.segmented<SpectrumStaticColor>(
    label: 'staticColor',
    options: SpectrumStaticColor.values,
    initialOption: SpectrumStaticColor.white,
    labelBuilder: (SpectrumStaticColor value) => value.name,
    description: "Fixed white or black colors for buttons over images or colored backgrounds.",
  );
  final List<Color> gradient;

  if (staticColor == SpectrumStaticColor.white) {
    // When staticColor is white, the background is a dark gradient,
    // as a photo or banner where the theme colors would disappear.
    gradient = [SpectrumColors.blue1300, SpectrumColors.orange1100];
  } else {
    // When staticColor is black, the background is a light gradient,
    // where a white button would not have enough contrast.
    gradient = [SpectrumColors.yellow300, SpectrumColors.orange400];
  }

  return Container(
    width: 360,
    height: 200,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
    ),
    child: SpectrumButton(
      content: context.knobs.string(
        label: 'content',
        initialValue: 'Learn more',
        description: 'The content to display in the Button.',
      ),
      staticColor: staticColor,
      isOutline: context.knobs.object.segmented<bool>(
        label: 'isOutline',
        options: [true, false],
        initialOption: false,
        description: "Whether the button draws only a border instead of a filled background.",
      ),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: "Whether the button is disabled.",
      ),
      isPending: context.knobs.object.segmented<bool>(
        label: 'isPending',
        options: [true, false],
        initialOption: false,
        description: "Whether the button shows a loading circle and ignores taps.",
      ),
      onTap: () => log("BuildButtonStaticColor button was tapped."),
    ),
  );
}

@widgetbook.UseCase(name: 'Auto Focus', type: SpectrumButton)
Widget BuildButtonAutoFocus(BuildContext context) {
  // The second button takes the focus when the use case opens, so the
  // focus ring shows on it and Tab moves the focus to the next button.
  return Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 16,
    children: [
      SpectrumButton(
        content: 'Cancel',
        variant: SpectrumButtonVariant.secondary,
        onTap: () => log("BuildButtonAutoFocus button 'CANCEL' was tapped."),
      ),
      SpectrumButton(
        content: 'Save',
        variant: SpectrumButtonVariant.accent,
        isAutoFocus: true,
        onTap: () => log("BuildButtonAutoFocus button 'SAVE' was tapped."),
      ),
      SpectrumButton(
        content: 'Delete',
        variant: SpectrumButtonVariant.negative,
        isOutline: true,
        onTap: () => log("BuildButtonAutoFocus button 'DELETE' was tapped."),
      ),
    ],
  );
}
