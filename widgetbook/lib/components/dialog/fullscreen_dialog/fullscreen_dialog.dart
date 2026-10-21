import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumFullscreenDialog)
Widget BuildFullscreenDialogPresentation(BuildContext context) {
  final isTakeover = context.knobs.object.segmented<bool>(
    label: 'isTakeover',
    options: [true, false],
    initialOption: false,
    description: 'Whether the dialog covers the whole screen without corners.',
  );

  return SpectrumDialogTrigger(
    trigger: (context, onOpen) => SpectrumButton(content: 'Edit profile', onTap: onOpen),
    builder: (context) => SpectrumFullscreenDialog(
      isTakeover: isTakeover,
      heading: Text('Profile'),
      buttonGroup: SpectrumButtonGroup(
        children: [
          SpectrumButton(
            content: 'Cancel',
            variant: SpectrumButtonVariant.secondary,
            isOutline: true,
            onTap: () => Navigator.of(context).pop(),
          ),
          SpectrumButton(
            content: 'Save',
            variant: SpectrumButtonVariant.accent,
            onTap: () {
              log('BuildFullscreenDialogPresentation saved.');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: Text('Fields of the profile go here.'),
    ),
  );
}
