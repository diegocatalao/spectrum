import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Time Field: a field to type a time by its hour and minute segments, in
/// 12 or 24 hours, with a label, a help text and an error message.
class SpectrumTimeField extends StatefulWidget {
  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Shows the field in red with the error message.
  final bool isInvalid;

  /// Marks the field as required next to its label.
  final bool isRequired;

  /// Grays out the field and ignores input.
  final bool isDisabled;

  /// Shows the value but ignores changes.
  final bool isReadOnly;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  /// Time at start. When the parent changes it, the field follows.
  final TimeOfDay? value;

  /// Shows the hours from 0 to 23 instead of 1 to 12 with AM and PM. Follows the
  /// device setting when null.
  final bool? is24Hours;

  /// Called with the time when every segment is filled, or null when one is emptied.
  final ValueChanged<TimeOfDay?>? onChange;

  const SpectrumTimeField({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.labelPosition,
    this.value,
    this.is24Hours,
    this.onChange,
  });

  @override
  State<SpectrumTimeField> createState() => _SpectrumTimeFieldState();
}

class _SpectrumTimeFieldState extends State<SpectrumTimeField> {
  /// Hour (0 to 23) and minute.
  int? _hour;
  int? _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.value?.hour;
    _minute = widget.value?.minute;
  }

  @override
  void didUpdateWidget(covariant SpectrumTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _hour = widget.value?.hour;
      _minute = widget.value?.minute;
    }
  }

  void _emit() {
    if (_hour != null && _minute != null) {
      widget.onChange?.call(TimeOfDay(hour: _hour!, minute: _minute!));
    } else {
      widget.onChange?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final is24 = widget.is24Hours ?? MediaQuery.alwaysUse24HourFormatOf(context);
    final List<SpectrumInputSegment> segments;
    final List<int?> values;

    if (is24) {
      // In 24 hours, the hour goes from 0 to 23.
      segments = const [
        SpectrumInputSegment(min: 0, max: 23, placeholder: '––', label: 'Hour', separator: ':'),
        SpectrumInputSegment(min: 0, max: 59, placeholder: '––', label: 'Minute'),
      ];
      values = [_hour, _minute];
    } else {
      // In 12 hours, the hour goes from 1 to 12, followed by AM or PM.
      segments = [
        const SpectrumInputSegment(min: 1, max: 12, placeholder: '––', label: 'Hour', separator: ':'),
        const SpectrumInputSegment(min: 0, max: 59, placeholder: '––', label: 'Minute', separator: ' '),
        SpectrumInputSegment(
          min: 0,
          max: 1,
          placeholder: 'AM',
          label: 'AM or PM',
          format: (value) => value == 0 ? 'AM' : 'PM',
        ),
      ];
      final hour12 = _hour == null ? null : (_hour! % 12 == 0 ? 12 : _hour! % 12);
      values = [hour12, _minute, _hour == null ? null : (_hour! >= 12 ? 1 : 0)];
    }

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: widget.isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      input: SpectrumSegmentedInput(
        segments: segments,
        values: values,
        isInvalid: widget.isInvalid,
        isDisabled: isDisabled,
        isReadOnly: widget.isReadOnly,
        onChanged: (next) {
          setState(() {
            _minute = next[1];

            if (is24) {
              _hour = next[0];
            } else if (next[0] != null) {
              final isPm = (next.length > 2 ? next[2] : null) == 1;
              _hour = next[0]! % 12 + (isPm ? 12 : 0);
            } else {
              _hour = null;
            }
          });
          _emit();
        },
      ),
    );
  }
}
