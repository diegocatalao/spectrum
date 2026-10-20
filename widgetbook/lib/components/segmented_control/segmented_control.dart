import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSegmentedControl)
Widget BuildSegmentedControlPresentation(BuildContext context) {
  return SpectrumSegmentedControl(
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether every option is disabled.',
    ),
    onSelectionChange: (index) => log('BuildSegmentedControlPresentation selected: $index.'),
    children: [
      SpectrumSegmentedControlItem(child: Text('Day')),
      SpectrumSegmentedControlItem(child: Text('Week')),
      SpectrumSegmentedControlItem(child: Text('Month')),
      SpectrumSegmentedControlItem(child: Text('Year')),
    ],
  );
}

@widgetbook.UseCase(name: 'Icons', type: SpectrumSegmentedControl)
Widget BuildSegmentedControlIcons(BuildContext context) {
  return SpectrumSegmentedControl(
    children: [
      SpectrumSegmentedControlItem(icon: SpectrumIcon(SpectrumIcons.textAlignLeft)),
      SpectrumSegmentedControlItem(icon: SpectrumIcon(SpectrumIcons.textAlignCenter)),
      SpectrumSegmentedControlItem(icon: SpectrumIcon(SpectrumIcons.textAlignRight)),
    ],
  );
}

@widgetbook.UseCase(name: 'Justified', type: SpectrumSegmentedControl)
Widget BuildSegmentedControlJustified(BuildContext context) {
  return SizedBox(
    width: 400,
    child: SpectrumSegmentedControl(
      isJustified: true,
      selectedIndex: 1,
      children: [
        SpectrumSegmentedControlItem(icon: SpectrumIcon(SpectrumIcons.viewList), child: Text('List')),
        SpectrumSegmentedControlItem(icon: SpectrumIcon(SpectrumIcons.viewGrid), child: Text('Grid')),
        SpectrumSegmentedControlItem(isDisabled: true, child: Text('Gallery')),
      ],
    ),
  );
}
