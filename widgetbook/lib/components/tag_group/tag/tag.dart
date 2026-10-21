import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTag)
Widget BuildTagPresentation(BuildContext context) {
  return SpectrumTagGroup(
    selects: SpectrumSelects.single,
    children: [
      SpectrumTag(
        leading: SpectrumAvatar(src: Uri.parse('https://i.pravatar.cc/40?img=8'), size: 16),
        isDisabled: context.knobs.object.segmented<bool>(
          label: 'isDisabled',
          options: [true, false],
          initialOption: false,
          description: 'Whether the tag is disabled.',
        ),
        child: Text(context.knobs.string(label: 'content', initialValue: 'Jane Doe', description: 'The text.')),
      ),
    ],
  );
}
