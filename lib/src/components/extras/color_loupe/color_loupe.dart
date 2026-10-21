import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Color Loupe: a drop shaped magnifier that shows a color above the
/// handle of a color control while it is dragged, so the finger does not hide it.
class SpectrumColorLoupe extends StatelessWidget {
  /// Color shown in the loupe.
  final Color color;

  /// Whether the loupe is shown, usually while the handle is dragged.
  final bool isOpen;

  const SpectrumColorLoupe({super.key, required this.color, this.isOpen = true});

  @override
  Widget build(BuildContext context) {
    // Spectrum loupe: a 48x64px drop with a 1px outline and a white 2px border,
    // the color over the checkerboard, scaling in from its tip.
    return ExcludeSemantics(
      child: AnimatedScale(
        scale: isOpen ? 1 : 0,
        alignment: Alignment.bottomCenter,
        duration: SpectrumMotion.duration,
        curve: SpectrumMotion.curve,
        child: SizedBox(
          width: 48,
          height: 64,
          child: CustomPaint(painter: _LoupePainter(color: color)),
        ),
      ),
    );
  }
}

class _LoupePainter extends CustomPainter {
  final Color color;

  const _LoupePainter({required this.color});

  Path _drop(Size size) {
    final radius = size.width / 2;
    return Path()
      ..moveTo(size.width / 2, size.height)
      ..cubicTo(size.width / 2, size.height, 0, radius * 1.8, 0, radius)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..cubicTo(size.width, radius * 1.8, size.width / 2, size.height, size.width / 2, size.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final drop = _drop(size);
    canvas.drawShadow(drop, SpectrumColors.black, 4, false);
    canvas.save();
    canvas.clipPath(drop);
    const SpectrumCheckerboardPainter().paint(canvas, size);
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
    canvas.restore();
    canvas.drawPath(
      drop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = SpectrumColors.white,
    );
    canvas.drawPath(
      drop,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = SpectrumColors.black.withValues(alpha: 0.42),
    );
  }

  @override
  bool shouldRepaint(_LoupePainter oldDelegate) => oldDelegate.color != color;
}
