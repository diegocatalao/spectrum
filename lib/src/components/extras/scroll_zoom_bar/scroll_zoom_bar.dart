import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Scroll Zoom Bar: a track with a window that can be dragged to scroll and
/// whose ends can be dragged to zoom, like the overview below a timeline or a chart.
class SpectrumScrollZoomBar extends StatefulWidget {
  /// Visible part, from 0 (the start) to 1 (the end).
  final RangeValues value;

  /// Smallest visible part, so the window never gets too narrow.
  final double minExtent;

  /// Called with the visible part while it is scrolled or zoomed.
  final ValueChanged<RangeValues>? onChange;

  /// Track and window stacked vertically instead of horizontally.
  final Axis axis;

  const SpectrumScrollZoomBar({
    super.key,
    this.value = const RangeValues(0, 1),
    this.minExtent = 0.05,
    this.onChange,
    this.axis = Axis.horizontal,
  });

  @override
  State<SpectrumScrollZoomBar> createState() => _SpectrumScrollZoomBarState();
}

class _SpectrumScrollZoomBarState extends State<SpectrumScrollZoomBar> {
  RangeValues _value = const RangeValues(0, 1);

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumScrollZoomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _set(double start, double end) {
    final value = RangeValues(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0));
    setState(() => _value = value);
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVertical = widget.axis == Axis.vertical;

    return LayoutBuilder(
      builder: (context, constraints) {
        final length = isVertical ? constraints.maxHeight : constraints.maxWidth;
        double delta(DragUpdateDetails details) => (isVertical ? details.delta.dy : details.delta.dx) / length;

        Widget handle(void Function(double delta) onDrag) {
          // The ends of the window: 8px grips that resize it.
          return MouseRegion(
            cursor: isVertical ? SystemMouseCursors.resizeUpDown : SystemMouseCursors.resizeLeftRight,
            child: GestureDetector(
              onPanUpdate: (details) => onDrag(delta(details)),
              child: Container(
                width: isVertical ? null : 8,
                height: isVertical ? 8 : null,
                decoration: BoxDecoration(color: colors.onSurface, borderRadius: BorderRadius.circular(4)),
              ),
            ),
          );
        }

        final window = Flex(
          direction: widget.axis,
          children: [
            handle((d) => _set((_value.start + d).clamp(0, _value.end - widget.minExtent), _value.end)),
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final size = _value.end - _value.start;
                    final start = (_value.start + delta(details)).clamp(0.0, 1.0 - size);
                    _set(start, start + size);
                  },
                  child: Container(color: colors.inverseSurface.withValues(alpha: 0.15)),
                ),
              ),
            ),
            handle((d) => _set(_value.start, (_value.end + d).clamp(_value.start + widget.minExtent, 1))),
          ],
        );

        // Spectrum scroll zoom bar: a 16px gray-200 track with the window of the
        // visible part.
        return Semantics(
          slider: true,
          label: 'Visible range',
          value: '${(_value.start * 100).round()}% to ${(_value.end * 100).round()}%',
          child: Container(
            width: isVertical ? 16 : null,
            height: isVertical ? null : 16,
            decoration: BoxDecoration(
              color: isDark ? SpectrumDarkColors.gray200 : SpectrumColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: isVertical ? 0 : _value.start * length,
                  right: isVertical ? 0 : (1 - _value.end) * length,
                  top: isVertical ? _value.start * length : 0,
                  bottom: isVertical ? (1 - _value.end) * length : 0,
                  child: window,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
