import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCoachMark)
Widget BuildCoachMarkPresentation(BuildContext context) {
  return SpectrumCoachMark(
    heading: Text('Try the brush'),
    step: '1 of 3',
    secondaryActionLabel: 'Skip tour',
    onPrimaryAction: () => log('BuildCoachMarkPresentation next.'),
    content: Text('Paint over the photo to retouch it. Tap the dot to open this tip.'),
    child: SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.brush), onTap: () {}),
  );
}
