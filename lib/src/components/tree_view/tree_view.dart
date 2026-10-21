import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tree View: a list of items nested in levels, like folders, that expand
/// and collapse, with selection and actions, inside a bordered box.
class SpectrumTreeView extends StatefulWidget {
  /// Items of the first level.
  final List<SpectrumTreeViewItem> children;

  /// Whether no item, one item or many items can be selected.
  final SpectrumSelects selects;

  /// Ids of the items selected at start. When the parent changes them, the tree follows.
  final Set<Object> selected;

  /// Called with the ids of the selected items when an item is selected.
  final ValueChanged<Set<Object>>? onSelectionChange;

  /// Called with the id of the tapped item when the tree has no selection.
  final ValueChanged<Object>? onAction;

  /// Grays out every item and ignores taps.
  final bool isDisabled;

  const SpectrumTreeView({
    super.key,
    required this.children,
    this.selects = SpectrumSelects.none,
    this.selected = const {},
    this.onSelectionChange,
    this.onAction,
    this.isDisabled = false,
  });

  /// Returns the state of the tree and the level of the item, or null outside of a tree.
  static ({Set<Object> selected, SpectrumSelects selects, bool isDisabled, int level, ValueChanged<Object> onTap})?
  itemOf(BuildContext context) {
    final tree = context.dependOnInheritedWidgetOfExactType<_TreeScope>();

    if (tree == null) {
      return null;
    }

    final level = context.dependOnInheritedWidgetOfExactType<SpectrumTreeLevel>()?.level ?? 0;
    return (
      selected: tree.selected,
      selects: tree.selects,
      isDisabled: tree.isDisabled,
      level: level,
      onTap: tree.onTap,
    );
  }

  @override
  State<SpectrumTreeView> createState() => _SpectrumTreeViewState();
}

class _SpectrumTreeViewState extends State<SpectrumTreeView> {
  final Set<Object> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  void _handleTap(Object id) {
    if (widget.selects == SpectrumSelects.none) {
      widget.onAction?.call(id);
      return;
    }

    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (widget.selects == SpectrumSelects.multiple) {
        _selected.add(id);
      } else {
        _selected
          ..clear()
          ..add(id);
      }
    });
    widget.onSelectionChange?.call({..._selected});
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Spectrum 2 tree view: a gray-25 box with a 1px gray-300 border and 8px corners.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300),
        ),
        child: _TreeScope(
          selected: {..._selected},
          selects: widget.selects,
          isDisabled: widget.isDisabled,
          onTap: _handleTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}

class _TreeScope extends InheritedWidget {
  final Set<Object> selected;
  final SpectrumSelects selects;
  final bool isDisabled;
  final ValueChanged<Object> onTap;

  const _TreeScope({
    required this.selected,
    required this.selects,
    required this.isDisabled,
    required this.onTap,
    required super.child,
  });

  @override
  bool updateShouldNotify(_TreeScope oldWidget) {
    return oldWidget.selected.length != selected.length ||
        !oldWidget.selected.containsAll(selected) ||
        oldWidget.selects != selects ||
        oldWidget.isDisabled != isDisabled;
  }
}

/// Depth of the items below it, used to indent the nested items by 16px per level.
class SpectrumTreeLevel extends InheritedWidget {
  /// Depth of the items, 0 for the first level.
  final int level;

  const SpectrumTreeLevel({super.key, required this.level, required super.child});

  @override
  bool updateShouldNotify(SpectrumTreeLevel oldWidget) => oldWidget.level != level;
}
