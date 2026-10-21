import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDialog)
Widget BuildDialogPresentation(BuildContext context) {
  final isDismissible = context.knobs.object.segmented<bool>(
    label: 'isDismissible',
    options: [true, false],
    initialOption: false,
    description: 'Whether a close button replaces the buttons and a tap outside closes the dialog.',
  );

  return SpectrumDialogTrigger(
    isDismissible: isDismissible,
    trigger: (context, onOpen) => SpectrumButton(content: 'Subscribe', onTap: onOpen),
    builder: (context) => SpectrumDialog(
      isDismissible: isDismissible,
      heading: Text('Subscribe to our newsletter'),
      content: Text('Enter your email to receive the news of the week, every Monday.'),
      footer: SpectrumCheckbox(child: Text('Do not ask again')),
      buttonGroup: SpectrumButtonGroup(
        children: [
          SpectrumButton(
            content: 'Cancel',
            variant: SpectrumButtonVariant.secondary,
            isOutline: true,
            onTap: () => Navigator.of(context).pop(),
          ),
          SpectrumButton(
            content: 'Subscribe',
            variant: SpectrumButtonVariant.accent,
            onTap: () {
              log('BuildDialogPresentation subscribed.');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}
