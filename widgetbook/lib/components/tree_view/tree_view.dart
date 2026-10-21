import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTreeView)
Widget BuildTreeViewPresentation(BuildContext context) {
  return SizedBox(
    width: 360,
    child: SpectrumTreeView(
      selects: context.knobs.object.segmented<SpectrumSelects>(
        label: 'selects',
        options: SpectrumSelects.values,
        initialOption: SpectrumSelects.multiple,
        labelBuilder: (SpectrumSelects value) => value.name,
        description: 'Whether no item, one item or many items can be selected.',
      ),
      onSelectionChange: (value) => log('BuildTreeViewPresentation selected: $value.'),
      onAction: (id) => log('BuildTreeViewPresentation item $id was tapped.'),
      children: [
        SpectrumTreeViewItem(
          id: 'photos',
          icon: SpectrumIcon(SpectrumIcons.folder),
          isExpanded: true,
          children: [
            SpectrumTreeViewItem(id: 'beach', icon: SpectrumIcon(SpectrumIcons.image), child: Text('Beach.png')),
            SpectrumTreeViewItem(
              id: 'trips',
              icon: SpectrumIcon(SpectrumIcons.folder),
              children: [
                SpectrumTreeViewItem(id: 'rome', icon: SpectrumIcon(SpectrumIcons.image), child: Text('Rome.png')),
              ],
              child: Text('Trips'),
            ),
          ],
          child: Text('Photos'),
        ),
        SpectrumTreeViewItem(id: 'videos', icon: SpectrumIcon(SpectrumIcons.folder), child: Text('Videos')),
      ],
    ),
  );
}
