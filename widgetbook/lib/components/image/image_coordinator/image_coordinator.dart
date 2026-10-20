import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumImageCoordinator)
Widget BuildImageCoordinatorPresentation(BuildContext context) {
  // A new batch downloads new pictures, so the coordinated reveal can be seen again.
  final batch = context.knobs.int.slider(
    label: 'batch',
    initialValue: 1,
    min: 1,
    max: 20,
    description: 'Changes the pictures, starting a new batch.',
  );

  return SpectrumImageCoordinator(
    timeout: Duration(
      milliseconds: context.knobs.int.slider(
        label: 'timeout (ms)',
        initialValue: 5000,
        min: 500,
        max: 10000,
        description: 'Time after which the images are revealed even if some are still loading.',
      ),
    ),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < 6; index++)
          SpectrumImage(
            uri: Uri.parse('https://picsum.photos/seed/$batch-$index/400/300'),
            width: 160,
            height: 120,
            borderRadius: BorderRadius.circular(8),
          ),
      ],
    ),
  );
}
