import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumAlertDialog)
Widget BuildAlertDialogPresentation(BuildContext context) {
  final variant = context.knobs.object.dropdown<SpectrumAlertDialogVariant>(
    label: 'variant',
    options: SpectrumAlertDialogVariant.values,
    initialOption: SpectrumAlertDialogVariant.destructive,
    labelBuilder: (SpectrumAlertDialogVariant value) => value.name,
    description: 'The kind of the dialog, which picks the primary button and the icon.',
  );

  return SpectrumDialogTrigger(
    trigger: (context, onOpen) =>
        SpectrumButton(content: 'Delete file', variant: SpectrumButtonVariant.negative, onTap: onOpen),
    builder: (context) => SpectrumAlertDialog(
      variant: variant,
      title: 'Delete the file?',
      primaryActionLabel: 'Delete',
      secondaryActionLabel: 'Move to trash',
      cancelLabel: 'Cancel',
      onPrimaryAction: () => log('BuildAlertDialogPresentation primary action.'),
      onSecondaryAction: () => log('BuildAlertDialogPresentation secondary action.'),
      onCancel: () => log('BuildAlertDialogPresentation canceled.'),
      child: Text('The file will be deleted for everyone in the team. This can not be undone.'),
    ),
  );
}
