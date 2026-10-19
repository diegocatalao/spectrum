import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumMenuGroup)
Widget BuildMenuGroupPresentation(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumMenuGroup(
      header: Text(context.knobs.string(label: 'header', initialValue: 'Sort by', description: 'Title of the group.')),
      selects: context.knobs.object.segmented<SpectrumSelects>(
        label: 'selects',
        options: SpectrumSelects.values,
        initialOption: SpectrumSelects.single,
        labelBuilder: (SpectrumSelects value) => value.name,
        description: 'How the group manages the selection of its items.',
      ),
      // The selection comes from the knob, so it can be changed in the panel.
      selected: context.knobs.iterable
          .segmented<int>(label: 'selected', options: [0, 1, 2], initialOption: [0], description: 'Selected indexes.')
          .toList(),
      onChanged: (value) => log('BuildMenuGroupPresentation selection changed to $value.'),
      children: [
        SpectrumMenuItem(child: Text('Name')),
        SpectrumMenuItem(child: Text('Date modified')),
        SpectrumMenuItem(child: Text('Size')),
      ],
    ),
  );
}
