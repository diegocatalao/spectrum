import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumSideNav)
Widget BuildSideNavPresentation(BuildContext context) {
  return const _Navigation();
}

/// A navigation that keeps the current route, so taps move the current item.
class _Navigation extends StatefulWidget {
  const _Navigation();

  @override
  State<_Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<_Navigation> {
  Object _route = 'home';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: SpectrumSideNav(
        selectedRoute: _route,
        onSelect: (route) => setState(() => _route = route),
        children: [
          SpectrumSideNavItem(id: 'home', icon: SpectrumIcon(SpectrumIcons.home), child: Text('Home')),
          SpectrumSideNavItem(
            id: 'files',
            icon: SpectrumIcon(SpectrumIcons.folder),
            isExpanded: true,
            children: [
              SpectrumSideNavItem(id: 'recent', child: Text('Recent')),
              SpectrumSideNavItem(
                id: 'shared',
                children: [SpectrumSideNavItem(id: 'team', child: Text('Team'))],
                child: Text('Shared'),
              ),
            ],
            child: Text('Files'),
          ),
          SpectrumSideNavSection(
            header: Text('Libraries'),
            children: [
              SpectrumSideNavItem(id: 'brand', child: Text('Brand')),
              SpectrumSideNavItem(id: 'archive', isDisabled: true, child: Text('Archive')),
            ],
          ),
        ],
      ),
    );
  }
}
