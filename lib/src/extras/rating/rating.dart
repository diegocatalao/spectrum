import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Rating: five stars to give or show a score, like the review of a product.
class SpectrumRating extends StatefulWidget {
  /// Score at start, from 0 to max. When the parent changes it, the rating follows.
  final int value;

  /// Number of stars, 5 by default.
  final int max;

  /// Fills the stars with the accent blue instead of the neutral gray.
  final bool isEmphasized;

  /// Shows the score but ignores taps.
  final bool isReadOnly;

  /// Grays out the stars and ignores taps.
  final bool isDisabled;

  /// Called with the new score when a star is tapped. Tapping the current score clears it.
  final ValueChanged<int>? onChange;

  const SpectrumRating({
    super.key,
    this.value = 0,
    this.max = 5,
    this.isEmphasized = false,
    this.isReadOnly = false,
    this.isDisabled = false,
    this.onChange,
  });

  @override
  State<SpectrumRating> createState() => _SpectrumRatingState();
}

class _SpectrumRatingState extends State<SpectrumRating> {
  int _value = 0;

  /// Star under the pointer, previewing the score.
  int? _hovered;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumRating oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _select(int value) {
    final next = value == _value ? 0 : value;
    setState(() => _value = next);
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isInteractive = !widget.isReadOnly && !widget.isDisabled;
    final shown = _hovered ?? _value;
    final Color filled;

    if (widget.isDisabled) {
      filled = colors.outline;
    } else if (widget.isEmphasized) {
      filled = colors.primary;
    } else {
      filled = colors.onSurface;
    }

    // Tells screen readers the score out of the stars.
    return Semantics(
      slider: isInteractive,
      label: 'Rating',
      value: '$_value of ${widget.max}',
      child: MouseRegion(
        onExit: (_) => setState(() => _hovered = null),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var star = 1; star <= widget.max; star++)
              GestureDetector(
                onTap: isInteractive ? () => _select(star) : null,
                child: MouseRegion(
                  cursor: isInteractive ? SystemMouseCursors.click : MouseCursor.defer,
                  onEnter: isInteractive ? (_) => setState(() => _hovered = star) : null,
                  // Spectrum rating star: 18px in a 24px area, filled up to the score.
                  child: SizedBox.square(
                    dimension: 24,
                    child: Center(
                      child: SpectrumIcon(
                        star <= shown ? SpectrumIcons.star : SpectrumIcons.starOutline,
                        size: 18,
                        color: star <= shown ? filled : colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
