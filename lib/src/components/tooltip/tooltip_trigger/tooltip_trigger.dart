import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Where a SpectrumTooltip is placed around its trigger.
enum SpectrumTooltipPlacement { top, bottom }

/// Spectrum Tooltip Trigger: shows a SpectrumTooltip next to its child after
/// a delay on hover, or at once on keyboard focus and long press.
class SpectrumTooltipTrigger extends StatelessWidget {
  /// Widget that shows the tooltip, usually a SpectrumActionButton.
  final Widget child;

  /// Tooltip shown next to the child.
  final SpectrumTooltip tooltip;

  /// Side of the child where the tooltip is shown. It flips when there is no space.
  final SpectrumTooltipPlacement placement;

  /// Time the pointer rests on the child before the tooltip opens.
  final Duration delay;

  /// Never shows the tooltip.
  final bool isDisabled;

  const SpectrumTooltipTrigger({
    super.key,
    required this.child,
    required this.tooltip,
    this.placement = SpectrumTooltipPlacement.top,
    this.delay = const Duration(milliseconds: 1500),
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isBelow = placement == SpectrumTooltipPlacement.bottom;

    // When isDisabled is True, the child is shown without a tooltip.
    if (isDisabled) {
      return child;
    }

    return Tooltip(
      richMessage: WidgetSpan(child: tooltip),
      preferBelow: isBelow,
      waitDuration: delay,
      // Spectrum 2 closes the tooltip half a second after the pointer leaves.
      exitDuration: const Duration(milliseconds: 500),
      // 4px from the child plus the 5px arrow, as in Spectrum 2.
      verticalOffset: 9,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Spectrum 2 tooltip: neutral (gray-800) background with 8px corners and
      // a 10x5px arrow pointing to the child.
      decoration: ShapeDecoration(
        color: colors.onSurface,
        shape: _TooltipBorder(isArrowOnTop: isBelow),
      ),
      child: child,
    );
  }
}

/// Rounded rectangle with the 10x5px arrow of the Spectrum 2 tooltip,
/// drawn outside of it, on the side of the trigger.
class _TooltipBorder extends ShapeBorder {
  /// Whether the arrow points up, for a tooltip below its trigger.
  final bool isArrowOnTop;

  const _TooltipBorder({required this.isArrowOnTop});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)));
    final center = rect.center.dx;

    if (isArrowOnTop) {
      // When the tooltip is below its trigger, the arrow points up from its top edge.
      path
        ..moveTo(center - 5, rect.top)
        ..lineTo(center, rect.top - 5)
        ..lineTo(center + 5, rect.top)
        ..close();
    } else {
      // Otherwise the arrow points down from its bottom edge.
      path
        ..moveTo(center - 5, rect.bottom)
        ..lineTo(center, rect.bottom + 5)
        ..lineTo(center + 5, rect.bottom)
        ..close();
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
