import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumAvatarGroup)
Widget BuildAvatarGroupPresentation(BuildContext context) {
  final label = context.knobs.string(label: 'label', initialValue: 'Design team', description: 'Empty hides it.');

  return SpectrumAvatarGroup(
    label: label.isEmpty ? null : label,
    size: context.knobs.double.slider(label: 'size', initialValue: 24, min: 16, max: 40, description: 'The diameter.'),
    children: [
      for (var image = 1; image <= 4; image++)
        SpectrumAvatar(src: Uri.parse('https://i.pravatar.cc/80?img=$image'), alt: 'Member $image'),
    ],
  );
}
