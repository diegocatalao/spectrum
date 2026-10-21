import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Range Calendar: one or more months to pick a range of dates, with the
/// first tap selecting the start and the second the end.
class SpectrumRangeCalendar extends StatefulWidget {
  /// Range selected at start. When the parent changes it, the calendar follows.
  final DateTimeRange? value;

  /// Called with the range when its end is selected.
  final ValueChanged<DateTimeRange>? onChange;

  /// First date that can be selected.
  final DateTime? minValue;

  /// Last date that can be selected.
  final DateTime? maxValue;

  /// Dates that can not be selected, crossed out.
  final bool Function(DateTime day)? isDateUnavailable;

  /// Number of months shown side by side, 1 by default.
  final int visibleMonths;

  /// Grays out the calendar and ignores taps.
  final bool isDisabled;

  /// Shows the dates but ignores taps.
  final bool isReadOnly;

  /// Shows the selection in red, with the error message below the months.
  final bool isInvalid;

  /// Text shown below the months when isInvalid is True.
  final Text? errorMessage;

  const SpectrumRangeCalendar({
    super.key,
    this.value,
    this.onChange,
    this.minValue,
    this.maxValue,
    this.isDateUnavailable,
    this.visibleMonths = 1,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.isInvalid = false,
    this.errorMessage,
  });

  @override
  State<SpectrumRangeCalendar> createState() => _SpectrumRangeCalendarState();
}

/// Keeps the selected range, the start being picked and the first month shown.
class _SpectrumRangeCalendarState extends State<SpectrumRangeCalendar> {
  DateTimeRange? _value;

  /// Start of the range being picked, before its end is tapped.
  DateTime? _anchor;

  /// Day under the pointer, to preview the range being picked.
  DateTime? _hovered;

  DateTime _month = DateTime.now();

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    final start = widget.value?.start ?? DateTime.now();
    _month = DateTime(start.year, start.month);
  }

  @override
  void didUpdateWidget(covariant SpectrumRangeCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the calendar follows it and shows its month.
    if (oldWidget.value != widget.value) {
      _value = widget.value;
      _anchor = null;

      if (widget.value != null) {
        _month = DateTime(widget.value!.start.year, widget.value!.start.month);
      }
    }
  }

  /// The first tap picks the start, the second picks the end, in any order.
  void _handleTap(DateTime day) {
    final anchor = _anchor;

    if (anchor == null) {
      setState(() => _anchor = day);
    } else {
      final range = day.isBefore(anchor)
          ? DateTimeRange(start: day, end: anchor)
          : DateTimeRange(start: anchor, end: day);
      setState(() {
        _value = range;
        _anchor = null;
      });
      widget.onChange?.call(range);
    }
  }

  /// While the end is being picked, the range goes from the start to the hovered day.
  DateTimeRange? get _shown {
    final anchor = _anchor;

    if (anchor == null) {
      return _value;
    }

    final end = _hovered ?? anchor;
    return end.isBefore(anchor) ? DateTimeRange(start: end, end: anchor) : DateTimeRange(start: anchor, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return SpectrumCalendarFrame(
      month: _month,
      visibleMonths: widget.visibleMonths,
      isDisabled: widget.isDisabled,
      isInvalid: widget.isInvalid,
      errorMessage: widget.errorMessage,
      onMonthChange: (month) => setState(() => _month = month),
      monthBuilder: (context, month) => SpectrumCalendarGrid(
        month: month,
        range: _shown,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        isDateUnavailable: widget.isDateUnavailable,
        isDisabled: widget.isDisabled,
        isInvalid: widget.isInvalid,
        onTapDay: widget.isReadOnly ? null : _handleTap,
        onHoverDay: (day) {
          if (_anchor != null) {
            setState(() => _hovered = day);
          }
        },
      ),
    );
  }
}
