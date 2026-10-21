import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumPicker)
Widget BuildPickerPresentation(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumPicker(
      label: Text('Ice cream flavor'),
      isQuiet: context.knobs.object.segmented<bool>(
        label: 'isQuiet',
        options: [true, false],
        initialOption: false,
        description: 'Whether the button has no background.',
      ),
      isInvalid: context.knobs.object.segmented<bool>(
        label: 'isInvalid',
        options: [true, false],
        initialOption: false,
        description: 'Whether the picker shows the error.',
      ),
      errorMessage: Text('Pick a flavor.'),
      onChange: (value) => log('BuildPickerPresentation picked: $value.'),
      children: [
        SpectrumPickerItem(value: 'chocolate', child: Text('Chocolate')),
        SpectrumPickerItem(value: 'mint', child: Text('Mint')),
        SpectrumPickerItem(value: 'strawberry', description: Text('Seasonal'), child: Text('Strawberry')),
        SpectrumPickerItem(value: 'vanilla', isDisabled: true, child: Text('Vanilla')),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Sections', type: SpectrumPicker)
Widget BuildPickerSections(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumPicker(
      label: Text('Font'),
      value: 'sans',
      children: [
        SpectrumPickerSection(
          header: SpectrumMenuHeader(child: Text('Common')),
          children: [
            SpectrumPickerItem(value: 'sans', child: Text('Sans serif')),
            SpectrumPickerItem(value: 'serif', child: Text('Serif')),
          ],
        ),
        SpectrumPickerSection(
          header: SpectrumMenuHeader(child: Text('Special')),
          children: [SpectrumPickerItem(value: 'mono', child: Text('Monospace'))],
        ),
      ],
    ),
  );
}
