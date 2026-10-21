import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Drop Zone: an area with a dashed border where items dragged in the app,
/// like a Draggable of data T, can be dropped.
class SpectrumDropZone<T extends Object> extends StatefulWidget {
  /// Content of the area, usually a SpectrumIllustratedMessage.
  final Widget child;

  /// Called with the data of the dropped item.
  final ValueChanged<T>? onDrop;

  /// Decides if the dragged data can be dropped. Without it, every T is accepted.
  final bool Function(T data)? onWillAccept;

  /// Whether the area already holds something, so a drop replaces it.
  final bool isFilled;

  /// Banner shown while dragging over a filled area.
  final String replaceMessage;

  const SpectrumDropZone({
    super.key,
    required this.child,
    this.onDrop,
    this.onWillAccept,
    this.isFilled = false,
    this.replaceMessage = 'Drop file to replace',
  });

  @override
  State<SpectrumDropZone<T>> createState() => _SpectrumDropZoneState<T>();
}

class _SpectrumDropZoneState<T extends Object> extends State<SpectrumDropZone<T>> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DragTarget<T>(
      onWillAcceptWithDetails: (details) => widget.onWillAccept?.call(details.data) ?? true,
      onAcceptWithDetails: (details) => widget.onDrop?.call(details.data),
      builder: (context, candidates, rejected) {
        final isDropTarget = candidates.isNotEmpty;
        final Color border, background;

        if (isDropTarget) {
          // While an item is dragged over it, the area turns blue with a solid border.
          border = isDark ? SpectrumDarkColors.blue800 : SpectrumColors.blue800;
          background = isDark ? SpectrumDarkColors.blue200 : SpectrumColors.blue200;
        } else {
          // Otherwise it has a 2px dashed gray-300 border.
          border = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
          background = Colors.transparent;
        }

        // Spectrum 2 drop zone: 10px corners and 24px of padding.
        return Semantics(
          container: true,
          child: CustomPaint(
            foregroundPainter: _DashedBorderPainter(color: border, isDashed: !isDropTarget),
            child: AnimatedContainer(
              duration: SpectrumMotion.duration,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  DefaultTextStyle.merge(
                    style: TextStyle(color: colors.inverseSurface),
                    child: widget.child,
                  ),
                  // Over a filled area, a blue banner says that the drop replaces the content.
                  Visibility(
                    visible: isDropTarget && widget.isFilled,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 192),
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                      decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        widget.replaceMessage,
                        textAlign: TextAlign.center,
                        style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                          color: SpectrumColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Paints the 2px border of the drop zone, dashed or solid, with 10px corners.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final bool isDashed;

  const _DashedBorderPainter({required this.color, required this.isDashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()..addRRect(RRect.fromRectAndRadius((Offset.zero & size).deflate(1), const Radius.circular(10)));

    if (!isDashed) {
      canvas.drawPath(path, paint);
      return;
    }

    // Dashes of 6px with gaps of 4px along the whole border.
    for (final metric in path.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 10) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isDashed != isDashed;
  }
}
