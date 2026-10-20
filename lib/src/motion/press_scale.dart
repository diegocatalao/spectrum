import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:spectrum/src/foundations/motion.dart';

/// Spectrum 2 "press scale": pushes the child 2px away from the viewer while it is
/// pressed, as `pressScale` of React Spectrum, so it shrinks a little and grows back
/// when released. Used by buttons, action buttons and menu items.
class SpectrumPressScale extends StatelessWidget {
  /// Whether the child is being pressed.
  final bool isPressed;

  /// The pressable widget.
  final Widget child;

  const SpectrumPressScale({super.key, required this.isPressed, required this.child});

  /// Duration of the press and release, the fast transition of Spectrum 2.
  static const duration = SpectrumMotion.duration;

  @override
  Widget build(BuildContext context) {
    // The progress goes from 0 (released) to 1 (pressed), and the render box
    // turns it into the real scale, which depends on the size of the child.
    return TweenAnimationBuilder<double>(
      tween: Tween(end: isPressed ? 1 : 0),
      duration: duration,
      curve: SpectrumMotion.curve,
      builder: (context, progress, child) => _PressScale(progress: progress, child: child),
      child: child,
    );
  }
}

/// Applies the press scale of the given progress to its child.
class _PressScale extends SingleChildRenderObjectWidget {
  final double progress;

  const _PressScale({required this.progress, super.child});

  @override
  _RenderPressScale createRenderObject(BuildContext context) => _RenderPressScale(progress);

  @override
  void updateRenderObject(BuildContext context, _RenderPressScale renderObject) {
    renderObject.progress = progress;
  }
}

class _RenderPressScale extends RenderProxyBox {
  _RenderPressScale(this._progress);

  double _progress;

  set progress(double value) {
    if (value != _progress) {
      _progress = value;
      markNeedsPaint();
    }
  }

  /// The same math as the CSS of React Spectrum: a perspective of
  /// max(height, width / 3, 24) and a translation of -2px on the z axis, which
  /// scales the child by perspective / (perspective + 2). Larger widgets, like
  /// a wide menu item, shrink less than a small button, as on the web.
  Matrix4 get _transform {
    final perspective = math.max(math.max(size.height, size.width / 3), 24);
    final pressed = perspective / (perspective + 2);
    final scale = 1 - (1 - pressed) * _progress;
    final center = size.center(Offset.zero);

    return Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }

    if (_progress == 0) {
      // When released, the child is painted as it is, without a transform layer.
      context.paintChild(child!, offset);
    } else {
      // While pressed, the child is painted with the scale around its center.
      layer = context.pushTransform(needsCompositing, offset, _transform, (context, offset) {
        context.paintChild(child!, offset);
      }, oldLayer: layer is TransformLayer ? layer as TransformLayer : null);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (result, position) => super.hitTestChildren(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_transform);
  }
}
