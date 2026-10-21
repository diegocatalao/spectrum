import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Color Swatch Picker: a grid of SpectrumColorSwatch to pick one
/// color from a palette, with a ring on the selected one.
class SpectrumColorSwatchPicker extends StatefulWidget {
  /// Swatches of the palette.
  final List<SpectrumColorSwatch> children;

  /// Color selected at start. When the parent changes it, the picker follows.
  final Color? value;

  /// Called with the color of the tapped swatch.
  final ValueChanged<Color>? onChange;

  /// Space between the swatches: 2px compact, 4px regular or 6px spacious.
  final VisualDensity density;

  /// Corners of every swatch.
  final SpectrumColorSwatchRounding rounding;

  const SpectrumColorSwatchPicker({
    super.key,
    required this.children,
    this.value,
    this.onChange,
    this.density = VisualDensity.standard,
    this.rounding = SpectrumColorSwatchRounding.small,
  });

  /// Returns the rounding of the picker around the swatch, or null outside of one.
  static SpectrumColorSwatchRounding? roundingOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SwatchPickerScope>()?.rounding;
  }

  @override
  State<SpectrumColorSwatchPicker> createState() => _SpectrumColorSwatchPickerState();
}

/// Keeps the selected color of the picker.
class _SpectrumColorSwatchPickerState extends State<SpectrumColorSwatchPicker> {
  /// Selected color, changed on every tap.
  Color? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumColorSwatchPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the picker follows it.
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _handleSelect(Color color) {
    setState(() => _value = color);
    widget.onChange?.call(color);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final double gap;
    final BorderRadius radius;

    if (widget.density == VisualDensity.compact) {
      gap = 2;
    } else if (widget.density == VisualDensity.comfortable) {
      gap = 6;
    } else {
      gap = 4;
    }

    if (widget.rounding == SpectrumColorSwatchRounding.full) {
      radius = BorderRadius.circular(999);
    } else if (widget.rounding == SpectrumColorSwatchRounding.none) {
      radius = BorderRadius.zero;
    } else {
      radius = BorderRadius.circular(4);
    }

    return _SwatchPickerScope(
      rounding: widget.rounding,
      child: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final swatch in widget.children)
            Semantics(
              button: true,
              selected: swatch.color == _value,
              inMutuallyExclusiveGroup: true,
              child: GestureDetector(
                onTap: () => _handleSelect(swatch.color),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      swatch,
                      // Spectrum 2 selected swatch: a 2px gray-900 border with a 2px
                      // gray-25 ring inside it, over the color.
                      Positioned.fill(
                        child: Visibility(
                          visible: swatch.color == _value,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: radius,
                              border: Border.all(color: colors.inverseSurface, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: radius,
                                  border: Border.all(color: colors.surface, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shares the rounding of the picker with its swatches.
class _SwatchPickerScope extends InheritedWidget {
  final SpectrumColorSwatchRounding rounding;

  const _SwatchPickerScope({required this.rounding, required super.child});

  @override
  bool updateShouldNotify(_SwatchPickerScope oldWidget) => oldWidget.rounding != rounding;
}
