import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTextArea)
Widget BuildTextAreaPresentation(BuildContext context) {
  return SizedBox(
    width: 320,
    child: SpectrumTextArea(
      label: Text('Comments'),
      description: Text('Tell us what you think about the new design.'),
      errorMessage: Text('The comment is too long.'),
      isInvalid: context.knobs.object.segmented<bool>(
        label: 'isInvalid',
        options: [true, false],
        initialOption: false,
        description: 'Whether the field shows the error.',
      ),
      minLines: context.knobs.int.slider(label: 'minLines', initialValue: 3, min: 1, max: 8, description: 'Lines.'),
      onChanged: (value) => log('BuildTextAreaPresentation text: $value.'),
    ),
  );
}
