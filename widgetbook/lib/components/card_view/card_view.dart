import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCardView)
Widget BuildCardViewPresentation(BuildContext context) {
  return SizedBox(
    width: 800,
    child: SpectrumCardView(
      selects: context.knobs.object.segmented<SpectrumSelects>(
        label: 'selects',
        options: SpectrumSelects.values,
        initialOption: SpectrumSelects.multiple,
        labelBuilder: (SpectrumSelects value) => value.name,
        description: 'Whether no card, one card or many cards can be selected.',
      ),
      onSelectionChange: (value) => log('BuildCardViewPresentation selected: $value.'),
      children: [
        for (var index = 1; index <= 5; index++)
          SpectrumCard(
            preview: SpectrumCardPreview(
              child: SpectrumImage(
                uri: Uri.parse('https://picsum.photos/seed/view$index/480/320'),
                width: 480,
                height: 320,
              ),
            ),
            title: Text('Project $index'),
            description: Text('Edited $index days ago'),
          ),
      ],
    ),
  );
}
