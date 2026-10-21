import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Calendar: one or more months to pick a single date, with buttons to
/// go to the previous and next months.
class SpectrumCalendar extends StatefulWidget {
  /// Date selected at start. When the parent changes it, the calendar follows.
  final DateTime? value;

  /// Called with the date selected by a tap.
  final ValueChanged<DateTime>? onChange;

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

  const SpectrumCalendar({
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
  State<SpectrumCalendar> createState() => _SpectrumCalendarState();
}

/// Keeps the selected date and the first month shown.
class _SpectrumCalendarState extends State<SpectrumCalendar> {
  DateTime? _value;
  DateTime _month = DateTime.now();

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _month = DateTime((widget.value ?? DateTime.now()).year, (widget.value ?? DateTime.now()).month);
  }

  @override
  void didUpdateWidget(covariant SpectrumCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the calendar follows it and shows its month.
    if (oldWidget.value != widget.value) {
      _value = widget.value;

      if (widget.value != null) {
        _month = DateTime(widget.value!.year, widget.value!.month);
      }
    }
  }

  void _handleTap(DateTime day) {
    setState(() => _value = day);
    widget.onChange?.call(day);
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
        selected: _value,
        minValue: widget.minValue,
        maxValue: widget.maxValue,
        isDateUnavailable: widget.isDateUnavailable,
        isDisabled: widget.isDisabled,
        isInvalid: widget.isInvalid,
        onTapDay: widget.isReadOnly ? null : _handleTap,
      ),
    );
  }
}

/// Frame of the Spectrum 2 calendars, shared by SpectrumCalendar and
/// SpectrumRangeCalendar: the month titles with the previous and next buttons,
/// the months side by side and the error message.
class SpectrumCalendarFrame extends StatelessWidget {
  /// First month shown.
  final DateTime month;

  /// Number of months shown side by side.
  final int visibleMonths;

  final bool isDisabled;
  final bool isInvalid;
  final Text? errorMessage;

  /// Called with the new first month when the previous or next button is tapped.
  final ValueChanged<DateTime> onMonthChange;

  /// Builds the grid of a month.
  final Widget Function(BuildContext context, DateTime month) monthBuilder;

  const SpectrumCalendarFrame({
    super.key,
    required this.month,
    required this.visibleMonths,
    required this.isDisabled,
    required this.isInvalid,
    required this.errorMessage,
    required this.onMonthChange,
    required this.monthBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localizations = MaterialLocalizations.of(context);
    final months = [for (var index = 0; index < visibleMonths; index++) DateTime(month.year, month.month + index)];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            for (final (index, shown) in months.indexed)
              SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 24,
                  children: [
                    // Spectrum 2 header: the large title of the month between the
                    // quiet previous (first month) and next (last month) buttons.
                    Row(
                      children: [
                        Visibility(
                          visible: index == 0,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: SpectrumActionButton(
                            icon: SpectrumIcon(SpectrumIcons.chevronLeft),
                            isQuiet: true,
                            isDisabled: isDisabled,
                            onTap: () => onMonthChange(DateTime(month.year, month.month - 1)),
                          ),
                        ),
                        Expanded(
                          child: Semantics(
                            header: true,
                            liveRegion: true,
                            child: Text(
                              localizations.formatMonthYear(shown),
                              textAlign: TextAlign.center,
                              style: (textTheme.titleLarge ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: index == months.length - 1,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: SpectrumActionButton(
                            icon: SpectrumIcon(SpectrumIcons.chevronRight),
                            isQuiet: true,
                            isDisabled: isDisabled,
                            onTap: () => onMonthChange(DateTime(month.year, month.month + 1)),
                          ),
                        ),
                      ],
                    ),
                    monthBuilder(context, shown),
                  ],
                ),
              ),
          ],
        ),
        // When isInvalid is True, the error message is shown below the months in red.
        Visibility(
          visible: isInvalid && errorMessage != null,
          child: DefaultTextStyle(
            style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
              fontSize: textTheme.labelSmall?.fontSize,
              color: colors.error,
            ),
            child: errorMessage ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
