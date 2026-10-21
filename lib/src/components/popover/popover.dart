import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Where a SpectrumPopover is placed around its trigger: the side first, then how it
/// is aligned with the trigger. Start and end follow the text direction, so
/// bottomStart aligns the popover with the left edge of the trigger in left to right.
enum SpectrumPopoverPlacement {
  top,
  topStart,
  topEnd,
  bottom,
  bottomStart,
  bottomEnd,
  left,
  leftTop,
  leftBottom,
  right,
  rightTop,
  rightBottom,
}

/// Side of the trigger where the popover is, which is also the edge of the arrow.
enum _PopoverSide { top, bottom, left, right }

/// Spectrum Popover: a floating panel opened by its trigger, with any content,
/// that closes on a tap outside of it or on the Escape key.
class SpectrumPopover extends StatefulWidget {
  /// Builds the widget that opens the popover, receiving the function that
  /// opens or closes it, usually for the onTap of a button.
  final Widget Function(BuildContext context, VoidCallback onToggle) trigger;

  /// Content of the popover.
  final Widget child;

  /// Side of the trigger where the popover is shown.
  final SpectrumPopoverPlacement placement;

  /// Hides the arrow pointing to the trigger.
  final bool hideArrow;

  /// Space between the edges of the popover and its content.
  final EdgeInsetsGeometry padding;

  /// Called when the popover opens or closes.
  final ValueChanged<bool>? onOpenChange;

  const SpectrumPopover({
    super.key,
    required this.trigger,
    required this.child,
    this.placement = SpectrumPopoverPlacement.bottom,
    this.hideArrow = false,
    this.padding = const EdgeInsets.all(8),
    this.onOpenChange,
  });

  /// Returns the function that closes the popover around the widget, so its content
  /// can close it, like a calendar after a date is picked.
  static VoidCallback? closeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PopoverCloseScope>()?.onClose;
  }

  @override
  State<SpectrumPopover> createState() => _SpectrumPopoverState();
}

/// Keeps whether the popover is open and its position next to the trigger.
class _SpectrumPopoverState extends State<SpectrumPopover> {
  /// Shows and hides the popover in the overlay of the app.
  final OverlayPortalController _controller = OverlayPortalController();

  /// Links the popover to the position of the trigger.
  final LayerLink _link = LayerLink();

  /// Opens the popover when closed and closes it when open.
  void _handleToggle() {
    if (_controller.isShowing) {
      _close();
    } else {
      _controller.show();
      widget.onOpenChange?.call(true);
    }
  }

  void _close() {
    if (_controller.isShowing) {
      _controller.hide();
      widget.onOpenChange?.call(false);
    }
  }

  /// Anchors of the trigger and of the popover, the gap between them, the side of
  /// the popover and the direction it moves from while it fades in.
  ({Alignment target, Alignment follower, Offset offset, Offset enter, _PopoverSide side}) _anchorsOf(
    BuildContext context,
  ) {
    // Spectrum 2 offset: 8px from the trigger, plus the 8px arrow when it is shown.
    final gap = widget.hideArrow ? 8.0 : 16.0;
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    // Start and end become left and right according to the text direction.
    final start = isLtr ? -1.0 : 1.0;
    final end = -start;
    final placement = widget.placement;

    if (placement == SpectrumPopoverPlacement.top ||
        placement == SpectrumPopoverPlacement.topStart ||
        placement == SpectrumPopoverPlacement.topEnd) {
      // When the placement is on top, the popover stands above the trigger,
      // centered or aligned with its start or end edge.
      final double x;

      if (placement == SpectrumPopoverPlacement.topStart) {
        x = start;
      } else if (placement == SpectrumPopoverPlacement.topEnd) {
        x = end;
      } else {
        x = 0;
      }

      return (
        target: Alignment(x, -1),
        follower: Alignment(x, 1),
        offset: Offset(0, -gap),
        enter: const Offset(0, 4),
        side: _PopoverSide.top,
      );
    } else if (placement == SpectrumPopoverPlacement.left ||
        placement == SpectrumPopoverPlacement.leftTop ||
        placement == SpectrumPopoverPlacement.leftBottom) {
      // When the placement is on the left, the popover stands on the left of the
      // trigger, centered or aligned with its top or bottom edge.
      final double y;

      if (placement == SpectrumPopoverPlacement.leftTop) {
        y = -1;
      } else if (placement == SpectrumPopoverPlacement.leftBottom) {
        y = 1;
      } else {
        y = 0;
      }

      return (
        target: Alignment(-1, y),
        follower: Alignment(1, y),
        offset: Offset(-gap, 0),
        enter: const Offset(4, 0),
        side: _PopoverSide.left,
      );
    } else if (placement == SpectrumPopoverPlacement.right ||
        placement == SpectrumPopoverPlacement.rightTop ||
        placement == SpectrumPopoverPlacement.rightBottom) {
      // When the placement is on the right, the popover stands on the right of the
      // trigger, centered or aligned with its top or bottom edge.
      final double y;

      if (placement == SpectrumPopoverPlacement.rightTop) {
        y = -1;
      } else if (placement == SpectrumPopoverPlacement.rightBottom) {
        y = 1;
      } else {
        y = 0;
      }

      return (
        target: Alignment(1, y),
        follower: Alignment(-1, y),
        offset: Offset(gap, 0),
        enter: const Offset(-4, 0),
        side: _PopoverSide.right,
      );
    } else {
      // Otherwise the popover stands below the trigger, centered or aligned
      // with its start or end edge.
      final double x;

      if (placement == SpectrumPopoverPlacement.bottomStart) {
        x = start;
      } else if (placement == SpectrumPopoverPlacement.bottomEnd) {
        x = end;
      } else {
        x = 0;
      }

      return (
        target: Alignment(x, 1),
        follower: Alignment(x, -1),
        offset: Offset(0, gap),
        enter: const Offset(0, -4),
        side: _PopoverSide.bottom,
      );
    }
  }

