import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Track and thumbs of the Spectrum 2 sliders, shared by SpectrumSlider (one value)
/// and SpectrumRangeSlider (two values): a 32px area with the gray-300 track, the
/// filled part and 20px round thumbs moved by drag, tap and the arrow keys.
class SpectrumSliderTrack extends StatefulWidget {
  /// Values of the thumbs, one for a slider and two (start and end) for a range.
  final List<double> values;

  final double minValue;
  final double maxValue;

  /// Amount between the values that can be picked.
  final double step;

  /// Value where the fill starts, for one thumb. The start of the track by default.
  final double? fillOffset;

  /// Fills the track with the accent blue instead of the neutral gray.
  final bool isEmphasized;

  /// A 16px thick track instead of the 4px thin one.
  final bool isThick;

  /// A narrow 6px thumb instead of the round one.
  final bool isPrecise;

  final bool isDisabled;

  /// Label read by screen readers for each thumb.
  final List<String> semanticLabels;

  /// Called with the index of the thumb and its new value while it moves.
  final void Function(int index, double value)? onChanged;

  /// Called when the thumb is released.
  final VoidCallback? onChangeEnd;

  const SpectrumSliderTrack({
    super.key,
    required this.values,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    this.fillOffset,
    this.isEmphasized = false,
    this.isThick = false,
    this.isPrecise = false,
    this.isDisabled = false,
    this.semanticLabels = const [],
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<SpectrumSliderTrack> createState() => _SpectrumSliderTrackState();
}

class _SpectrumSliderTrackState extends State<SpectrumSliderTrack> {
  /// Thumb being dragged, or null.
  int? _active;
  int? _hovered;
  final Set<int> _focused = {};

  double get _range => widget.maxValue - widget.minValue;

  double _fraction(double value) => _range <= 0 ? 0 : ((value - widget.minValue) / _range).clamp(0.0, 1.0);

  /// Converts a position on the track to a value snapped to the step, keeping the two
  /// thumbs of a range in order.
  double _valueAt(double dx, double width, int index) {
    var value = widget.minValue + (dx / width).clamp(0.0, 1.0) * _range;

    if (widget.step > 0) {
      value = widget.minValue + ((value - widget.minValue) / widget.step).round() * widget.step;
    }

    value = value.clamp(widget.minValue, widget.maxValue);

    if (widget.values.length == 2 && index == 0) {
      value = value.clamp(widget.minValue, widget.values[1]);
    } else if (widget.values.length == 2 && index == 1) {
      value = value.clamp(widget.values[0], widget.maxValue);
    }

    return value;
  }

  /// The thumb closest to the position, so a tap on a range moves the nearest one.
  int _nearest(double dx, double width) {
    var nearest = 0;
    var distance = double.infinity;

    for (final (index, value) in widget.values.indexed) {
      final gap = (_fraction(value) * width - dx).abs();

      if (gap < distance) {
        distance = gap;
        nearest = index;
      }
    }

    return nearest;
  }

  KeyEventResult _handleKey(int index, KeyEvent event) {
    if (event is KeyUpEvent || widget.isDisabled) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final double direction;

    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.arrowUp) {
      direction = 1;
    } else if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.arrowDown) {
      direction = -1;
    } else {
      return KeyEventResult.ignored;
    }

    final width = _range;
    final next = _valueAt((_fraction(widget.values[index]) * width) + direction * widget.step, width, index);
    widget.onChanged?.call(index, next);
    widget.onChangeEnd?.call();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackHeight = widget.isThick ? 16.0 : 4.0;
    final Color track, fill;

    if (widget.isDisabled) {
      // When disabled, the track and the fill are the disabled gray.
      track = colors.surfaceContainerHigh;
      fill = colors.outlineVariant;
    } else {
      // Otherwise the track is gray-300 and the fill gray-800, or blue when emphasized.
      track = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
      fill = widget.isEmphasized ? colors.primary : colors.onSurface;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final double fillStart, fillEnd;

        if (widget.values.length == 2) {
          // A range is filled between its two thumbs.
          fillStart = _fraction(widget.values[0]);
          fillEnd = _fraction(widget.values[1]);
        } else {
          // One thumb is filled from the offset (or the start) to the thumb.
          final offset = _fraction(widget.fillOffset ?? widget.minValue);
          final thumb = _fraction(widget.values.first);
          fillStart = offset < thumb ? offset : thumb;
          fillEnd = offset < thumb ? thumb : offset;
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.isDisabled
              ? null
              : (details) {
                  final index = _nearest(details.localPosition.dx, width);
                  widget.onChanged?.call(index, _valueAt(details.localPosition.dx, width, index));
                },
          onTapUp: widget.isDisabled ? null : (details) => widget.onChangeEnd?.call(),
          onHorizontalDragStart: widget.isDisabled
              ? null
              : (details) {
                  final index = _nearest(details.localPosition.dx, width);
                  setState(() => _active = index);
                  widget.onChanged?.call(index, _valueAt(details.localPosition.dx, width, index));
                },
          onHorizontalDragUpdate: widget.isDisabled
              ? null
              : (details) {
                  final index = _active ?? 0;
                  widget.onChanged?.call(index, _valueAt(details.localPosition.dx, width, index));
                },
          onHorizontalDragEnd: widget.isDisabled
              ? null
              : (details) {
                  setState(() => _active = null);
                  widget.onChangeEnd?.call();
                },
          // Spectrum 2 track area: 32px high in the M size.
          child: SizedBox(
            height: 32,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: trackHeight,
                  decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(widget.isThick ? 4 : 10)),
                ),
                Positioned(
                  left: fillStart * width,
                  width: (fillEnd - fillStart) * width,
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(widget.isThick ? 4 : 10),
                    ),
                  ),
                ),
                for (final (index, value) in widget.values.indexed)
                  Positioned(
                    left: _fraction(value) * width - (widget.isPrecise ? 3 : 10),
                    child: _buildThumb(context, index, value),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThumb(BuildContext context, int index, double value) {
    final colors = Theme.of(context).colorScheme;
    final isActive = _active == index || _hovered == index;
    final showFocusRing =
        _focused.contains(index) && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final Color border;

    if (widget.isDisabled) {
      border = colors.outline;
    } else if (isActive) {
      // A hovered or dragged thumb has a gray-900 border.
      border = colors.inverseSurface;
    } else {
      border = colors.onSurface;
    }

    // Spectrum 2 thumb: a 20px gray-25 circle with a 2px border, or a 6x22px bar when precise.
    return Semantics(
      slider: true,
      label: index < widget.semanticLabels.length ? widget.semanticLabels[index] : null,
      value: value.toString(),
      child: Focus(
        canRequestFocus: !widget.isDisabled,
        onKeyEvent: (node, event) => _handleKey(index, event),
        onFocusChange: (hasFocus) => setState(() {
          if (hasFocus) {
            _focused.add(index);
          } else {
            _focused.remove(index);
          }
        }),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = index),
          onExit: (_) => setState(() => _hovered = null),
          child: Container(
            width: widget.isPrecise ? 6 : 20,
            height: widget.isPrecise ? 22 : 20,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: border, width: 2),
              boxShadow: showFocusRing
                  ? [
                      BoxShadow(color: colors.surface, spreadRadius: 2),
                      BoxShadow(color: SpectrumThemeExtension.of(context).focusIndicator, spreadRadius: 4),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
