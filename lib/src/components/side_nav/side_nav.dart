import 'package:flutter/material.dart';

/// Spectrum Side Nav: the navigation of an app on the side of the screen, with
/// items that can hold sub items and sections with a header.
class SpectrumSideNav extends StatelessWidget {
  /// Items and sections of the navigation: SpectrumSideNavItem and SpectrumSideNavSection.
  final List<Widget> children;

  /// Route of the current page, the id of the item shown as current.
  final Object? selectedRoute;

  /// Called with the id of the tapped item.
  final ValueChanged<Object>? onSelect;

  const SpectrumSideNav({super.key, required this.children, this.selectedRoute, this.onSelect});

  /// Returns the current route and the selection callback of the navigation.
  static ({Object? selectedRoute, ValueChanged<Object>? onSelect, int level})? of(BuildContext context) {
    final nav = context.dependOnInheritedWidgetOfExactType<_SideNavScope>();

    if (nav == null) {
      return null;
    }

    final level = context.dependOnInheritedWidgetOfExactType<SpectrumSideNavLevel>()?.level ?? 0;
    return (selectedRoute: nav.selectedRoute, onSelect: nav.onSelect, level: level);
  }

  @override
  Widget build(BuildContext context) {
    // Tells screen readers that this is the navigation of the app.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Navigation',
      child: _SideNavScope(
        selectedRoute: selectedRoute,
        onSelect: onSelect,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Spectrum 2 gap of 6px between the items.
          spacing: 6,
          children: children,
        ),
      ),
    );
  }
}

/// Shares the current route of the navigation with its items.
class _SideNavScope extends InheritedWidget {
  final Object? selectedRoute;
  final ValueChanged<Object>? onSelect;

  const _SideNavScope({required this.selectedRoute, required this.onSelect, required super.child});

  @override
  bool updateShouldNotify(_SideNavScope oldWidget) => oldWidget.selectedRoute != selectedRoute;
}

/// Depth of the items below it, used to indent the sub items by 16px per level.
class SpectrumSideNavLevel extends InheritedWidget {
  /// Depth of the items, 0 for the top level.
  final int level;

  const SpectrumSideNavLevel({super.key, required this.level, required super.child});

  @override
  bool updateShouldNotify(SpectrumSideNavLevel oldWidget) => oldWidget.level != level;
}
