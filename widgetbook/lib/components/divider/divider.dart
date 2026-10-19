import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumDivider)
Widget BuildDividerPresentation(BuildContext context) {
  final vertical = context.knobs.object.segmented<bool>(
    label: 'vertical',
    options: [true, false],
    initialOption: false,
    description: 'Whether the divider separates content side by side instead of stacked.',
  );
  final Widget content;

  if (vertical) {
    // When vertical is True, the divider separates two texts in a row,
    // so it needs a fixed height to be drawn.
    content = SizedBox(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [Text('Left'), SpectrumDivider(vertical: true), Text('Right')],
      ),
    );
  } else {
    // When vertical is False, the divider separates two texts in a column,
    // stretching to the width of the content.
    content = SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [Text('Above'), SpectrumDivider(), Text('Below')],
      ),
    );
  }

  return content;
}
