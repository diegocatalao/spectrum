import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Progress Bar: a horizontal bar that shows the progress of an
/// operation, like a download, or that an operation is running.
class SpectrumProgressBar extends StatefulWidget {
  /// Label shown above the bar, or on its left when labelPosition is side.
  final Text? label;

  /// Current value, between minValue and maxValue.
  final double value;

  /// Value of an empty bar.
  final double minValue;

  /// Value of a full bar.
  final double maxValue;

  /// Text shown on the right of the label instead of the percentage, like "3 of 10".
  final Text? valueLabel;

  /// Shows a bar moving across the track, for operations with an unknown duration.
  final bool isIndeterminate;

  /// Where the label is placed.
  final SpectrumLabelPosition labelPosition;

  /// Fixed white or black colors for bars over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  /// Width of the bar, 208px by default as the Spectrum 2 fields.
  final double width;

  const SpectrumProgressBar({
    super.key,
    this.label,
    this.value = 0,
    this.minValue = 0,
    this.maxValue = 100,
    this.valueLabel,
    this.isIndeterminate = false,
    this.labelPosition = SpectrumLabelPosition.top,
    this.staticColor,
    this.width = 208,
  });

  @override
  State<SpectrumProgressBar> createState() => _SpectrumProgressBarState();
}

/// Keeps the animation of the indeterminate bar.
class _SpectrumProgressBarState extends State<SpectrumProgressBar> with SingleTickerProviderStateMixin {
  /// Spectrum 2 indeterminate animation: the fill crosses the track every second.
  /// It is created in initState, since it needs this State as its ticker.
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant SpectrumProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isIndeterminate != widget.isIndeterminate) {
      _updateAnimation();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Runs the animation only while the bar is indeterminate.
  void _updateAnimation() {
    if (widget.isIndeterminate) {
      _controller?.repeat();
    } else {
      _controller?.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final range = widget.maxValue - widget.minValue;
    final progress = range <= 0 ? 0.0 : ((widget.value - widget.minValue) / range).clamp(0.0, 1.0);
    final Color track, fill, content;

    if (widget.staticColor == SpectrumStaticColor.black) {
      // When staticColor is black, the bar uses translucent black over light images.
      track = SpectrumColors.black.withValues(alpha: 0.3);
      fill = SpectrumColors.black.withValues(alpha: 0.9);
      content = SpectrumColors.black;
    } else if (widget.staticColor == SpectrumStaticColor.white) {
      // When staticColor is white, the bar uses translucent white over dark images.
      track = SpectrumColors.white.withValues(alpha: 0.3);
      fill = SpectrumColors.white.withValues(alpha: 0.9);
      content = SpectrumColors.white;
    } else {
      // Otherwise the track is gray-300, the fill is the accent blue and the
      // texts are gray-700, as the Spectrum 2 field labels.
      track = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
      fill = colors.primary;
      content = colors.onSurfaceVariant;
    }

    final Widget? valueText;

    if (widget.isIndeterminate) {
      // When isIndeterminate is True, there is no value to show.
      valueText = null;
    } else {
      // Otherwise the value label, or the percentage, is shown with the label.
      valueText = widget.valueLabel ?? Text('${(progress * 100).round()}%');
    }

    // Spectrum 2 progress bar track: 6px high and fully rounded, clipping the fill.
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 6,
        color: track,
        child: Visibility(
          visible: widget.isIndeterminate,
          // The determinate fill grows from the start with the default transition.
          replacement: Align(
            alignment: AlignmentDirectional.centerStart,
            child: AnimatedFractionallySizedBox(
              duration: SpectrumMotion.duration,
              curve: SpectrumMotion.curve,
              widthFactor: progress,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(999)),
              ),
            ),
          ),
          // The indeterminate fill is 70% of the track, sliding from -70% to 100%.
          child: AnimatedBuilder(
            animation: _controller ?? kAlwaysDismissedAnimation,
            builder: (context, child) {
              final value = Curves.easeInOut.transform(_controller?.value ?? 0);

              return FractionalTranslation(
                translation: Offset(-0.7 + 1.7 * value, 0),
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: 0.7,
                  heightFactor: 1,
                  child: child,
                ),
              );
            },
            child: DecoratedBox(
              decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(999)),
            ),
          ),
        ),
      ),
    );

    final Widget layout;

    if (widget.labelPosition == SpectrumLabelPosition.side) {
      // When labelPosition is side, the label, the bar and the value share one
      // line, 12px apart.
      layout = Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          ?widget.label,
          SizedBox(width: widget.width, child: bar),
          ?valueText,
        ],
      );
    } else {
      // Otherwise the label and the value are above the bar, at its two ends.
      layout = SizedBox(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(child: widget.label ?? const SizedBox.shrink()),
                ?valueText,
              ],
            ),
            bar,
          ],
        ),
      );
    }

    // Tells screen readers that this is a progress indicator, with its value.
    return Semantics(
      label: widget.label?.data,
      value: widget.isIndeterminate ? null : '${(progress * 100).round()}%',
      child: DefaultTextStyle(
        style: style.copyWith(color: content),
        child: layout,
      ),
    );
  }
}
