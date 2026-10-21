import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Radio: one option of a SpectrumRadioGroup, a circle followed by its label.
class SpectrumRadio extends StatefulWidget {
  /// Value of the option, sent by the group when it is selected.
  final String value;

  /// Label of the option.
  final Text? child;

  /// Grays out the option and ignores taps.
  final bool isDisabled;

  const SpectrumRadio({super.key, required this.value, this.child, this.isDisabled = false});

  @override
  State<SpectrumRadio> createState() => _SpectrumRadioState();
}

/// Keeps the hover, press and focus states of the radio.
class _SpectrumRadioState extends State<SpectrumRadio> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final group = SpectrumRadioGroup.radioOf(context);
    final isSelected = group?.isSelected ?? false;
    final isDisabled = widget.isDisabled || (group?.isDisabled ?? false);
    final isInvalid = group?.isInvalid ?? false;
    final isEmphasized = group?.isEmphasized ?? false;
    final isActive = _isHovered || _isPressed;
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final Color border, content;

    if (isDisabled) {
      // When disabled, the circle and the label are gray-400.
      border = colors.outline;
      content = colors.outline;
    } else if (isInvalid) {
      // When the group is invalid, the circle is red.
      border = isActive ? SpectrumColors.red1000 : colors.error;
      content = isActive ? colors.inverseSurface : colors.onSurface;
    } else if (isSelected && isEmphasized) {
      // When selected and emphasized, the ring is the accent blue.
      border = isActive ? SpectrumThemeExtension.of(context).accentHover : colors.primary;
      content = isActive ? colors.inverseSurface : colors.onSurface;
    } else {
      // Otherwise the circle is gray-800, gray-900 on hover and tap.
      border = isActive ? colors.inverseSurface : colors.onSurface;
      content = isActive ? colors.inverseSurface : colors.onSurface;
    }

    final style = (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: content);

    return Semantics(
      checked: isSelected,
      enabled: !isDisabled,
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: isDisabled ? null : group?.onToggle,
        onHover: (value) => setState(() => _isHovered = value),
        onHighlightChanged: (value) => setState(() => _isPressed = value),
        onFocusChange: (value) => setState(() => _isFocused = value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            // Spectrum 2 radio: a 16px circle with a 2px border; when selected, the
            // border grows to 6px, leaving a 4px gray-25 dot, with the press scale.
            SpectrumPressScale(
              isPressed: _isPressed,
              child: AnimatedContainer(
                duration: SpectrumMotion.duration,
                curve: SpectrumMotion.curve,
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: border, width: isSelected ? 6 : 2),
                  boxShadow: showFocusRing
                      ? [
                          BoxShadow(color: colors.surface, spreadRadius: 2),
                          BoxShadow(color: SpectrumThemeExtension.of(context).focusIndicator, spreadRadius: 4),
                        ]
                      : null,
                ),
              ),
            ),
            Flexible(
              child: Visibility(
                visible: widget.child != null,
                child: DefaultTextStyle(style: style, child: widget.child ?? const SizedBox.shrink()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
