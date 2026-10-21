import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTabBar)
Widget BuildTabBarPresentation(BuildContext context) {
  return SizedBox(
    width: 375,
    child: SpectrumTabBar(
      selectedIndex: context.knobs.int.slider(
        label: 'selectedIndex',
        initialValue: 0,
        min: 0,
        max: 3,
        description: 'Index.',
      ),
      onSelectionChange: (index) => log('BuildTabBarPresentation selected: $index.'),
      items: const [
        SpectrumTabBarItem(icon: SpectrumIcons.home, label: 'Home'),
        SpectrumTabBarItem(icon: SpectrumIcons.search, label: 'Search'),
        SpectrumTabBarItem(icon: SpectrumIcons.image, label: 'Photos'),
        SpectrumTabBarItem(icon: SpectrumIcons.settings, label: 'Settings'),
      ],
    ),
  );
}
