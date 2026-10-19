import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumMenuItem)
Widget BuildMenuItemPresentation(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumMenuItem(
      icon: SpectrumIcon(SpectrumIcons.edit),
      isSelected: context.knobs.object.segmented<bool>(
        label: 'isSelected',
        options: [true, false],
        initialOption: false,
        description: 'Whether the item shows the selection mark.',
      ),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether the item is disabled.',
      ),
      onTap: () => log('BuildMenuItemPresentation item was tapped.'),
      child: Text(context.knobs.string(label: 'content', initialValue: 'Edit', description: 'The text of the item.')),
    ),
  );
}
