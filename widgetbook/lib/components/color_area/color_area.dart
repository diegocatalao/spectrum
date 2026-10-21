import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumColorArea)
Widget BuildColorAreaPresentation(BuildContext context) {
  return SpectrumColorArea(
    value: const Color(0xFF0D66D0),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the area is disabled.',
    ),
    onChangeEnd: (value) => log('BuildColorAreaPresentation color: $value.'),
  );
}

@widgetbook.UseCase(name: 'With Wheel', type: SpectrumColorArea)
Widget BuildColorAreaWithWheel(BuildContext context) {
  return const _ColorEditor();
}

/// A wheel that picks the hue, an area that picks the rest and a swatch with the result.
class _ColorEditor extends StatefulWidget {
  const _ColorEditor();

  @override
  State<_ColorEditor> createState() => _ColorEditorState();
}

class _ColorEditorState extends State<_ColorEditor> {
  Color _color = const Color(0xFF0D66D0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        SpectrumColorWheel(value: _color, onChange: (value) => setState(() => _color = value)),
        SpectrumColorArea(value: _color, onChange: (value) => setState(() => _color = value)),
        SpectrumColorSwatch(color: _color),
      ],
    );
  }
}
