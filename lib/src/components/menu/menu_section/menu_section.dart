import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Menu Section: a group of options of a menu, with an optional
/// SpectrumMenuHeader above them, that can manage the selection of its items.
class SpectrumMenuSection extends StatefulWidget {
  /// Title of the section, with an optional description.
  final SpectrumMenuHeader? header;

  /// How the section manages the selection. With single, the selected item shows
  /// a checkmark; with multiple, every item shows a checkbox.
  final SpectrumSelects selects;

  /// Indexes of the items selected at start. When the parent changes them, the section follows.
  /// Inside a popover, like a SpectrumActionMenu, the section is built again every time the
  /// menu opens, so keep the selection in the parent and pass it here.
  final List<int> selected;

  /// Called with the new selected indexes when the user taps an item.
  final ValueChanged<List<int>>? onSelectionChange;

  /// Options of the section, usually SpectrumMenuItem.
  final List<Widget> children;

  const SpectrumMenuSection({
    super.key,
    this.header,
    this.selects = SpectrumSelects.none,
    this.selected = const [],
    this.onSelectionChange,
    this.children = const [],
  });

  /// Returns the selection of the item inside a section with selection, or null
  /// when the section does not manage the selection.
  static ({bool isSelected, SpectrumSelects selects, VoidCallback onSelect})? itemOf(BuildContext context) {
    final item = context.dependOnInheritedWidgetOfExactType<_MenuSectionItemScope>();

    if (item == null) {
      return null;
    }

    return (isSelected: item.isSelected, selects: item.selects, onSelect: item.onSelect);
  }

  @override
  State<SpectrumMenuSection> createState() => _SpectrumMenuSectionState();
}

/// Keeps the selected items of the section.
class _SpectrumMenuSectionState extends State<SpectrumMenuSection> {
  /// Indexes of the selected items, changed on every tap.
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumMenuSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the selected indexes, the section follows them.
    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  /// In multiple, the tap adds or removes the index from the selection. In single,
  /// the tapped index becomes the only selected one, and tapping it again keeps it
  /// selected, as a radio button.
  void _select(int index) {
    final selected = {..._selected};

    if (widget.selects == SpectrumSelects.multiple && selected.contains(index)) {
      selected.remove(index);
    } else if (widget.selects == SpectrumSelects.multiple) {
      selected.add(index);
    } else {
      selected
        ..clear()
        ..add(index);
    }

    // Inside a popover, the menu closes before the tap is handled, so the section
    // may be gone: the new selection is still sent to the parent.
    if (mounted) {
      setState(() {
        _selected
          ..clear()
          ..addAll(selected);
      });
    }

    widget.onSelectionChange?.call(selected.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (final (index, child) in widget.children.indexed) {
      if (widget.selects == SpectrumSelects.none) {
        // When the section does not manage the selection, the items are shown as they are.
        items.add(child);
      } else {
        // Otherwise each item receives if it is selected and how to select itself.
        // In single selection, screen readers announce them as mutually exclusive.
        items.add(
          _MenuSectionItemScope(
            isSelected: _selected.contains(index),
            selects: widget.selects,
            onSelect: () => _select(index),
            child: Semantics(inMutuallyExclusiveGroup: widget.selects == SpectrumSelects.single, child: child),
          ),
        );
      }
    }

    return Semantics(
      container: true,
      label: widget.header?.child.data,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(visible: widget.header != null, child: widget.header ?? const SizedBox.shrink()),
          ...items,
        ],
      ),
    );
  }
}

/// Shares the selection of one item of the section with that item.
class _MenuSectionItemScope extends InheritedWidget {
  final bool isSelected;
  final SpectrumSelects selects;
  final VoidCallback onSelect;

  const _MenuSectionItemScope({
    required this.isSelected,
    required this.selects,
    required this.onSelect,
    required super.child,
  });

  @override
  bool updateShouldNotify(_MenuSectionItemScope oldWidget) {
    return oldWidget.isSelected != isSelected || oldWidget.selects != selects;
  }
}
