import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCustomDialog)
Widget BuildCustomDialogPresentation(BuildContext context) {
  return SpectrumDialogTrigger(
    isDismissible: true,
    trigger: (context, onOpen) => SpectrumButton(content: 'Show tips', onTap: onOpen),
    builder: (context) => SpectrumCustomDialog(
      isDismissible: true,
      child: SpectrumIllustratedMessage(
        illustration: SpectrumIcon(SpectrumIcons.info, size: 64),
        heading: Text('Welcome'),
        content: Text('Drag files here to upload them to your library.'),
      ),
    ),
  );
}