  Widget _buildPopover(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final anchors = _anchorsOf(context);
    // The size of the trigger, so the arrow points to its center even when the
    // popover is aligned with one of its edges.
    final trigger = _link.leaderSize ?? Size.zero;
    final Color background;

    if (isDark) {
      // When the theme is dark, the popover is the elevated layer (gray-75).
      background = colors.surfaceContainer;
    } else {
      // When the theme is light, the popover is the elevated layer (gray-25).
      background = colors.surface;
    }

    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        targetAnchor: anchors.target,
        followerAnchor: anchors.follower,
        offset: anchors.offset,
        // The trigger and the popover share the tap region, so a tap on the trigger
        // toggles the popover instead of closing and opening it again.
        child: TapRegion(
          groupId: this,
          onTapOutside: (event) => _close(),
          // The Escape key closes the popover, as in Spectrum 2.
          child: CallbackShortcuts(
            bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
            child: Focus(
              autofocus: true,
              // Spectrum 2 popover entrance: it fades in while moving 4px towards
              // its place, in 200ms.
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 200),
                curve: SpectrumMotion.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(offset: anchors.enter * (1 - value), child: child),
                  );
                },
                // Spectrum 2 popover: elevated background with 10px corners, a 1px
                // outline in the dark theme, the elevated shadow and the arrow.
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: widget.padding,
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 24),
                    decoration: ShapeDecoration(
                      color: background,
                      shadows: [BoxShadow(color: colors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
                      shape: _PopoverBorder(
                        popoverSide: anchors.side,
                        alignment: anchors.follower,
                        trigger: trigger,
                        hideArrow: widget.hideArrow,
                        side: isDark ? BorderSide(color: colors.outlineVariant) : BorderSide.none,
                      ),
                    ),
                    child: _PopoverCloseScope(onClose: _close, child: widget.child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: _buildPopover,
        child: TapRegion(groupId: this, child: widget.trigger(context, _handleToggle)),
      ),
    );
  }
}

/// Rounded rectangle with the 18x9px arrow of the Spectrum 2 popover, drawn
/// outside of it, on the side of the trigger and pointing to its center.
class _PopoverBorder extends ShapeBorder {
  /// Side of the trigger where the popover is.
  final _PopoverSide popoverSide;

  /// Anchor of the popover aligned with the trigger, to find the center of the trigger.
  final Alignment alignment;

  /// Size of the trigger.
  final Size trigger;

  final bool hideArrow;
  final BorderSide side;

  const _PopoverBorder({
    required this.popoverSide,
    required this.alignment,
    required this.trigger,
    required this.hideArrow,
    required this.side,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  /// Position of the center of the trigger along the edge of the popover, from
  /// rect.left (or rect.top), kept away from the rounded corners.
  double _arrowAt(double start, double length, double anchor, double triggerLength) {
    final double at;

    if (anchor < 0) {
      // Aligned with the start edge of the trigger: its center is half of it away.
      at = start + triggerLength / 2;
    } else if (anchor > 0) {
      // Aligned with the end edge of the trigger: its center is half of it before the end.
      at = start + length - triggerLength / 2;
    } else {
      // Centered with the trigger: both centers are the same.
      at = start + length / 2;
    }

    return at.clamp(start + 19, start + length - 19);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)));

    if (hideArrow) {
      return body;
    }

    final arrow = Path();

    // The arrow points from the edge of the popover towards the trigger.
    if (popoverSide == _PopoverSide.top) {
      final x = _arrowAt(rect.left, rect.width, alignment.x, trigger.width);
      arrow
        ..moveTo(x - 9, rect.bottom)
        ..lineTo(x, rect.bottom + 9)
        ..lineTo(x + 9, rect.bottom);
    } else if (popoverSide == _PopoverSide.left) {
      final y = _arrowAt(rect.top, rect.height, alignment.y, trigger.height);
      arrow
        ..moveTo(rect.right, y - 9)
        ..lineTo(rect.right + 9, y)
        ..lineTo(rect.right, y + 9);
    } else if (popoverSide == _PopoverSide.right) {
      final y = _arrowAt(rect.top, rect.height, alignment.y, trigger.height);
      arrow
        ..moveTo(rect.left, y - 9)
        ..lineTo(rect.left - 9, y)
        ..lineTo(rect.left, y + 9);
    } else {
      final x = _arrowAt(rect.left, rect.width, alignment.x, trigger.width);
      arrow
        ..moveTo(x - 9, rect.top)
        ..lineTo(x, rect.top - 9)
        ..lineTo(x + 9, rect.top);
    }

    return Path.combine(PathOperation.union, body, arrow..close());
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) {
      return;
    }

    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), side.toPaint());
  }

  @override
  ShapeBorder scale(double t) => this;
}

/// Shares the close function of the popover with its content.
class _PopoverCloseScope extends InheritedWidget {
  final VoidCallback onClose;

  const _PopoverCloseScope({required this.onClose, required super.child});

  @override
  bool updateShouldNotify(_PopoverCloseScope oldWidget) => false;
}
