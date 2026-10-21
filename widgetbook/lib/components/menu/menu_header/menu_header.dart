import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumMenuHeader)
Widget BuildMenuHeaderPresentation(BuildContext context) {
  final description = context.knobs.string(
    label: 'description',
    initialValue: 'Shown to everyone in the team',
    description: 'The text below the title. Empty hides it.',
  );

  return SizedBox(
    width: 240,
    child: SpectrumMenu(
      children: [
        SpectrumMenuSection(
          header: SpectrumMenuHeader(
            description: description.isEmpty ? null : Text(description),
            child: Text(context.knobs.string(label: 'title', initialValue: 'Visibility', description: 'The title.')),
          ),
          children: [
            SpectrumMenuItem(child: Text('Public')),
            SpectrumMenuItem(child: Text('Private')),
          ],
        ),
      ],
    ),
  );
}
