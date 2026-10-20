import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumForm)
Widget BuildFormPresentation(BuildContext context) {
  return SizedBox(
    width: 320,
    child: SpectrumForm(
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether every field of the form is disabled.',
      ),
      isEmphasized: context.knobs.object.segmented<bool>(
        label: 'isEmphasized',
        options: [true, false],
        initialOption: false,
        description: 'Whether every field of the form is emphasized.',
      ),
      children: [
        SpectrumCheckbox(isSelected: true, child: Text('Send me updates')),
        SpectrumCheckbox(child: Text('Share my usage data')),
        SpectrumSwitch(
          isSelected: true,
          onChanged: (value) => log('BuildFormPresentation switch: $value.'),
          child: Text('Dark mode'),
        ),
      ],
    ),
  );
}
