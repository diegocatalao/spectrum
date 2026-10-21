import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSideNavPanel)
Widget BuildSideNavPanelPresentation(BuildContext context) {
  return SizedBox(
    height: 360,
    child: SpectrumSideNavPanel(
      header: Text('Photos', style: Theme.of(context).textTheme.titleMedium),
      child: SpectrumSideNav(
        selectedRoute: 'library',
        children: [
          SpectrumSideNavItem(id: 'home', icon: SpectrumIcon(SpectrumIcons.home), child: Text('Home')),
          SpectrumSideNavItem(id: 'library', icon: SpectrumIcon(SpectrumIcons.image), child: Text('Library')),
          SpectrumSideNavItem(id: 'shared', icon: SpectrumIcon(SpectrumIcons.share), child: Text('Shared')),
        ],
      ),
    ),
  );
}
