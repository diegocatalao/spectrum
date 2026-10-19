import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumActionMenu)
Widget BuildActionMenuPresentation(BuildContext context) {
  return SpectrumActionMenu(
    icon: SpectrumIcon(SpectrumIcons.more),
    label: 'More actions',
    isQuiet: context.knobs.object.segmented<bool>(
      label: 'isQuiet',
      options: [true, false],
      initialOption: false,
      description: 'Whether the trigger button is quiet.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the trigger button is disabled.',
    ),
    children: [
      SpectrumMenuItem(
        icon: SpectrumIcon(SpectrumIcons.edit),
        onTap: () => log("BuildActionMenuPresentation item 'EDIT' was tapped."),
        child: Text('Edit'),
      ),
      SpectrumMenuItem(
        icon: SpectrumIcon(SpectrumIcons.delete),
        onTap: () => log("BuildActionMenuPresentation item 'DELETE' was tapped."),
        child: Text('Delete'),
      ),
    ],
  );
}
