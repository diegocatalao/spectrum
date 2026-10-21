import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Select Box Group: large selectable boxes with an illustration and a
/// label, for one or many choices, like the plan of a subscription.
class SpectrumSelectBoxGroup extends StatefulWidget {
  /// Boxes of the group.
  final List<SpectrumSelectBox> children;

  /// Whether one box (single) or many boxes (multiple) can be selected.
  final SpectrumSelects selects;

  /// Indexes of the boxes selected at start. When the parent changes them, the group follows.
  final List<int> selected;

  /// Called with the new selected indexes when a box is tapped.
  final ValueChanged<List<int>>? onSelectionChange;

  /// Square boxes with the label below the illustration (vertical), or wide boxes
  /// with the label and the description on the right of it (horizontal).
  final Axis orientation;

  /// Grays out every box and ignores taps.
  final bool isDisabled;

  /// Keeps at least one box selected, so tapping the last selected box does nothing.
  final bool disallowEmptySelection;

  const SpectrumSelectBoxGroup({
    super.key,
    required this.children,
    this.selects = SpectrumSelects.single,
    this.selected = const [],
    this.onSelectionChange,
    this.orientation = Axis.vertical,
    this.isDisabled = false,
    this.disallowEmptySelection = false,
  });

  /// Returns the selection of the box inside a group, or null outside of one.
  static ({bool isSelected, bool isMultiple, bool isDisabled, Axis orientation, VoidCallback onToggle})? boxOf(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SelectBoxScope>();

    if (scope == null) {
      return null;
    }

    return (
      isSelected: scope.isSelected,
      isMultiple: scope.isMultiple,
      isDisabled: scope.isDisabled,
      orientation: scope.orientation,
      onToggle: scope.onToggle,
    );
  }

  @override
  State<SpectrumSelectBoxGroup> createState() => _SpectrumSelectBoxGroupState();
}

/// Keeps the selected boxes of the group.
class _SpectrumSelectBoxGroupState extends State<SpectrumSelectBoxGroup> {
  /// Indexes of the selected boxes, changed on every tap.
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumSelectBoxGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the selected indexes, the group follows them.
    if (!_sameIndexes(oldWidget.selected, widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  bool _sameIndexes(List<int> a, List<int> b) => a.length == b.length && a.toSet().containsAll(b);

  /// In multiple, the tap adds or removes the box from the selection. In single,
  /// the tapped box becomes the only selected one, and tapping it again unselects
  /// it, unless disallowEmptySelection is True.
  void _handleToggle(int index) {
    final isSelected = _selected.contains(index);

    if (isSelected && widget.disallowEmptySelection && _selected.length == 1) {
      return;
    }

    setState(() {
      if (isSelected) {
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
    // Spectrum 2 group: 24px between the boxes, wrapping to new lines.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: [
          for (final (index, child) in widget.children.indexed)
            _SelectBoxScope(
              isSelected: _selected.contains(index),
              isMultiple: widget.selects == SpectrumSelects.multiple,
              isDisabled: widget.isDisabled,
              orientation: widget.orientation,
              onToggle: () => _handleToggle(index),
              child: child,
            ),
        ],
      ),
    );
  }
}

/// Shares the selection of one box and the options of the group with that box.
class _SelectBoxScope extends InheritedWidget {
  final bool isSelected;
  final bool isMultiple;
  final bool isDisabled;
  final Axis orientation;
  final VoidCallback onToggle;

  const _SelectBoxScope({
    required this.isSelected,
    required this.isMultiple,
    required this.isDisabled,
    required this.orientation,
    required this.onToggle,
    required super.child,
  });

  @override
  bool updateShouldNotify(_SelectBoxScope oldWidget) {
    return oldWidget.isSelected != isSelected ||
        oldWidget.isMultiple != isMultiple ||
        oldWidget.isDisabled != isDisabled ||
        oldWidget.orientation != orientation;
  }
}
