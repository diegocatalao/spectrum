import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Date Range Picker: a field with the start and end dates, typed by their
/// segments or picked in a range calendar opened by its button.
class SpectrumDateRangePicker extends StatefulWidget {
  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Range at start. When the parent changes it, the picker follows.
  final DateTimeRange? value;

  /// First date that can be picked.
  final DateTime? minValue;

  /// Last date that can be picked.
  final DateTime? maxValue;

  /// Called with the range when both dates are filled, or null when one is emptied.
  final ValueChanged<DateTimeRange?>? onChange;

  final bool isInvalid;
  final bool isRequired;
  final bool isDisabled;
  final bool isReadOnly;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumDateRangePicker({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value,
    this.minValue,
    this.maxValue,
    this.onChange,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.labelPosition,
  });

  @override
  State<SpectrumDateRangePicker> createState() => _SpectrumDateRangePickerState();
}

class _SpectrumDateRangePickerState extends State<SpectrumDateRangePicker> {
  /// Day, month and year of the start, then of the end.
  List<int?> _parts = List.filled(6, null);

  @override
  void initState() {
    super.initState();
    _parts = _split(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _parts = _split(widget.value);
    }
  }

  List<int?> _split(DateTimeRange? range) {
    return [range?.start.day, range?.start.month, range?.start.year, range?.end.day, range?.end.month, range?.end.year];
  }

  /// Order of the day (d), month (m) and year (y) in the locale.
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

  DateTimeRange? get _range {
    if (_parts.any((part) => part == null)) {
      return null;
    }

    final start = DateTime(_parts[2]!, _parts[1]!, _parts[0]!);
    final end = DateTime(_parts[5]!, _parts[4]!, _parts[3]!);
    return end.isBefore(start) ? null : DateTimeRange(start: start, end: end);
  }

  void _setRange(DateTimeRange? range) {
    setState(() => _parts = _split(range));
    widget.onChange?.call(range);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final order = _order(context);
    const index = {'d': 0, 'm': 1, 'y': 2};
    final segments = {
      'd': const SpectrumInputSegment(min: 1, max: 31, placeholder: 'dd', label: 'Day'),
      'm': const SpectrumInputSegment(min: 1, max: 12, placeholder: 'mm', label: 'Month'),
      'y': const SpectrumInputSegment(min: 1, max: 9999, placeholder: 'yyyy', label: 'Year'),
    };
    // An end before the start turns the field invalid.
    final isComplete = _parts.every((part) => part != null);
    final isInvalid = widget.isInvalid || (isComplete && _range == null);

    SpectrumInputSegment segment(String letter, String prefix, String separator) {
      final base = segments[letter]!;
      return SpectrumInputSegment(
        min: base.min,
        max: base.max,
        placeholder: base.placeholder,
        label: '$prefix ${base.label.toLowerCase()}',
        separator: separator,
      );
    }

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
          for (final (position, letter) in order.indexed) segment(letter, 'Start', position < 2 ? '/' : ' – '),
          for (final (position, letter) in order.indexed) segment(letter, 'End', position < 2 ? '/' : ''),
        ],
        values: [
          for (final letter in order) _parts[index[letter]!],
          for (final letter in order) _parts[3 + index[letter]!],
        ],
        isInvalid: isInvalid,
        isDisabled: isDisabled,
        isReadOnly: widget.isReadOnly,
        onChanged: (values) {
          final parts = [..._parts];

          for (final (position, letter) in order.indexed) {
            parts[index[letter]!] = values[position];
            parts[3 + index[letter]!] = values[3 + position];
          }

          setState(() => _parts = parts);
          widget.onChange?.call(_range);
        },
        // The calendar button opens the range calendar, closed when the end is picked.
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
            builder: (context) => SpectrumRangeCalendar(
              value: _range,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              visibleMonths: 2,
              onChange: (range) {
                _setRange(range);
                SpectrumPopover.closeOf(context)?.call();
              },
            ),
          ),
        ),
      ),
    );
  }
}
