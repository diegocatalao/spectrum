import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumListView)
Widget BuildListViewPresentation(BuildContext context) {
  return SizedBox(
    width: 360,
    child: SpectrumListView(
      selects: context.knobs.object.segmented<SpectrumSelects>(
        label: 'selects',
        options: SpectrumSelects.values,
        initialOption: SpectrumSelects.multiple,
        labelBuilder: (SpectrumSelects value) => value.name,
        description: 'Whether no item, one item or many items can be selected.',
      ),
      selectionStyle: context.knobs.object.segmented<SpectrumListSelectionStyle>(
        label: 'selectionStyle',
        options: SpectrumListSelectionStyle.values,
        initialOption: SpectrumListSelectionStyle.checkbox,
        labelBuilder: (SpectrumListSelectionStyle value) => value.name,
        description: 'Checkboxes or a blue background on the selected items.',
      ),
      isQuiet: context.knobs.object.segmented<bool>(
        label: 'isQuiet',
        options: [true, false],
        initialOption: false,
        description: 'Whether the list has no border nor background.',
      ),
      selected: const [1],
      onSelectionChange: (value) => log('BuildListViewPresentation selected: $value.'),
      onAction: (index) => log('BuildListViewPresentation item $index was tapped.'),
      children: [
        SpectrumListViewItem(
          icon: SpectrumIcon(SpectrumIcons.folder),
          description: Text('12 files'),
          child: Text('Photos'),
        ),
        SpectrumListViewItem(
          icon: SpectrumIcon(SpectrumIcons.folder),
          description: Text('3 files'),
          child: Text('Videos'),
        ),
        SpectrumListViewItem(
          icon: SpectrumIcon(SpectrumIcons.image),
          description: Text('PNG • 2 MB'),
          actions: SpectrumActionMenu(
            icon: SpectrumIcon(SpectrumIcons.more),
            isQuiet: true,
            label: 'Actions',
            children: [
              SpectrumMenuItem(child: Text('Rename')),
              SpectrumMenuItem(child: Text('Delete')),
            ],
          ),
          child: Text('Sunset.png'),
        ),
        SpectrumListViewItem(isDisabled: true, icon: SpectrumIcon(SpectrumIcons.folder), child: Text('Archive')),
      ],
    ),
  );
}
