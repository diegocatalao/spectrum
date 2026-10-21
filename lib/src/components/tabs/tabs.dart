import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tabs: a list of tabs that switches between panels of content,
/// showing the panel of the selected tab.
class SpectrumTabs extends StatefulWidget {
  /// Tabs of the list, in the same order as the panels.
  final SpectrumTabList list;

  /// Panels of content, one for each tab.
  final List<SpectrumTabPanel> children;

  /// Index of the tab selected at start. When the parent changes it, the tabs follow.
  final int selectedIndex;

  /// Called with the index of the tab selected by a tap.
  final ValueChanged<int>? onSelectionChange;

  /// Height of the tabs: 48px with the standard density, 32px with compact.
  final VisualDensity density;

  /// Tabs above the panel (horizontal) or on its left (vertical).
  final Axis orientation;

  /// Grays out every tab and ignores taps.
  final bool isDisabled;

  const SpectrumTabs({
    super.key,
    required this.list,
    required this.children,
    this.selectedIndex = 0,
    this.onSelectionChange,
    this.density = VisualDensity.standard,
    this.orientation = Axis.horizontal,
    this.isDisabled = false,
  });

  /// Returns the state of the tabs around the widget, or null outside of them.
  static ({int selected, bool isCompact, Axis orientation, bool isDisabled, ValueChanged<int> onSelect})? of(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_TabsScope>();

    if (scope == null) {
      return null;
    }

    return (
      selected: scope.selected,
      isCompact: scope.isCompact,
      orientation: scope.orientation,
      isDisabled: scope.isDisabled,
      onSelect: scope.onSelect,
    );
  }

  @override
  State<SpectrumTabs> createState() => _SpectrumTabsState();
}

/// Keeps the selected tab.
class _SpectrumTabsState extends State<SpectrumTabs> {
  /// Index of the selected tab, changed on every tap.
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant SpectrumTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes selectedIndex, the tabs follow it.
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selected = widget.selectedIndex;
    }
  }

  void _handleSelect(int index) {
    if (index != _selected) {
      setState(() => _selected = index);
      widget.onSelectionChange?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only the panel of the selected tab is shown, as in Spectrum 2.
    final panel = _selected < widget.children.length ? widget.children[_selected] : const SizedBox.shrink();
    final Widget layout;

    if (widget.orientation == Axis.vertical) {
      // When the orientation is vertical, the tabs are a column on the left of the
      // panel, 12px from the start and 20px from the panel.
      layout = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsetsDirectional.only(start: 12, end: 20), child: widget.list),
          Expanded(child: panel),
        ],
      );
    } else {
      // Otherwise the tabs are a row above the panel, 4px from it.
      layout = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Align(alignment: AlignmentDirectional.centerStart, child: widget.list),
          panel,
        ],
      );
    }

    return _TabsScope(
      selected: _selected,
      isCompact: widget.density == VisualDensity.compact,
      orientation: widget.orientation,
      isDisabled: widget.isDisabled,
      onSelect: _handleSelect,
      child: layout,
    );
  }
}

/// Shares the state of the tabs with the list, the tabs and the panels.
class _TabsScope extends InheritedWidget {
  final int selected;
  final bool isCompact;
  final Axis orientation;
  final bool isDisabled;
  final ValueChanged<int> onSelect;

  const _TabsScope({
    required this.selected,
    required this.isCompact,
    required this.orientation,
    required this.isDisabled,
    required this.onSelect,
    required super.child,
  });

  @override
  bool updateShouldNotify(_TabsScope oldWidget) {
    return oldWidget.selected != selected ||
        oldWidget.isCompact != isCompact ||
        oldWidget.orientation != orientation ||
        oldWidget.isDisabled != isDisabled;
  }
}
