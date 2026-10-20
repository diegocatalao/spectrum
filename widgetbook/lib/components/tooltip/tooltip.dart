import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTooltip)
Widget BuildTooltipPresentation(BuildContext context) {
  return SpectrumTooltipTrigger(
    placement: context.knobs.object.segmented<SpectrumTooltipPlacement>(
      label: 'placement',
      options: SpectrumTooltipPlacement.values,
      initialOption: SpectrumTooltipPlacement.top,
      labelBuilder: (SpectrumTooltipPlacement value) => value.name,
      description: 'The side of the button where the tooltip is shown.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the tooltip is never shown.',
    ),
    tooltip: SpectrumTooltip(
      child: Text(
        context.knobs.string(label: 'content', initialValue: 'Edit the name', description: 'The text of the tooltip.'),
      ),
    ),
    child: SpectrumActionButton(
      icon: SpectrumIcon(SpectrumIcons.edit),
      onTap: () => log('BuildTooltipPresentation button was tapped.'),
    ),
  );
}

@widgetbook.UseCase(name: 'Long Text', type: SpectrumTooltip)
Widget BuildTooltipLongText(BuildContext context) {
  return SpectrumTooltipTrigger(
    tooltip: SpectrumTooltip(child: Text('Saves every change to the cloud, so it can be opened on any device.')),
    child: SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.cloud), onTap: () {}),
  );
}
