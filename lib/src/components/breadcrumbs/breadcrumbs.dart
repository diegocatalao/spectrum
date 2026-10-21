import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Breadcrumbs: the path to the current page, from the root, with a
/// chevron between the items and the middle ones in a menu when there are many.
class SpectrumBreadcrumbs extends StatelessWidget {
  /// Items of the path, from the root to the current page, which is the last one.
  final List<SpectrumBreadcrumb> children;

  /// Called with the index of the tapped item.
  final ValueChanged<int>? onAction;

  /// Grays out every item and ignores taps.
  final bool isDisabled;

  /// Number of items shown before the middle ones move to a menu. The root and the
  /// last items are always shown.
  final int maxVisibleItems;

  const SpectrumBreadcrumbs({
    super.key,
    required this.children,
    this.onAction,
    this.isDisabled = false,
    this.maxVisibleItems = 4,
  });

  /// Returns the state of the item inside a breadcrumbs, or null outside of one.
  static ({bool isCurrent, bool isDisabled, VoidCallback? onTap})? itemOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_BreadcrumbScope>();

    if (scope == null) {
      return null;
    }

    return (isCurrent: scope.isCurrent, isDisabled: scope.isDisabled, onTap: scope.onTap);
  }

  /// Wraps the item at the index with its state.
  Widget _item(int index) {
    return _BreadcrumbScope(
      isCurrent: index == children.length - 1,
      isDisabled: isDisabled,
      onTap: onAction == null ? null : () => onAction!(index),
      child: children[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items;

    if (children.length > maxVisibleItems && maxVisibleItems >= 2) {
      // When there are too many items, the root stays first, the middle items move to
      // a menu with a folder icon, and the last ones stay visible, as in Spectrum 2.
      final last = maxVisibleItems - 1;
      final hidden = [for (var index = 1; index < children.length - last; index++) index];

      items = [
        _item(0),
        _BreadcrumbScope(
          isCurrent: false,
          isDisabled: isDisabled,
          onTap: null,
          child: SpectrumBreadcrumb(
            menu: SpectrumActionMenu(
              icon: SpectrumIcon(SpectrumIcons.folder),
              isQuiet: true,
              isDisabled: isDisabled,
              label: 'More items',
              children: [
                for (final index in hidden)
                  SpectrumMenuItem(
                    onTap: onAction == null ? null : () => onAction!(index),
                    href: children[index].href,
                    child: children[index].child,
                  ),
              ],
            ),
            child: const Text('…'),
          ),
        ),
        for (var index = children.length - last; index < children.length; index++) _item(index),
      ];
    } else {
      items = [for (var index = 0; index < children.length; index++) _item(index)];
    }

    // Tells screen readers that this is the navigation path of the page.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Breadcrumbs',
      // Spectrum 2 breadcrumbs: 6px between the text and the chevrons, in one line.
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 6),
        child: Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: items),
      ),
    );
  }
}

/// Shares the state of one item with that item.
class _BreadcrumbScope extends InheritedWidget {
  final bool isCurrent;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _BreadcrumbScope({
    required this.isCurrent,
    required this.isDisabled,
    required this.onTap,
    required super.child,
  });

  @override
  bool updateShouldNotify(_BreadcrumbScope oldWidget) {
    return oldWidget.isCurrent != isCurrent || oldWidget.isDisabled != isDisabled;
  }
}
