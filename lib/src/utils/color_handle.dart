import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Handle of the Spectrum 2 color controls, like SpectrumColorArea and
/// SpectrumColorWheel: a circle filled with the current color, with a white border.
class SpectrumColorHandle extends StatelessWidget {
  /// Color shown inside the handle.
  final Color color;

  /// Grows the handle while it is dragged or focused by the keyboard.
  final bool isActive;

  /// Grays out the handle.
  final bool isDisabled;

  const SpectrumColorHandle({super.key, required this.color, this.isActive = false, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Spectrum 2 handle: 16px, or 32px while dragged or focused.
    final size = isActive ? 32.0 : 16.0;
    final Color fill, border;

    if (isDisabled) {
      // When isDisabled is True, the handle is gray, without the color.
      fill = colors.surfaceContainerHigh;
      border = colors.surfaceContainerHigh;
    } else {
      // Otherwise the handle shows the color over a checkerboard, so transparent
      // colors can be seen, with a white border.
      fill = color;
      border = SpectrumColors.white;
    }

    return AnimatedContainer(
      duration: SpectrumMotion.duration,
      curve: SpectrumMotion.curve,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // 1px outline of black at 42%, outside the 2px white border.
        boxShadow: [BoxShadow(color: SpectrumColors.black.withValues(alpha: 0.42), spreadRadius: 1)],
      ),
      child: ClipOval(
        child: CustomPaint(
          painter: SpectrumCheckerboardPainter(isVisible: !isDisabled && color.a < 1),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fill,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the gray and white checkerboard drawn behind transparent colors,
/// in squares of 8px, as the Spectrum 2 color components.
class SpectrumCheckerboardPainter extends CustomPainter {
  /// Whether the checkerboard is painted, usually only for transparent colors.
  final bool isVisible;

  const SpectrumCheckerboardPainter({this.isVisible = true});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isVisible) {
      return;
    }

    final light = Paint()..color = SpectrumColors.white;
    final dark = Paint()..color = const Color(0xFFE6E6E6);
    canvas.drawRect(Offset.zero & size, light);

    for (var y = 0.0; y < size.height; y += 8) {
      for (var x = 0.0; x < size.width; x += 8) {
        if (((x / 8).floor() + (y / 8).floor()).isEven) {
          canvas.drawRect(Rect.fromLTWH(x, y, 8, 8), dark);
        }
      }
    }
  }

  @override
  bool shouldRepaint(SpectrumCheckerboardPainter oldDelegate) => oldDelegate.isVisible != isVisible;
}
