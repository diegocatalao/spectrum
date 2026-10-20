import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Progress Circle: a circle that shows the progress of an operation,
/// or that an operation is running, in a small space.
class SpectrumProgressCircle extends StatefulWidget {
  /// Current value, between minValue and maxValue.
  final double value;

  /// Value of an empty circle.
  final double minValue;

  /// Value of a full circle.
  final double maxValue;

  /// Shows an arc spinning around the circle, for operations with an unknown duration.
  final bool isIndeterminate;

  /// Fixed white or black colors for circles over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  /// Text read by screen readers, like "Loading".
  final String? semanticLabel;

  const SpectrumProgressCircle({
    super.key,
    this.value = 0,
    this.minValue = 0,
    this.maxValue = 100,
    this.isIndeterminate = false,
    this.staticColor,
    this.semanticLabel,
  });

  @override
  State<SpectrumProgressCircle> createState() => _SpectrumProgressCircleState();
}

/// Keeps the animation of the indeterminate circle.
class _SpectrumProgressCircleState extends State<SpectrumProgressCircle> with SingleTickerProviderStateMixin {
  /// Spectrum 2 indeterminate animation: one turn per second, while the arc
  /// grows and shrinks. It is created in initState, since it needs this State as its ticker.
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant SpectrumProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isIndeterminate != widget.isIndeterminate) {
      _updateAnimation();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Runs the animation only while the circle is indeterminate.
  void _updateAnimation() {
    if (widget.isIndeterminate) {
      _controller?.repeat();
    } else {
      _controller?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final range = widget.maxValue - widget.minValue;
    final progress = range <= 0 ? 0.0 : ((widget.value - widget.minValue) / range).clamp(0.0, 1.0);
    final Color track, fill;

    if (widget.staticColor == SpectrumStaticColor.black) {
      // When staticColor is black, the circle uses translucent black over light images.
      track = SpectrumColors.black.withValues(alpha: 0.3);
      fill = SpectrumColors.black.withValues(alpha: 0.9);
    } else if (widget.staticColor == SpectrumStaticColor.white) {
      // When staticColor is white, the circle uses translucent white over dark images.
      track = SpectrumColors.white.withValues(alpha: 0.3);
      fill = SpectrumColors.white.withValues(alpha: 0.9);
    } else {
      // Otherwise the track is gray-300 and the fill is the accent blue.
      track = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
      fill = colors.primary;
    }

    // Tells screen readers that this is a progress indicator, with its value.
    return Semantics(
      label: widget.semanticLabel,
      value: widget.isIndeterminate ? null : '${(progress * 100).round()}%',
      // Spectrum 2 progress circle: 32px with a 3px stroke in the M size.
      child: SizedBox.square(
        dimension: 32,
        child: AnimatedBuilder(
          animation: _controller ?? kAlwaysDismissedAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: _ProgressCirclePainter(
                track: track,
                fill: fill,
                progress: progress,
                isIndeterminate: widget.isIndeterminate,
                time: _controller?.value ?? 0,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Paints the track and the arc of the circle.
class _ProgressCirclePainter extends CustomPainter {
  final Color track;
  final Color fill;
  final double progress;
  final bool isIndeterminate;

  /// Position of the indeterminate animation, from 0 to 1.
  final double time;

  _ProgressCirclePainter({
    required this.track,
    required this.fill,
    required this.progress,
    required this.isIndeterminate,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 3.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = track);

    final double start, sweep;

    if (isIndeterminate) {
      // The arc turns once per second and its length goes from 25% of the circle
      // to 80% at 30% of the turn and back, as the stroke-dashoffset of Spectrum 2.
      final double length;

      if (time < 0.3) {
        length = 0.25 + 0.55 * Curves.easeInOut.transform(time / 0.3);
      } else {
        length = 0.8 - 0.55 * Curves.easeInOut.transform((time - 0.3) / 0.7);
      }

      start = -math.pi / 2 + 2 * math.pi * time;
      sweep = 2 * math.pi * length;
    } else {
      // The determinate arc starts at the top and grows clockwise.
      start = -math.pi / 2;
      sweep = 2 * math.pi * progress;
    }

    canvas.drawArc(rect, start, sweep, false, paint..color = fill);
  }

  @override
  bool shouldRepaint(_ProgressCirclePainter oldDelegate) {
    return oldDelegate.track != track ||
        oldDelegate.fill != fill ||
        oldDelegate.progress != progress ||
        oldDelegate.isIndeterminate != isIndeterminate ||
        oldDelegate.time != time;
  }
}
