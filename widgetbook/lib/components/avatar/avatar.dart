import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumAvatar)
Widget BuildAvatarPresentation(BuildContext context) {
  return SpectrumAvatar(
    src: Uri.parse('https://i.pravatar.cc/128?img=5'),
    alt: 'Jane Doe',
    size: context.knobs.double.slider(label: 'size', initialValue: 24, min: 16, max: 112, description: 'The diameter.'),
    isOverBackground: context.knobs.object.segmented<bool>(
      label: 'isOverBackground',
      options: [true, false],
      initialOption: false,
      description: 'Whether a ring separates the avatar from the background.',
    ),
  );
}
