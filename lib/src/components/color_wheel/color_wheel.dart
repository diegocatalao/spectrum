import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Color Wheel: a circular track to pick the hue of a color, keeping
/// its saturation and brightness.
class SpectrumColorWheel extends StatefulWidget {
  /// Color selected at start. When the parent changes it, the wheel follows.
  final Color value;

  /// Called with the new color while the handle moves.
  final ValueChanged<Color>? onChange;

  /// Called with the final color when the handle is released.
  final ValueChanged<Color>? onChangeEnd;

  /// Grays out the wheel and ignores drags.
  final bool isDisabled;

  /// Diameter of the wheel, 192px by default and never below 175px.
  final double size;

  const SpectrumColorWheel({
    super.key,
    required this.value,
    this.onChange,
    this.onChangeEnd,
    this.isDisabled = false,
    this.size = 192,
  });

  @override
  State<SpectrumColorWheel> createState() => _SpectrumColorWheelState();
}

/// Keeps the color being picked and the drag and focus states.
class _SpectrumColorWheelState extends State<SpectrumColorWheel> {
  /// Thickness of the track, 24px as in Spectrum 2.
  static const _thickness = 24.0;

  HSVColor _hsv = const HSVColor.fromAHSV(1, 0, 1, 1);
  bool _isDragging = false;
  bool _isFocused = false;

  double get _diameter => math.max(widget.size, 175);

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumColorWheel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the wheel follows it.
    if (oldWidget.value != widget.value && widget.value != _hsv.toColor()) {
      _hsv = HSVColor.fromColor(widget.value);
    }
  }

  /// Turns the handle to the angle of the position around the center.
  void _update(Offset position) {
    final center = Offset(_diameter / 2, _diameter / 2);
    final angle = math.atan2(position.dy - center.dy, position.dx - center.dx);
    final hue = (angle * 180 / math.pi + 360) % 360;

    setState(() => _hsv = _hsv.withHue(hue));
    widget.onChange?.call(_hsv.toColor());
  }

  /// Turns the hue by 1 degree with the arrow keys.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || widget.isDisabled) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final double step;

    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.arrowUp) {
      step = 1;
    } else if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.arrowDown) {
      step = -1;
    } else {
      return KeyEventResult.ignored;
    }

    setState(() => _hsv = _hsv.withHue((_hsv.hue + step + 360) % 360));
    widget.onChange?.call(_hsv.toColor());
    widget.onChangeEnd?.call(_hsv.toColor());
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = _diameter / 2 - _thickness / 2;
    final angle = _hsv.hue * math.pi / 180;
    // The handle sits in the middle of the track, at the angle of the hue.
    final handle = Offset(_diameter / 2 + radius * math.cos(angle), _diameter / 2 + radius * math.sin(angle));
    final isActive =
        _isDragging || (_isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional);

    // Tells screen readers the hue of the color.
    return Semantics(
      slider: true,
      enabled: !widget.isDisabled,
      label: 'Hue',
      value: '${_hsv.hue.round()}°',
      child: Focus(
        canRequestFocus: !widget.isDisabled,
        onKeyEvent: _handleKey,
        onFocusChange: (value) => setState(() => _isFocused = value),
        child: GestureDetector(
          onPanStart: widget.isDisabled
              ? null
              : (details) {
                  setState(() => _isDragging = true);
                  _update(details.localPosition);
                },
          onPanUpdate: widget.isDisabled ? null : (details) => _update(details.localPosition),
          onPanEnd: widget.isDisabled
              ? null
              : (details) {
                  setState(() => _isDragging = false);
                  widget.onChangeEnd?.call(_hsv.toColor());
                },
          child: SizedBox.square(
            dimension: _diameter,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _WheelPainter(
                      thickness: _thickness,
                      disabled: widget.isDisabled ? colors.surfaceContainerHigh : null,
                    ),
                  ),
                ),
                Positioned(
                  left: handle.dx,
                  top: handle.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -0.5),
                    child: SpectrumColorHandle(
                      color: _hsv.toColor(),
                      isActive: isActive,
                      isDisabled: widget.isDisabled,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the ring with every hue, or gray when disabled.
class _WheelPainter extends CustomPainter {
  final double thickness;

  /// Color of the disabled ring, or null to paint the hues.
  final Color? disabled;

  const _WheelPainter({required this.thickness, this.disabled});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(thickness / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    if (disabled != null) {
      paint.color = disabled!;
    } else {
      // Every hue around the circle, starting with red at the right.
      paint.shader = SweepGradient(
        colors: [for (var hue = 0; hue <= 360; hue += 60) HSVColor.fromAHSV(1, hue % 360, 1, 1).toColor()],
      ).createShader(Offset.zero & size);
    }

    canvas.drawOval(rect, paint);

    // 1px outline of gray-1000 at 10% on both edges of the track.
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = SpectrumColors.black.withValues(alpha: 0.1);
    canvas.drawOval((Offset.zero & size).deflate(0.5), outline);
    canvas.drawOval((Offset.zero & size).deflate(thickness - 0.5), outline);
  }

  @override
  bool shouldRepaint(_WheelPainter oldDelegate) => oldDelegate.disabled != disabled;
}
