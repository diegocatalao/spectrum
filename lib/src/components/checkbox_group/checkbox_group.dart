import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Checkbox Group: a list of SpectrumCheckbox with a label, a help text
/// and an error message, keeping which ones are checked.
class SpectrumCheckboxGroup extends StatefulWidget {
  /// Checkboxes of the group.
  final List<SpectrumCheckbox> children;

  /// Label of the group.
  final Text? label;

  /// Help text below the group, hidden while it is invalid.
  final Text? description;

  /// Error message below the group, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Indexes of the checkboxes checked at start. When the parent changes them, the group follows.
  final List<int> value;

  /// Called with the checked indexes when a checkbox is tapped.
  final ValueChanged<List<int>>? onChange;

  /// Checkboxes stacked (vertical) or side by side (horizontal).
  final Axis orientation;

  /// Fills the checked boxes with the accent blue.
  final bool isEmphasized;

  /// Grays out every checkbox.
  final bool isDisabled;

  /// Shows the checkboxes in red with the error message.
  final bool isInvalid;

  /// Marks the group as required next to its label.
  final bool isRequired;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumCheckboxGroup({
    super.key,
    required this.children,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value = const [],
    this.onChange,
    this.orientation = Axis.vertical,
    this.isEmphasized = false,
    this.isDisabled = false,
    this.isInvalid = false,
    this.isRequired = false,
    this.labelPosition,
  });

  /// Returns the state of the checkbox inside a group, or null outside of one.
  static ({bool isSelected, bool isEmphasized, bool isDisabled, bool isInvalid, VoidCallback onToggle})? checkboxOf(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_CheckboxScope>();

    if (scope == null) {
      return null;
    }

    return (
      isSelected: scope.isSelected,
      isEmphasized: scope.isEmphasized,
      isDisabled: scope.isDisabled,
      isInvalid: scope.isInvalid,
      onToggle: scope.onToggle,
    );
  }

  @override
  State<SpectrumCheckboxGroup> createState() => _SpectrumCheckboxGroupState();
}

class _SpectrumCheckboxGroupState extends State<SpectrumCheckboxGroup> {
  final Set<int> _value = {};

  @override
  void initState() {
    super.initState();
    _value.addAll(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumCheckboxGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the group follows it.
    if (oldWidget.value.length != widget.value.length || !_value.containsAll(widget.value)) {
      _value
        ..clear()
        ..addAll(widget.value);
    }
  }

  void _toggle(int index) {
    setState(() {
      if (!_value.remove(index)) {
        _value.add(index);
      }
    });
    widget.onChange?.call(_value.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final isVertical = widget.orientation == Axis.vertical;

    return Semantics(
      container: true,
      label: widget.label?.data,
      child: SpectrumField(
        label: widget.label,
        description: widget.description,
        errorMessage: widget.errorMessage,
        contextualHelp: widget.contextualHelp,
        isInvalid: widget.isInvalid,
        isRequired: widget.isRequired,
        isDisabled: isDisabled,
        labelPosition: widget.labelPosition,
        // Spectrum 2 group: the checkboxes 8px apart in a column, or 16px in a row.
        input: Wrap(
          direction: widget.orientation,
          spacing: isVertical ? 8 : 16,
          runSpacing: 8,
          children: [
            for (final (index, checkbox) in widget.children.indexed)
              _CheckboxScope(
                isSelected: _value.contains(index),
                isEmphasized: widget.isEmphasized,
                isDisabled: isDisabled,
                isInvalid: widget.isInvalid,
                onToggle: () => _toggle(index),
                child: checkbox,
              ),
          ],
        ),
      ),
    );
  }
}

class _CheckboxScope extends InheritedWidget {
  final bool isSelected;
  final bool isEmphasized;
  final bool isDisabled;
  final bool isInvalid;
  final VoidCallback onToggle;

  const _CheckboxScope({
    required this.isSelected,
    required this.isEmphasized,
    required this.isDisabled,
    required this.isInvalid,
    required this.onToggle,
    required super.child,
  });

  @override
  bool updateShouldNotify(_CheckboxScope oldWidget) {
    return oldWidget.isSelected != isSelected ||
        oldWidget.isEmphasized != isEmphasized ||
        oldWidget.isDisabled != isDisabled ||
        oldWidget.isInvalid != isInvalid;
  }
}
