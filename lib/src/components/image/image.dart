import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Image: an image downloaded from an address, over a gray placeholder
/// that is seen while it loads, and replaced by an error message when it fails.
/// Inside a SpectrumImageCoordinator, it is revealed together with the other images.
class SpectrumImage extends StatefulWidget {
  /// Address of the image.
  final Uri uri;

  /// Text read by screen readers. Without it, the image is treated as
  /// decorative and screen readers skip it.
  final String? semanticLabel;

  /// Fixed width of the image. Without it, the image takes its own width once loaded.
  final double? width;

  /// Fixed height of the image. Without it, the image takes its own height once loaded.
  final double? height;

  /// How the image fills its box when its proportion differs from it.
  final BoxFit fit;

  /// Corners of the image and its placeholder, square by default as in Spectrum 2.
  final BorderRadiusGeometry borderRadius;

  const SpectrumImage({
    super.key,
    required this.uri,
    this.semanticLabel,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<SpectrumImage> createState() => _SpectrumImageState();
}

/// Tells the coordinator above, if any, when the image starts and finishes loading.
class _SpectrumImageState extends State<SpectrumImage> {
  /// Coordinator above the image, or null when the image is on its own.
  SpectrumImageCoordinatorState? _coordinator;

  /// Whether the first frame of the image has arrived.
  bool _isLoaded = false;

  /// Whether the image failed to load.
  bool _isFailed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coordinator = SpectrumImageCoordinator.maybeOf(context);

    // When the image moves to another coordinator, it leaves the old one
    // and starts loading in the new one.
    if (coordinator != _coordinator) {
      _coordinator?.unregister(widget.uri);
      _coordinator = coordinator;
      _register();
    }
  }

  @override
  void didUpdateWidget(covariant SpectrumImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the address changes, the old image leaves the coordinator
    // and the new one starts loading.
    if (oldWidget.uri != widget.uri) {
      _coordinator?.unregister(oldWidget.uri);
      _register();
    }
  }

  @override
  void dispose() {
    _coordinator?.unregister(widget.uri);
    super.dispose();
  }

  /// Starts a new load of the image in the coordinator.
  void _register() {
    _isLoaded = false;
    _isFailed = false;
    _coordinator?.register(widget.uri);
  }

  /// Shown in place of the image when it fails to load. A failed image leaves the
  /// coordinator, so the other images do not wait for it.
  Widget _replacement(BuildContext context, Object error, StackTrace? stackTrace) {
    if (!_isFailed) {
      _isFailed = true;
      _coordinator?.unregister(widget.uri);
    }

    return const Center(
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SpectrumIcon(SpectrumIcons.alertCircle, size: 120), Text("Error loading image")],
      ),
    );
  }

  /// Keeps the image hidden until its first frame arrives and the coordinator reveals
  /// it, and then fades it in. When it is already in the cache, it is shown at once.
  Widget _reveal(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    final isRevealed = SpectrumImageCoordinator.isRevealedOf(this.context);

    if (frame != null && !_isLoaded) {
      _isLoaded = true;
      _coordinator?.load(widget.uri);
    }

    if (wasSynchronouslyLoaded && isRevealed) {
      return child;
    } else {
      return AnimatedOpacity(
        opacity: frame != null && isRevealed ? 1 : 0,
        duration: SpectrumMotion.duration1000,
        curve: SpectrumMotion.curve,
        child: child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // The ClipRRect is outside the Container, so the corners round the gray
    // placeholder and the image together.
    return ClipRRect(
      borderRadius: widget.borderRadius,
      // Spectrum 2 image placeholder: a gray-100 background, seen while the image
      // loads, behind transparent images and behind the error message.
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Image(
          image: NetworkImage(widget.uri.toString()),
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          semanticLabel: widget.semanticLabel,
          excludeFromSemantics: widget.semanticLabel == null || widget.semanticLabel!.isEmpty,
          frameBuilder: _reveal,
          errorBuilder: _replacement,
        ),
      ),
    );
  }
}
