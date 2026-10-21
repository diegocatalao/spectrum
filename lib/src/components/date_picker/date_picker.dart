import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Date Picker: a date field with a button that opens a calendar in a
/// popover, to type or pick a date.
class SpectrumDatePicker extends StatefulWidget {
  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Date at start. When the parent changes it, the picker follows.
  final DateTime? value;

  /// First date that can be picked.
  final DateTime? minValue;

  /// Last date that can be picked.
  final DateTime? maxValue;

  /// Dates that can not be picked in the calendar.
  final bool Function(DateTime day)? isDateUnavailable;

  /// Called with the date when it is typed or picked, or null when it is emptied.
  final ValueChanged<DateTime?>? onChange;

  final bool isInvalid;
  final bool isRequired;
  final bool isDisabled;
  final bool isReadOnly;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumDatePicker({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value,
    this.minValue,
    this.maxValue,
    this.isDateUnavailable,
    this.onChange,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.labelPosition,
  });

  @override
  State<SpectrumDatePicker> createState() => _SpectrumDatePickerState();
}

class _SpectrumDatePickerState extends State<SpectrumDatePicker> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _set(DateTime? value) {
    setState(() => _value = value);
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);

    // The date field with the calendar button at its end, which opens the calendar
    // in a popover below the field, closed when a date is picked.
    return SpectrumDateField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      value: _value,
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      isInvalid: widget.isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      isReadOnly: widget.isReadOnly,
      labelPosition: widget.labelPosition,
      onChange: _set,
      trailing: SpectrumPopover(
        placement: SpectrumPopoverPlacement.bottomEnd,
        padding: const EdgeInsets.all(24),
        trigger: (context, onToggle) => Semantics(
          label: 'Calendar',
          child: SpectrumActionButton(
            icon: SpectrumIcon(SpectrumIcons.calendar),
            isQuiet: true,
            isDisabled: isDisabled || widget.isReadOnly,
            onTap: onToggle,
          ),
        ),
        child: Builder(
          builder: (context) => SpectrumCalendar(
            value: _value,
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            isDateUnavailable: widget.isDateUnavailable,
            onChange: (date) {
              _set(date);
              SpectrumPopover.closeOf(context)?.call();
            },
          ),
        ),
      ),
    );
  }
}
