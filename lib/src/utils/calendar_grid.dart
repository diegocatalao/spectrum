import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Days of one month of the Spectrum 2 calendars, shared by SpectrumCalendar and
/// SpectrumRangeCalendar: the weekday names and a grid of 32px round days.
class SpectrumCalendarGrid extends StatelessWidget {
  /// Any day of the month shown.
  final DateTime month;

  /// Selected day of a single selection.
  final DateTime? selected;

  /// Selected days of a range selection.
  final DateTimeRange? range;

  /// First day that can be selected.
  final DateTime? minValue;

  /// Last day that can be selected.
  final DateTime? maxValue;

  /// Days that can not be selected, crossed out.
  final bool Function(DateTime day)? isDateUnavailable;

  /// Grays out every day and ignores taps.
  final bool isDisabled;

  /// Shows the selection in the negative red.
  final bool isInvalid;

  /// Called with the tapped day.
  final ValueChanged<DateTime>? onTapDay;

  /// Called with the hovered day, used to preview a range.
  final ValueChanged<DateTime?>? onHoverDay;

  const SpectrumCalendarGrid({
    super.key,
    required this.month,
    this.selected,
    this.range,
    this.minValue,
    this.maxValue,
    this.isDateUnavailable,
    this.isDisabled = false,
    this.isInvalid = false,
    this.onTapDay,
    this.onHoverDay,
  });

  static DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localizations = MaterialLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final first = DateTime(month.year, month.month);
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    // Empty cells before the first day, following the first day of the week of the locale.
    final offset = (first.weekday % 7 - localizations.firstDayOfWeekIndex + 7) % 7;
    final weeks = ((offset + days) / 7).ceil();
    final today = _day(DateTime.now());

    // Spectrum 2 weekday names: the small title, 12px below them.
    final header = Row(
      children: [
        for (var column = 0; column < 7; column++)
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                localizations.narrowWeekdays[(column + localizations.firstDayOfWeekIndex) % 7],
                textAlign: TextAlign.center,
                style: (textTheme.titleMedium ?? const TextStyle()).copyWith(color: colors.onSurface),
              ),
            ),
          ),
      ],
    );

    final rows = <Widget>[];

    for (var week = 0; week < weeks; week++) {
      final cells = <Widget>[];

      for (var column = 0; column < 7; column++) {
        final number = week * 7 + column - offset + 1;

        if (number < 1 || number > days) {
          // The days of the other months are not shown, as in Spectrum 2.
          cells.add(const SizedBox(width: 40, height: 32));
        } else {
          final day = DateTime(month.year, month.month, number);
          cells.add(
            _DayCell(
              day: day,
              isToday: day == today,
              isFirstInWeek: column == 0,
              isLastInWeek: column == 6,
              grid: this,
            ),
          );
        }
      }

      rows.add(Row(children: cells));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      // Spectrum 2 gap of 4px between the weeks.
      spacing: 4,
      children: [header, ...rows],
    );
  }
}

/// One day of the grid: a 32px circle in a 40px column, with the range band
/// filling the space between the selected days.
class _DayCell extends StatefulWidget {
  final DateTime day;
  final bool isToday;
  final bool isFirstInWeek;
  final bool isLastInWeek;
  final SpectrumCalendarGrid grid;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isFirstInWeek,
    required this.isLastInWeek,
    required this.grid,
  });

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _isHovered = false;
  bool _isFocused = false;

  bool _isInRange(DateTime day) {
    final range = widget.grid.range;
    return range != null && !day.isBefore(range.start) && !day.isAfter(range.end);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grid = widget.grid;
    final day = widget.day;
    final range = grid.range;
    final isOutOfBounds =
        (grid.minValue != null && day.isBefore(SpectrumCalendarGrid._day(grid.minValue!))) ||
        (grid.maxValue != null && day.isAfter(SpectrumCalendarGrid._day(grid.maxValue!)));
    final isUnavailable = grid.isDateUnavailable?.call(day) ?? false;
    final isDisabled = grid.isDisabled || isOutOfBounds;
    final isInRange = _isInRange(day);
    final isRangeEdge = range != null && (day == range.start || day == range.end);
    final isSelected = (grid.selected != null && day == SpectrumCalendarGrid._day(grid.selected!)) || isRangeEdge;
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final Color accent, accentActive;
    final Color circle, content;

    if (grid.isInvalid) {
      // When isInvalid is True, the selection is the negative red.
      accent = isDark ? SpectrumDarkColors.red700 : SpectrumColors.red900;
      accentActive = isDark ? SpectrumDarkColors.red600 : SpectrumColors.red1000;
    } else {
      // Otherwise the selection is the accent blue.
      accent = colors.primary;
      accentActive = SpectrumThemeExtension.of(context).accentHover;
    }

    if (isDisabled) {
      // When the day is disabled or out of the bounds, it is gray-400 without background.
      circle = Colors.transparent;
      content = colors.outline;
    } else if (isSelected) {
      // When the day is selected (or an edge of the range), it is a filled circle
      // with a white number, darker on hover and focus.
      circle = _isHovered || showFocusRing ? accentActive : accent;
      content = SpectrumColors.white;
    } else if (_isHovered && !isUnavailable) {
      // When the day is hovered, a gray-100 circle shows under it.
      circle = colors.surfaceContainerHigh;
      content = colors.onSurface;
    } else {
      circle = Colors.transparent;
      content = colors.onSurface;
    }

    // The range band joins the selected days, rounded at the ends of the range and
    // of the weeks, in the subtle blue (or red when invalid).
    final isBandStart = isInRange && (day == range?.start || widget.isFirstInWeek);
    final isBandEnd = isInRange && (day == range?.end || widget.isLastInWeek);
    final band = isDark
        ? (grid.isInvalid ? SpectrumDarkColors.red200 : SpectrumDarkColors.blue300)
        : (grid.isInvalid ? SpectrumColors.red100 : SpectrumColors.blue200);

    return SizedBox(
      width: 40,
      height: 32,
      child: Stack(
        children: [
          Positioned.fill(
            left: isBandStart ? 4 : 0,
            right: isBandEnd ? 4 : 0,
            child: Visibility(
              visible: isInRange,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: band,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(isBandStart ? 16 : 0),
                    right: Radius.circular(isBandEnd ? 16 : 0),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Semantics(
              button: true,
              selected: isSelected,
              enabled: !isDisabled && !isUnavailable,
              label: MaterialLocalizations.of(context).formatFullDate(day),
              child: InkWell(
                customBorder: const CircleBorder(),
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: isDisabled || isUnavailable || grid.onTapDay == null ? null : () => grid.onTapDay!(day),
                onHover: (value) {
                  setState(() => _isHovered = value);
                  grid.onHoverDay?.call(value ? day : null);
                },
                onFocusChange: (value) => setState(() => _isFocused = value),
                // Spectrum 2 day: a 32px circle with the 14px number, a 4px dot below it
                // on today, and a 2px line across it when unavailable.
                child: AnimatedContainer(
                  duration: SpectrumMotion.duration,
                  curve: SpectrumMotion.curve,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: circle,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: showFocusRing ? SpectrumThemeExtension.of(context).focusIndicator : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                          color: content,
                          height: 1,
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        child: Visibility(
                          visible: widget.isToday,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: content, shape: BoxShape.circle),
                            child: const SizedBox.square(dimension: 4),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isUnavailable,
                        child: Transform.rotate(angle: -0.28, child: Container(width: 16, height: 2, color: content)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
