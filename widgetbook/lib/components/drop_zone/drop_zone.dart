import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDropZone)
Widget BuildDropZonePresentation(BuildContext context) {
  final isFilled = context.knobs.object.segmented<bool>(
    label: 'isFilled',
    options: [true, false],
    initialOption: false,
    description: 'Whether a drop replaces the content, showing the banner.',
  );

  return Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 32,
    children: [
      // The file to drag into the zone.
      Draggable<String>(
        data: 'report.pdf',
        feedback: Material(
          child: SpectrumBadge(variant: SpectrumBadgeVariant.accent, child: Text('report.pdf')),
        ),
        child: SpectrumBadge(child: Text('Drag me')),
      ),
      SizedBox(
        width: 320,
        child: SpectrumDropZone<String>(
          isFilled: isFilled,
          onDrop: (file) => log('BuildDropZonePresentation dropped: $file.'),
          child: SpectrumIllustratedMessage(
            illustration: SpectrumIcon(SpectrumIcons.cloud, size: 64),
            heading: Text('Drag and drop your file'),
            content: Text('Or select a file from your computer.'),
          ),
        ),
      ),
    ],
  );
}
