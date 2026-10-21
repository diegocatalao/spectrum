import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDialogTrigger)
Widget BuildDialogTriggerPresentation(BuildContext context) {
  return SpectrumDialogTrigger(
    type: context.knobs.object.segmented<SpectrumDialogType>(
      label: 'type',
      options: SpectrumDialogType.values,
      initialOption: SpectrumDialogType.popover,
      labelBuilder: (SpectrumDialogType value) => value.name,
      description: 'Whether the dialog is a modal or a popover next to the button.',
    ),
    isDismissible: true,
    trigger: (context, onOpen) =>
        SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.info), onTap: onOpen, child: Text('Details')),
    builder: (context) => SpectrumDialog(
      width: 320,
      isDismissible: true,
      heading: Text('Details'),
      content: Text('Created on March 2, 2026 by Jane Doe.'),
    ),
  );
}
