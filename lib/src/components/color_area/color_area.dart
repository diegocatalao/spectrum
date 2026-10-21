import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Color Area: a square to pick the saturation (horizontal) and the
/// brightness (vertical) of a color, keeping its hue.
class SpectrumColorArea extends StatefulWidget {
  /// Color selected at start. When the parent changes it, the area follows.
  final Color value;

  /// Called with the new color while the handle moves.
  final ValueChanged<Color>? onChange;

  /// Called with the final color when the handle is released.
  final ValueChanged<Color>? onChangeEnd;

  /// Grays out the area and ignores drags.
  final bool isDisabled;

  const SpectrumColorArea({super.key, required this.value, this.onChange, this.onChangeEnd, this.isDisabled = false});

  @override
  State<SpectrumColorArea> createState() => _SpectrumColorAreaState();
}

/// Keeps the color being picked and the drag and focus states.
class _SpectrumColorAreaState extends State<SpectrumColorArea> {
  /// Size of the area, 192px as in Spectrum 2.
  static const _size = 192.0;

  HSVColor _hsv = const HSVColor.fromAHSV(1, 0, 0, 0);
  bool _isDragging = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumColorArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the area follows it.
    if (oldWidget.value != widget.value && widget.value != _hsv.toColor()) {
      _hsv = HSVColor.fromColor(widget.value);
    }
  }

  /// Moves the handle to the position, from the top left of the area.
  void _update(Offset position) {
    final saturation = (position.dx / _size).clamp(0.0, 1.0);
    final brightness = 1 - (position.dy / _size).clamp(0.0, 1.0);

    setState(() => _hsv = _hsv.withSaturation(saturation).withValue(brightness));
    widget.onChange?.call(_hsv.toColor());
  }

  /// Moves the handle by 1% with the arrow keys, as Spectrum 2.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || widget.isDisabled) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    var saturation = _hsv.saturation;
    var brightness = _hsv.value;

    if (key == LogicalKeyboardKey.arrowLeft) {
      saturation -= 0.01;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      saturation += 0.01;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      brightness += 0.01;
    } else if (key == LogicalKeyboardKey.arrowDown) {
      brightness -= 0.01;
    } else {
      return KeyEventResult.ignored;
    }

    setState(() => _hsv = _hsv.withSaturation(saturation.clamp(0, 1)).withValue(brightness.clamp(0, 1)));
    widget.onChange?.call(_hsv.toColor());
    widget.onChangeEnd?.call(_hsv.toColor());
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hue = HSVColor.fromAHSV(1, _hsv.hue, 1, 1).toColor();
    // The handle is centered on the point of the color.
    final handle = Offset(_hsv.saturation * _size, (1 - _hsv.value) * _size);
    final isActive =
        _isDragging || (_isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional);

    // Tells screen readers the saturation and the brightness of the color.
    return Semantics(
      slider: true,
      enabled: !widget.isDisabled,
      label: 'Color picker',
      value: 'Saturation ${(_hsv.saturation * 100).round()}%, brightness ${(_hsv.value * 100).round()}%',
      child: Focus(
        canRequestFocus: !widget.isDisabled,
        onKeyEvent: _handleKey,
        onFocusChange: (value) => setState(() => _isFocused = value),
        child: GestureDetector(
          onPanStart: widget.isDisabled
              ? null
              : (details) {
                  setState(() => _isDragging = true);
                  _update(details.localPosition);
                },
          onPanUpdate: widget.isDisabled ? null : (details) => _update(details.localPosition),
          onPanEnd: widget.isDisabled
              ? null
              : (details) {
                  setState(() => _isDragging = false);
                  widget.onChangeEnd?.call(_hsv.toColor());
                },
          onTapDown: widget.isDisabled ? null : (details) => _update(details.localPosition),
          onTapUp: widget.isDisabled ? null : (details) => widget.onChangeEnd?.call(_hsv.toColor()),
          child: SizedBox.square(
            dimension: _size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Spectrum 2 area: white to the hue from left to right, over black
                // at the bottom, with 8px corners. Gray when disabled.
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Visibility(
                      visible: !widget.isDisabled,
                      replacement: ColoredBox(color: colors.surfaceContainerHigh),
                      child: DecoratedBox(
                        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white, hue])),
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: handle.dx,
                  top: handle.dy,
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
    );
  }
}
