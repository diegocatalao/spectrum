import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumComboBox)
Widget BuildComboBoxPresentation(BuildContext context) {
  return SizedBox(
    width: 280,
    child: SpectrumComboBox(
      label: Text('Favorite animal'),
      allowsCustomValue: context.knobs.object.segmented<bool>(
        label: 'allowsCustomValue',
        options: [true, false],
        initialOption: false,
        description: 'Whether a typed text that is not an option is kept.',
      ),
      onChange: (value) => log('BuildComboBoxPresentation picked: $value.'),
      children: [
        SpectrumComboBoxItem(value: 'aardvark', child: Text('Aardvark')),
        SpectrumComboBoxItem(value: 'cat', child: Text('Cat')),
        SpectrumComboBoxItem(value: 'dog', child: Text('Dog')),
        SpectrumComboBoxItem(value: 'kangaroo', child: Text('Kangaroo')),
        SpectrumComboBoxSection(
          header: SpectrumMenuHeader(child: Text('Birds')),
          children: [
            SpectrumComboBoxItem(value: 'eagle', child: Text('Eagle')),
            SpectrumComboBoxItem(value: 'parrot', child: Text('Parrot')),
          ],
        ),
      ],
    ),
  );
}
