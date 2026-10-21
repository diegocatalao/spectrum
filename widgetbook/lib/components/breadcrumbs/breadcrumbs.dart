import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumBreadcrumbs)
Widget BuildBreadcrumbsPresentation(BuildContext context) {
  return SpectrumBreadcrumbs(
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether every item is disabled.',
    ),
    onAction: (index) => log('BuildBreadcrumbsPresentation item $index was tapped.'),
    children: [
      SpectrumBreadcrumb(child: Text('Home')),
      SpectrumBreadcrumb(child: Text('Trendy')),
      SpectrumBreadcrumb(child: Text('March 2026 Assets')),
    ],
  );
}

@widgetbook.UseCase(name: 'Collapsed', type: SpectrumBreadcrumbs)
Widget BuildBreadcrumbsCollapsed(BuildContext context) {
  return SpectrumBreadcrumbs(
    maxVisibleItems: context.knobs.int.slider(
      label: 'maxVisibleItems',
      initialValue: 3,
      min: 2,
      max: 6,
      description: 'Items shown before the middle ones move to a menu.',
    ),
    onAction: (index) => log('BuildBreadcrumbsCollapsed item $index was tapped.'),
    children: [
      SpectrumBreadcrumb(child: Text('Home')),
      SpectrumBreadcrumb(child: Text('Projects')),
      SpectrumBreadcrumb(child: Text('2026')),
      SpectrumBreadcrumb(child: Text('Campaigns')),
      SpectrumBreadcrumb(child: Text('Spring')),
      SpectrumBreadcrumb(child: Text('Banners')),
    ],
  );
}
