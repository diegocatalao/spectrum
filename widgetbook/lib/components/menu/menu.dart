import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumMenu)
Widget BuildMenuPresentation(BuildContext context) {
  return SizedBox(
    width: 240,
    child: SpectrumMenu(
      label: 'Actions',
      children: [
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.edit),
          onTap: () => log("BuildMenuPresentation item 'EDIT' was tapped."),
          child: Text('Edit'),
        ),
        SpectrumMenuItem(
          icon: SpectrumIcon(SpectrumIcons.delete),
          onTap: () => log("BuildMenuPresentation item 'DELETE' was tapped."),
          child: Text('Delete'),
        ),
        SpectrumMenuItem(isDisabled: true, child: Text('Archive')),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Groups', type: SpectrumMenu)
Widget BuildMenuGroups(BuildContext context) {
  // Groups are separated by dividers and each one can manage its own selection.
  return SizedBox(
    width: 240,
    child: SpectrumMenu(
      label: 'View',
      children: [
        SpectrumMenuGroup(
          header: Text('Sort by'),
          selects: SpectrumSelects.single,
          selected: [0],
          onChanged: (value) => log('BuildMenuGroups sort changed to $value.'),
          children: [
            SpectrumMenuItem(child: Text('Name')),
            SpectrumMenuItem(child: Text('Date modified')),
          ],
        ),
        SpectrumMenuGroup(
          header: Text('Show'),
          selects: SpectrumSelects.multiple,
          selected: [0, 1],
          onChanged: (value) => log('BuildMenuGroups visibility changed to $value.'),
          children: [
            SpectrumMenuItem(child: Text('Hidden files')),
            SpectrumMenuItem(child: Text('Extensions')),
          ],
        ),
      ],
    ),
  );
}
