import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSelectBoxGroup)
Widget BuildSelectBoxGroupPresentation(BuildContext context) {
  return SizedBox(
    width: 600,
    child: SpectrumSelectBoxGroup(
      selects: context.knobs.object.segmented<SpectrumSelects>(
        label: 'selects',
        options: [SpectrumSelects.single, SpectrumSelects.multiple],
        initialOption: SpectrumSelects.single,
        labelBuilder: (SpectrumSelects value) => value.name,
        description: 'Whether one or many boxes can be selected.',
      ),
      orientation: context.knobs.object.segmented<Axis>(
        label: 'orientation',
        options: Axis.values,
        initialOption: Axis.vertical,
        labelBuilder: (Axis value) => value.name,
        description: 'Square boxes, or wide boxes with a description.',
      ),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether every box is disabled.',
      ),
      selected: const [0],
      onSelectionChange: (value) => log('BuildSelectBoxGroupPresentation selected: $value.'),
      children: [
        SpectrumSelectBox(
          illustration: SpectrumIcon(SpectrumIcons.cloud, size: 40),
          description: Text('Store your files in the cloud.'),
          child: Text('Cloud'),
        ),
        SpectrumSelectBox(
          illustration: SpectrumIcon(SpectrumIcons.desktopAndMobile, size: 40),
          description: Text('Keep your files on this device.'),
          child: Text('Local'),
        ),
        SpectrumSelectBox(
          isDisabled: true,
          illustration: SpectrumIcon(SpectrumIcons.globe, size: 40),
          description: Text('Share your files with everyone.'),
          child: Text('Public'),
        ),
      ],
    ),
  );
}
