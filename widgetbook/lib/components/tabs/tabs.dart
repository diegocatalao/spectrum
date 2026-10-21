import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTabs)
Widget BuildTabsPresentation(BuildContext context) {
  return SizedBox(
    width: 480,
    height: 240,
    child: SpectrumTabs(
      orientation: context.knobs.object.segmented<Axis>(
        label: 'orientation',
        options: Axis.values,
        initialOption: Axis.horizontal,
        labelBuilder: (Axis value) => value.name,
        description: 'Tabs above or on the left of the panel.',
      ),
      density: context.knobs.object.segmented<VisualDensity>(
        label: 'density',
        options: [VisualDensity.compact, VisualDensity.standard],
        initialOption: VisualDensity.standard,
        labelBuilder: (VisualDensity value) => value == VisualDensity.compact ? 'compact' : 'regular',
        description: 'The height of the tabs.',
      ),
      isDisabled: context.knobs.object.segmented<bool>(
        label: 'isDisabled',
        options: [true, false],
        initialOption: false,
        description: 'Whether every tab is disabled.',
      ),
      onSelectionChange: (index) => log('BuildTabsPresentation selected: $index.'),
      list: SpectrumTabList(
        children: [
          SpectrumTab(child: Text('Founding of Rome')),
          SpectrumTab(child: Text('Monarchy and Republic')),
          SpectrumTab(child: Text('Empire')),
        ],
      ),
      children: [
        SpectrumTabPanel(child: Text('Arma virumque cano, Troiae qui primus ab oris.')),
        SpectrumTabPanel(child: Text('Senatus Populusque Romanus.')),
        SpectrumTabPanel(child: Text('Alea jacta est.')),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Icons', type: SpectrumTabs)
Widget BuildTabsIcons(BuildContext context) {
  return SizedBox(
    width: 480,
    child: SpectrumTabs(
      list: SpectrumTabList(
        children: [
          SpectrumTab(icon: SpectrumIcon(SpectrumIcons.edit), child: Text('Edit')),
          SpectrumTab(icon: SpectrumIcon(SpectrumIcons.share), child: Text('Share')),
          SpectrumTab(icon: SpectrumIcon(SpectrumIcons.delete), isDisabled: true, child: Text('Delete')),
        ],
      ),
      children: [
        SpectrumTabPanel(child: Text('Edit the file.')),
        SpectrumTabPanel(child: Text('Share the file.')),
        SpectrumTabPanel(child: Text('Delete the file.')),
      ],
    ),
  );
}
