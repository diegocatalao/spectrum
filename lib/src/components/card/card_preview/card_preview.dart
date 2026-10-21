import 'package:flutter/material.dart';

/// Spectrum Card Preview: the picture at the top of a SpectrumCard, from edge to
/// edge, in the 3:2 proportion of Spectrum 2.
class SpectrumCardPreview extends StatelessWidget {
  /// Picture of the card, usually a SpectrumImage, covering the whole preview.
  final Widget child;

  /// Proportion of the preview, 3:2 by default.
  final double aspectRatio;

  const SpectrumCardPreview({super.key, required this.child, this.aspectRatio = 3 / 2});

  @override
  Widget build(BuildContext context) {
    // The picture fills the preview and is cut by the corners of the card.
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRect(
        child: SizedBox.expand(
          child: FittedBox(fit: BoxFit.cover, child: child),
        ),
      ),
    );
  }
}
