import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Date Field: a field to type a date by its day, month and year segments,
/// in the order of the locale, with a label, a help text and an error message.
class SpectrumDateField extends StatefulWidget {
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

  /// Date at start. When the parent changes it, the field follows.
  final DateTime? value;

  /// First date accepted; earlier dates turn the field invalid.
  final DateTime? minValue;

  /// Last date accepted; later dates turn the field invalid.
  final DateTime? maxValue;

  /// Called with the date when every segment is filled, or null when one is emptied.
  final ValueChanged<DateTime?>? onChange;

  /// Widget after the segments, used by the date picker for its calendar button.
  final Widget? trailing;

  const SpectrumDateField({
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
    this.minValue,
    this.maxValue,
    this.onChange,
    this.trailing,
  });

  @override
  State<SpectrumDateField> createState() => _SpectrumDateFieldState();
}

class _SpectrumDateFieldState extends State<SpectrumDateField> {
  /// Values of the day, month and year, in this order.
  List<int?> _parts = [null, null, null];

  @override
  void initState() {
    super.initState();
    _parts = _split(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumDateField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _parts = _split(widget.value);
    }
  }

  List<int?> _split(DateTime? date) => [date?.day, date?.month, date?.year];

  /// Order of the segments in the locale, like month, day and year in English.
  List<String> _order(BuildContext context) {
    final help = MaterialLocalizations.of(context).dateHelpText.toLowerCase();
    final order = <String>[];

    for (final letter in help.split('')) {
      if ((letter == 'd' || letter == 'm' || letter == 'y') && !order.contains(letter)) {
        order.add(letter);
      }
    }

    return order.length == 3 ? order : ['m', 'd', 'y'];
  }

  void _handleChanged(List<String> order, List<int?> values) {
    final parts = [..._parts];

    for (final (index, letter) in order.indexed) {
      parts[['d', 'm', 'y'].indexOf(letter)] = values[index];
    }

    final [day, month, year] = parts;

    // The day never passes the last day of the month.
    if (day != null && month != null && year != null) {
      parts[0] = day.clamp(1, DateUtils.getDaysInMonth(year, month));
    }

    setState(() => _parts = parts);

    if (parts.every((part) => part != null)) {
      widget.onChange?.call(DateTime(parts[2]!, parts[1]!, parts[0]!));
    } else {
      widget.onChange?.call(null);
    }
  }

  bool get _isOutOfBounds {
    if (_parts.any((part) => part == null)) {
      return false;
    }

    final date = DateTime(_parts[2]!, _parts[1]!, _parts[0]!);
    return (widget.minValue != null && date.isBefore(DateUtils.dateOnly(widget.minValue!))) ||
        (widget.maxValue != null && date.isAfter(DateUtils.dateOnly(widget.maxValue!)));
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final isInvalid = widget.isInvalid || _isOutOfBounds;
    final order = _order(context);
    final segments = {
      'd': const SpectrumInputSegment(min: 1, max: 31, placeholder: 'dd', label: 'Day'),
      'm': const SpectrumInputSegment(min: 1, max: 12, placeholder: 'mm', label: 'Month'),
      'y': const SpectrumInputSegment(min: 1, max: 9999, placeholder: 'yyyy', label: 'Year'),
    };

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      input: SpectrumSegmentedInput(
        segments: [
          for (final (index, letter) in order.indexed)
            SpectrumInputSegment(
              min: segments[letter]!.min,
              max: segments[letter]!.max,
              placeholder: segments[letter]!.placeholder,
              label: segments[letter]!.label,
              separator: index < order.length - 1 ? '/' : '',
            ),
        ],
        values: [
          for (final letter in order) _parts[['d', 'm', 'y'].indexOf(letter)],
        ],
        onChanged: (values) => _handleChanged(order, values),
        isInvalid: isInvalid,
        isDisabled: isDisabled,
        isReadOnly: widget.isReadOnly,
        trailing: widget.trailing,
      ),
    );
  }
}
