import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSearchField)
Widget BuildSearchFieldPresentation(BuildContext context) {
  return SizedBox(
    width: 280,
    child: SpectrumSearchField(
      label: Text('Search'),
      placeholder: 'Search files',
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether the field is disabled.',
      ),
      onSubmitted: (value) => log('BuildSearchFieldPresentation search: $value.'),
      onClear: () => log('BuildSearchFieldPresentation cleared.'),
    ),
  );
}
