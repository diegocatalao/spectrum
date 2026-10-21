import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Checkbox Group: a list of SpectrumRadio with a label, a help text
/// and an error message, keeping which ones are checked.
class SpectrumRadioGroup extends StatefulWidget {
  /// Radios of the group.
  final List<SpectrumRadio> children;

  /// Label of the group.
  final Text? label;

  /// Help text below the group, hidden while it is invalid.
  final Text? description;

  /// Error message below the group, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Value of the radio selected at start. When the parent changes it, the group follows.
  final String? value;

  /// Called with the value of the radio selected by a tap.
  final ValueChanged<String>? onChange;

  /// Radios stacked (vertical) or side by side (horizontal).
  final Axis orientation;

  /// Fills the selected radio with the accent blue.
  final bool isEmphasized;

  /// Grays out every radio.
  final bool isDisabled;

  /// Shows the radios in red with the error message.
  final bool isInvalid;

  /// Marks the group as required next to its label.
  final bool isRequired;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumRadioGroup({
    super.key,
    required this.children,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value,
    this.onChange,
    this.orientation = Axis.vertical,
    this.isEmphasized = false,
    this.isDisabled = false,
    this.isInvalid = false,
    this.isRequired = false,
    this.labelPosition,
  });

  /// Returns the state of the radio inside a group, or null outside of one.
  static ({bool isSelected, bool isEmphasized, bool isDisabled, bool isInvalid, VoidCallback onToggle})? radioOf(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_RadioScope>();

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
  State<SpectrumRadioGroup> createState() => _SpectrumRadioGroupState();
}

class _SpectrumRadioGroupState extends State<SpectrumRadioGroup> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumRadioGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the group follows it.
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _select(String value) {
    if (value != _value) {
      setState(() => _value = value);
      widget.onChange?.call(value);
    }
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
        // Spectrum 2 group: the radios 8px apart in a column, or 16px in a row.
        input: Wrap(
          direction: widget.orientation,
          spacing: isVertical ? 8 : 16,
          runSpacing: 8,
          children: [
            for (final radio in widget.children)
              _RadioScope(
                isSelected: radio.value == _value,
                isEmphasized: widget.isEmphasized,
                isDisabled: isDisabled,
                isInvalid: widget.isInvalid,
                onToggle: () => _select(radio.value),
                child: Semantics(inMutuallyExclusiveGroup: true, child: radio),
              ),
          ],
        ),
      ),
    );
  }
}

class _RadioScope extends InheritedWidget {
  final bool isSelected;
  final bool isEmphasized;
  final bool isDisabled;
  final bool isInvalid;
  final VoidCallback onToggle;

  const _RadioScope({
    required this.isSelected,
    required this.isEmphasized,
    required this.isDisabled,
    required this.isInvalid,
    required this.onToggle,
    required super.child,
  });

  @override
  bool updateShouldNotify(_RadioScope oldWidget) {
    return oldWidget.isSelected != isSelected ||
        oldWidget.isEmphasized != isEmphasized ||
        oldWidget.isDisabled != isDisabled ||
        oldWidget.isInvalid != isInvalid;
  }
}
