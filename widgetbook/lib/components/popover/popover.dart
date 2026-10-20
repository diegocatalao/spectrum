import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumPopover)
Widget BuildPopoverPresentation(BuildContext context) {
  return SpectrumPopover(
    placement: context.knobs.object.dropdown<SpectrumPopoverPlacement>(
      label: 'placement',
      options: SpectrumPopoverPlacement.values,
      initialOption: SpectrumPopoverPlacement.bottom,
      labelBuilder: (SpectrumPopoverPlacement value) => value.name,
      description: 'The side of the button where the popover is shown.',
    ),
    hideArrow: context.knobs.object.segmented<bool>(
      label: 'hideArrow',
      options: [true, false],
      initialOption: false,
      description: 'Whether the arrow pointing to the button is hidden.',
    ),
    trigger: (context, onToggle) =>
        SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.settings), onTap: onToggle, child: Text('Settings')),
    child: SizedBox(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.titleMedium),
            SpectrumSwitch(isSelected: true, child: Text('Autosave')),
            SpectrumSwitch(child: Text('Show grid')),
          ],
        ),
      ),
    ),
  );
}
