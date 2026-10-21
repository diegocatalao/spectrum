import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// How a SpectrumListView shows its selected items.
enum SpectrumListSelectionStyle {
  /// A checkbox at the start of every item.
  checkbox,

  /// A blue background on the selected items, without checkboxes.
  highlight,
}

/// Spectrum List View: a list of interactive items, with selection, icons,
/// descriptions and actions, inside a bordered box.
class SpectrumListView extends StatefulWidget {
  /// Items of the list.
  final List<SpectrumListViewItem> children;

  /// Whether no item, one item or many items can be selected.
  final SpectrumSelects selects;

  /// Indexes of the items selected at start. When the parent changes them, the list follows.
  final List<int> selected;

  /// Called with the new selected indexes when an item is selected.
  final ValueChanged<List<int>>? onSelectionChange;

  /// Called with the index of the tapped item when the list has no selection.
  final ValueChanged<int>? onAction;

  /// How the selected items are shown, with checkboxes by default.
  final SpectrumListSelectionStyle selectionStyle;

  /// Removes the border and the background of the list.
  final bool isQuiet;

  /// Grays out every item and ignores taps.
  final bool isDisabled;

  const SpectrumListView({
    super.key,
    required this.children,
    this.selects = SpectrumSelects.none,
    this.selected = const [],
    this.onSelectionChange,
    this.onAction,
    this.selectionStyle = SpectrumListSelectionStyle.checkbox,
    this.isQuiet = false,
    this.isDisabled = false,
  });

  /// Returns the state of the item inside a list, or null outside of one.
  static SpectrumListItemState? itemOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ListItemScope>()?.state;
  }

  @override
  State<SpectrumListView> createState() => _SpectrumListViewState();
}

/// State of one item of a SpectrumListView, shared with that item.
class SpectrumListItemState {
  /// Whether the item is selected.
  final bool isSelected;

  /// Whether the item below is selected, so the separator is hidden between them.
  final bool isNextSelected;

  /// Whether the item is the last one, without a separator below it.
  final bool isLast;

  /// How the list manages the selection.
  final SpectrumSelects selects;

  /// How the selected items are shown.
  final SpectrumListSelectionStyle selectionStyle;

  /// Whether the list is quiet.
  final bool isQuiet;

  /// Whether the list is disabled.
  final bool isDisabled;

  /// Selects the item, or runs its action when the list has no selection.
  final VoidCallback onTap;

  const SpectrumListItemState({
    required this.isSelected,
    required this.isNextSelected,
    required this.isLast,
    required this.selects,
    required this.selectionStyle,
    required this.isQuiet,
    required this.isDisabled,
    required this.onTap,
  });
}

/// Keeps the selected items of the list.
class _SpectrumListViewState extends State<SpectrumListView> {
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the selected indexes, the list follows them.
    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  /// In multiple, the tap adds or removes the item. In single, the tapped item becomes
  /// the only selected one. Without selection, the tap runs onAction.
  void _handleTap(int index) {
    if (widget.selects == SpectrumSelects.none) {
      widget.onAction?.call(index);
      return;
    }

    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else if (widget.selects == SpectrumSelects.multiple) {
        _selected.add(index);
      } else {
        _selected
          ..clear()
          ..add(index);
      }
    });

    widget.onSelectionChange?.call(_selected.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;

    // Spectrum 2 list view: a gray-25 box with a 1px gray-300 border and 8px corners,
    // or only the items when quiet.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.isQuiet ? Colors.transparent : colors.surface,
          borderRadius: BorderRadius.circular(widget.isQuiet ? 0 : 8),
          border: widget.isQuiet ? null : Border.all(color: border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, item) in widget.children.indexed)
              _ListItemScope(
                state: SpectrumListItemState(
                  isSelected: _selected.contains(index),
                  isNextSelected: _selected.contains(index + 1),
                  isLast: index == widget.children.length - 1,
                  selects: widget.selects,
                  selectionStyle: widget.selectionStyle,
                  isQuiet: widget.isQuiet,
                  isDisabled: widget.isDisabled,
                  onTap: () => _handleTap(index),
                ),
                child: item,
              ),
          ],
        ),
      ),
    );
  }
}

/// Shares the state of one item with that item.
class _ListItemScope extends InheritedWidget {
  final SpectrumListItemState state;

  const _ListItemScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(_ListItemScope oldWidget) {
    return oldWidget.state.isSelected != state.isSelected ||
        oldWidget.state.isNextSelected != state.isNextSelected ||
        oldWidget.state.isLast != state.isLast ||
        oldWidget.state.selects != state.selects ||
        oldWidget.state.selectionStyle != state.selectionStyle ||
        oldWidget.state.isDisabled != state.isDisabled;
  }
}
