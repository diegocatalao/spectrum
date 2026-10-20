import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Skeleton: while isLoading is True, the components below it draw
/// themselves as gray shapes with a moving shine, keeping the final layout.
class SpectrumSkeleton extends StatefulWidget {
  /// Whether the content below is still loading.
  final bool isLoading;

  /// Content shown as a skeleton while loading.
  final Widget child;

  const SpectrumSkeleton({super.key, required this.isLoading, required this.child});

  /// Returns True when the widget is inside a loading skeleton.
  static bool isLoadingOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SkeletonScope>()?.isLoading ?? false;
  }

  @override
  State<SpectrumSkeleton> createState() => _SpectrumSkeletonState();
}

/// Keeps the one animation shared by every bone, so all of them shine together.
class _SpectrumSkeletonState extends State<SpectrumSkeleton> with SingleTickerProviderStateMixin {
  /// Spectrum 2 loading animation: the shine crosses the bones every 2 seconds.
  /// It is created in initState, since it needs this State as its ticker.
  AnimationController? _controller;

  /// The shine movement, easing in and out as the Spectrum 2 animation.
  Animation<double> _animation = kAlwaysDismissedAnimation;

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller = controller;
    _animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant SpectrumSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLoading != widget.isLoading) {
      _updateAnimation();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Runs the shine only while loading, so a loaded skeleton costs nothing.
  void _updateAnimation() {
    if (widget.isLoading) {
      _controller?.repeat();
    } else {
      _controller?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SkeletonScope(isLoading: widget.isLoading, animation: _animation, child: widget.child);
  }
}

/// Spectrum Skeleton Bone: a piece of content that, inside a loading SpectrumSkeleton,
/// is hidden behind a gray shape of the same size. Used by the components, and by
/// apps to show their own content as a skeleton.
class SpectrumSkeletonBone extends StatelessWidget {
  /// Content whose size the gray shape takes.
  final Widget child;

  /// Corners of the gray shape, the small Spectrum 2 radius by default.
  final BorderRadiusGeometry borderRadius;

  const SpectrumSkeletonBone({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  Widget build(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SkeletonScope>();

    if (scope == null || !scope.isLoading) {
      // When the skeleton is not loading, the content is shown as it is.
      return child;
    }

    final colors = Theme.of(context).colorScheme;
    final Color shine;

    if (Theme.of(context).brightness == Brightness.dark) {
      // When the theme is dark, the shine is a lighter gray (gray-300).
      shine = SpectrumDarkColors.gray300;
    } else {
      // When the theme is light, the shine is almost white (gray-25).
      shine = colors.surface;
    }

    // Without animations (the reduce motion setting), the bone stays still.
    final isStill = MediaQuery.of(context).disableAnimations;

    // The content stays in the layout, invisible, so the bone has its exact size,
    // and it is not read by screen readers nor tapped while loading.
    return ExcludeSemantics(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: scope.animation,
          builder: (context, content) {
            final double progress;

            if (isStill) {
              progress = 0.5;
            } else {
              progress = scope.animation.value;
            }

            // Spectrum 2 loading gradient: gray-100 with a shine in the middle, three
            // times wider than the bone and sliding across it, as its background-position.
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment(4 * progress - 5, 0),
                  end: Alignment(4 * progress + 1, 0),
                  colors: [colors.surfaceContainerHigh, shine, colors.surfaceContainerHigh],
                  stops: const [0.33, 0.5, 0.66],
                ),
              ),
              child: content,
            );
          },
          child: Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Shares whether the skeleton is loading and its animation with the bones below it.
class _SkeletonScope extends InheritedWidget {
  final bool isLoading;
  final Animation<double> animation;

  const _SkeletonScope({required this.isLoading, required this.animation, required super.child});

  @override
  bool updateShouldNotify(_SkeletonScope oldWidget) => oldWidget.isLoading != isLoading;
}
