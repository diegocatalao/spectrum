import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Channel of a color changed by a SpectrumColorSlider.
enum SpectrumColorChannel { hue, saturation, brightness, alpha }

/// Spectrum Color Slider: a 24px track with the gradient of one channel of a color,
/// like its hue or its opacity, with the color handle.
class SpectrumColorSlider extends StatefulWidget {
  /// Color at start. When the parent changes it, the slider follows.
  final Color value;

  /// Channel changed by the slider.
  final SpectrumColorChannel channel;

  /// Label above the track. Without it, the name of the channel is shown.
  final Text? label;

  /// Grays out the slider and ignores drags.
  final bool isDisabled;

  /// Width of the track, 192px by default.
  final double width;

  /// Called with the new color while the handle moves.
  final ValueChanged<Color>? onChange;

  /// Called with the final color when the handle is released.
  final ValueChanged<Color>? onChangeEnd;

  const SpectrumColorSlider({
    super.key,
    required this.value,
    required this.channel,
    this.label,
    this.isDisabled = false,
    this.width = 192,
    this.onChange,
    this.onChangeEnd,
  });

  @override
  State<SpectrumColorSlider> createState() => _SpectrumColorSliderState();
}

class _SpectrumColorSliderState extends State<SpectrumColorSlider> {
  HSVColor _hsv = const HSVColor.fromAHSV(1, 0, 1, 1);
  bool _isDragging = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumColorSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value && widget.value != _hsv.toColor()) {
      _hsv = HSVColor.fromColor(widget.value);
    }
  }

  /// Position of the handle on the track, from 0 to 1.
  double get _fraction {
    if (widget.channel == SpectrumColorChannel.hue) {
      return _hsv.hue / 360;
    } else if (widget.channel == SpectrumColorChannel.saturation) {
      return _hsv.saturation;
    } else if (widget.channel == SpectrumColorChannel.brightness) {
      return _hsv.value;
    } else {
      return _hsv.alpha;
    }
  }

  /// Sets the channel from a position on the track, from 0 to 1.
  void _set(double fraction) {
    final value = fraction.clamp(0.0, 1.0);
    final HSVColor next;

    if (widget.channel == SpectrumColorChannel.hue) {
      next = _hsv.withHue(value * 360 % 360);
    } else if (widget.channel == SpectrumColorChannel.saturation) {
      next = _hsv.withSaturation(value);
    } else if (widget.channel == SpectrumColorChannel.brightness) {
      next = _hsv.withValue(value);
    } else {
      next = _hsv.withAlpha(value);
    }

    setState(() => _hsv = next);
    widget.onChange?.call(next.toColor());
  }

  /// Colors of the gradient of the channel, keeping the others.
  List<Color> get _gradient {
    if (widget.channel == SpectrumColorChannel.hue) {
      return [for (var hue = 0; hue <= 360; hue += 60) HSVColor.fromAHSV(1, hue % 360, 1, 1).toColor()];
    } else if (widget.channel == SpectrumColorChannel.saturation) {
      return [_hsv.withSaturation(0).withAlpha(1).toColor(), _hsv.withSaturation(1).withAlpha(1).toColor()];
    } else if (widget.channel == SpectrumColorChannel.brightness) {
      return [_hsv.withValue(0).withAlpha(1).toColor(), _hsv.withValue(1).withAlpha(1).toColor()];
    } else {
      return [_hsv.withAlpha(0).toColor(), _hsv.withAlpha(1).toColor()];
    }
  }

  String get _channelName {
    return switch (widget.channel) {
      SpectrumColorChannel.hue => 'Hue',
      SpectrumColorChannel.saturation => 'Saturation',
      SpectrumColorChannel.brightness => 'Brightness',
      SpectrumColorChannel.alpha => 'Opacity',
    };
  }

  String get _valueText {
    if (widget.channel == SpectrumColorChannel.hue) {
      return '${_hsv.hue.round()}°';
    }

    return '${(_fraction * 100).round()}%';
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || widget.isDisabled) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final step = widget.channel == SpectrumColorChannel.hue ? 1 / 360 : 0.01;

    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.arrowUp) {
      _set(_fraction + step);
    } else if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.arrowDown) {
      _set(_fraction - step);
    } else {
      return KeyEventResult.ignored;
    }

    widget.onChangeEnd?.call(_hsv.toColor());
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: widget.isDisabled ? colors.outline : colors.onSurfaceVariant,
    );
    final isActive =
        _isDragging || (_isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional);

    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          // The label of the channel and its value, at the two ends.
          Row(
            children: [
              Expanded(
                child: DefaultTextStyle(style: style, child: widget.label ?? Text(_channelName)),
              ),
              Text(_valueText, style: style),
            ],
          ),
          Semantics(
            slider: true,
            label: widget.label?.data ?? _channelName,
            value: _valueText,
            child: Focus(
              canRequestFocus: !widget.isDisabled,
              onKeyEvent: _handleKey,
              onFocusChange: (value) => setState(() => _isFocused = value),
              child: GestureDetector(
                onTapDown: widget.isDisabled ? null : (details) => _set(details.localPosition.dx / widget.width),
                onTapUp: widget.isDisabled ? null : (details) => widget.onChangeEnd?.call(_hsv.toColor()),
                onHorizontalDragStart: widget.isDisabled
                    ? null
                    : (details) {
                        setState(() => _isDragging = true);
                        _set(details.localPosition.dx / widget.width);
                      },
                onHorizontalDragUpdate: widget.isDisabled
                    ? null
                    : (details) => _set(details.localPosition.dx / widget.width),
                onHorizontalDragEnd: widget.isDisabled
                    ? null
                    : (details) {
                        setState(() => _isDragging = false);
                        widget.onChangeEnd?.call(_hsv.toColor());
                      },
                // Spectrum 2 color track: 24px high with 4px corners, the checkerboard
                // behind transparent colors and a 1px outline of gray-1000 at 10%.
                child: SizedBox(
                  height: 24,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Visibility(
                            visible: !widget.isDisabled,
                            replacement: ColoredBox(color: colors.surfaceContainerHigh),
                            child: CustomPaint(
                              painter: SpectrumCheckerboardPainter(
                                isVisible: widget.channel == SpectrumColorChannel.alpha,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: _gradient),
                                  border: Border.all(color: SpectrumColors.black.withValues(alpha: 0.1)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: _fraction * widget.width,
                        top: 12,
                        child: FractionalTranslation(
                          translation: const Offset(-0.5, -0.5),
                          child: SpectrumColorHandle(
                            color: _hsv.toColor(),
                            isActive: isActive,
                            isDisabled: widget.isDisabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
