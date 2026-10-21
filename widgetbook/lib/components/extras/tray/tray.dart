import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTray)
Widget BuildTrayPresentation(BuildContext context) {
  return SpectrumButton(
    content: 'Open tray',
    onTap: () => showSpectrumTray<void>(
      context: context,
      builder: (context) => SpectrumMenu(
        children: [
          SpectrumMenuItem(onTap: () => Navigator.of(context).pop(), child: Text('Edit')),
          SpectrumMenuItem(onTap: () => Navigator.of(context).pop(), child: Text('Share')),
          SpectrumMenuItem(onTap: () => Navigator.of(context).pop(), child: Text('Delete')),
        ],
      ),
    ),
  );
}
