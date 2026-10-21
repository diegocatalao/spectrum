import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// How rounded the corners of a SpectrumColorSwatch are.
enum SpectrumColorSwatchRounding { none, small, full }

/// Spectrum Color Swatch: a square that previews a color, with a checkerboard
/// behind transparent colors and a red slash when there is no color.
class SpectrumColorSwatch extends StatelessWidget {
  /// Color previewed by the swatch. Fully transparent shows the red slash.
  final Color color;

  /// Name of the color read by screen readers, like "Red".
  final String? colorName;

  /// Corners of the swatch, 4px by default.
  final SpectrumColorSwatchRounding rounding;

  const SpectrumColorSwatch({
    super.key,
    required this.color,
    this.colorName,
    this.rounding = SpectrumColorSwatchRounding.small,
  });

  @override
  Widget build(BuildContext context) {
    // Inside a SpectrumColorSwatchPicker, the picker decides the rounding.
    final effective = SpectrumColorSwatchPicker.roundingOf(context) ?? rounding;
    final BorderRadius radius;

    if (effective == SpectrumColorSwatchRounding.full) {
      radius = BorderRadius.circular(999);
    } else if (effective == SpectrumColorSwatchRounding.none) {
      radius = BorderRadius.zero;
    } else {
      radius = BorderRadius.circular(4);
    }

    // Tells screen readers the name of the color, or its hexadecimal value.
    return Semantics(
      label: colorName ?? '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
      image: true,
      // Spectrum 2 color swatch: 32px in the M size, with a 1px border of gray-1000 at 42%.
      child: Container(
        width: 32,
        height: 32,
        foregroundDecoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: SpectrumColors.black.withValues(alpha: 0.42)),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: CustomPaint(painter: _SwatchPainter(color: color)),
        ),
      ),
    );
  }
}

/// Paints the color over a checkerboard, or a red slash when it is fully transparent.
class _SwatchPainter extends CustomPainter {
  final Color color;

  const _SwatchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (color.a == 0) {
      // When the color is fully transparent, there is no color: a 4px red slash
      // crosses the swatch from the top left to the bottom right.
      final slash = Paint()
        ..color = SpectrumColors.red900
        ..strokeWidth = 4;
      canvas.drawLine(Offset.zero, Offset(size.width, size.height), slash);
      return;
    }

    const SpectrumCheckerboardPainter().paint(canvas, size);
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SwatchPainter oldDelegate) => oldDelegate.color != color;
}
