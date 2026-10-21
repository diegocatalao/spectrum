import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTagGroup)
Widget BuildTagGroupPresentation(BuildContext context) {
  return SizedBox(
    width: 360,
    child: SpectrumTagGroup(
      label: Text('Keywords'),
      selects: context.knobs.object.segmented<SpectrumSelects>(
        label: 'selects',
        options: SpectrumSelects.values,
        initialOption: SpectrumSelects.multiple,
        labelBuilder: (SpectrumSelects value) => value.name,
        description: 'Whether no tag, one tag or many tags can be selected.',
      ),
      isEmphasized: context.knobs.object.segmented<bool>(
        label: 'isEmphasized',
        options: [true, false],
        initialOption: false,
        description: 'Whether the selected tags are blue.',
      ),
      groupActionLabel: 'Clear all',
      onGroupAction: () => log('BuildTagGroupPresentation clear all.'),
      onSelectionChange: (value) => log('BuildTagGroupPresentation selected: $value.'),
      children: [
        SpectrumTag(leading: SpectrumIcon(SpectrumIcons.image), child: Text('Landscape')),
        SpectrumTag(child: Text('Sunset')),
        SpectrumTag(child: Text('Desert')),
        SpectrumTag(isDisabled: true, child: Text('Archived')),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Removable', type: SpectrumTagGroup)
Widget BuildTagGroupRemovable(BuildContext context) {
  return const _Removable();
}

class _Removable extends StatefulWidget {
  const _Removable();

  @override
  State<_Removable> createState() => _RemovableState();
}

class _RemovableState extends State<_Removable> {
  final List<String> _tags = ['News', 'Travel', 'Gaming', 'Shopping'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: SpectrumTagGroup(
        label: Text('Categories'),
        onRemove: (index) => setState(() => _tags.removeAt(index)),
        children: [for (final tag in _tags) SpectrumTag(child: Text(tag))],
      ),
    );
  }
}
