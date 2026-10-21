import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumQuickActions)
Widget BuildQuickActionsPresentation(BuildContext context) {
  return SpectrumQuickActions(
    isAlwaysVisible: context.knobs.object.segmented<bool>(
      label: 'isAlwaysVisible',
      options: [true, false],
      initialOption: false,
      description: 'Whether the bar is shown without hovering the card.',
    ),
    actions: [
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.edit), onTap: () => log('Edit.')),
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.share), onTap: () => log('Share.')),
      SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.delete), onTap: () => log('Delete.')),
    ],
    child: SpectrumCard(title: Text('Hover me'), description: Text('The quick actions appear at the top.')),
  );
}
