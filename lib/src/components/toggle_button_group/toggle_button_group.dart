import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Toggle Button Group: toggle buttons side by side (or stacked) where
/// one (single) or many (multiple) can be selected, like the alignment of a text.
class SpectrumToggleButtonGroup extends StatefulWidget {
  /// Toggle buttons of the group.
  final List<SpectrumToggleButton> children;

  /// Whether one button (single) or many buttons (multiple) can be selected.
  final SpectrumSelects selects;

  /// Indexes of the buttons selected at start. When the parent changes them, the group follows.
  final List<int> selected;

  /// Called with the new selected indexes when a button is tapped.
  final ValueChanged<List<int>>? onSelectionChange;

  /// Keeps at least one button selected, so tapping the last selected one does nothing.
  final bool disallowEmptySelection;

  /// Direction of the buttons, horizontal by default.
  final Axis axis;

  /// Compact keeps 2px between the buttons and squares the inner corners.
  final VisualDensity density;

  /// Fills the selected buttons with the accent blue.
  final bool isEmphasized;

  /// Makes every button of the group quiet.
  final bool isQuiet;

  /// Disables every button of the group.
  final bool isDisabled;

  /// Fixed white or black colors for groups over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  const SpectrumToggleButtonGroup({
    super.key,
    required this.children,
    this.selects = SpectrumSelects.single,
    this.selected = const [],
    this.onSelectionChange,
    this.disallowEmptySelection = false,
    this.axis = Axis.horizontal,
    this.density = VisualDensity.standard,
    this.isEmphasized = false,
    this.isQuiet = false,
    this.isDisabled = false,
    this.staticColor,
  });

  /// Returns the selection of the toggle button inside a group, or null outside of one.
  static ({bool isSelected, bool isEmphasized, VoidCallback onToggle})? buttonOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ToggleGroupItemScope>();

    if (scope == null) {
      return null;
    }

    return (isSelected: scope.isSelected, isEmphasized: scope.isEmphasized, onToggle: scope.onToggle);
  }

  @override
  State<SpectrumToggleButtonGroup> createState() => _SpectrumToggleButtonGroupState();
}

/// Keeps the selected buttons of the group.
class _SpectrumToggleButtonGroupState extends State<SpectrumToggleButtonGroup> {
  /// Indexes of the selected buttons, changed on every tap.
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumToggleButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the selected indexes, the group follows them.
    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  /// In multiple, the tap adds or removes the button. In single, the tapped button
  /// becomes the only selected one, and tapping it again unselects it, unless
  /// disallowEmptySelection is True.
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
    // The action button group places the buttons and shares its options, like the
    // square inner corners of the compact density, and each button receives its
    // selection from the scope.
    return SpectrumActionButtonGroup(
      axis: widget.axis,
      density: widget.density,
      isQuiet: widget.isQuiet,
      isDisabled: widget.isDisabled,
      staticColor: widget.staticColor,
      children: [
        for (final (index, child) in widget.children.indexed)
          _ToggleGroupItemScope(
            isSelected: _selected.contains(index),
            isEmphasized: widget.isEmphasized,
            onToggle: () => _handleToggle(index),
            child: Semantics(inMutuallyExclusiveGroup: widget.selects == SpectrumSelects.single, child: child),
          ),
      ],
    );
  }
}

/// Shares the selection of one button with that button.
class _ToggleGroupItemScope extends InheritedWidget {
  final bool isSelected;
  final bool isEmphasized;
  final VoidCallback onToggle;

  const _ToggleGroupItemScope({
    required this.isSelected,
    required this.isEmphasized,
    required this.onToggle,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ToggleGroupItemScope oldWidget) {
    return oldWidget.isSelected != isSelected || oldWidget.isEmphasized != isEmphasized;
  }
}
