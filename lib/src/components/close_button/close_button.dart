import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Close Button: a round button with an X, used to close
/// or dismiss things like the Action Bar, dialogs and toasts.
class SpectrumCloseButton extends StatefulWidget {
  /// Grays out the icon and ignores hover and tap.
  final bool isDisabled;

  /// Called on every tap.
  final VoidCallback? onTap;

  const SpectrumCloseButton({super.key, this.isDisabled = false, this.onTap});

  @override
  State<SpectrumCloseButton> createState() => _SpectrumCloseButtonState();
}

/// Keeps the hover, press and focus states of the button and picks its colors.
class _SpectrumCloseButtonState extends State<SpectrumCloseButton> {
  /// Hover and press states, kept to change the icon color,
  /// since the InkWell only changes the background by itself.
  bool _isHovered = false;
  bool _isPressed = false;

  /// Focus state, kept to draw the focus ring only when the
  /// button is focused by the keyboard, not by a mouse click.
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color content, hover, pressed;

    if (widget.isDisabled) {
      // When isDisabled is True, the icon changes your own color
      // to gray and the button stops reacting to hover and tap.
      content = colors.outline;
      hover = Colors.transparent;
      pressed = Colors.transparent;
    } else if (_isHovered || _isPressed) {
      // When the button is hovered or pressed, the icon gets one step
      // lighter, from gray-800 to gray-900, as in Spectrum.
      content = colors.inverseSurface;
      hover = colors.surfaceContainerHigh;
      pressed = colors.surfaceContainerHighest;
    } else {
      // When no option is True, the button has no background
      // and the icon keeps the default color.
      content = colors.onSurface;
      hover = colors.surfaceContainerHigh;
      pressed = colors.surfaceContainerHighest;
    }

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final ring = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).closeButtonTooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              // The background appears on hover and tap, drawn only
              // inside the circle by the customBorder above.
              hoverColor: hover,
              highlightColor: pressed,
              focusColor: Colors.transparent,
              // When isDisabled is True, or there is no onTap, the tap will be
              // null and the InkWell stops reacting to hover and tap.
              onTap: widget.isDisabled ? null : widget.onTap,
              onHover: (value) => setState(() => _isHovered = value),
              onHighlightChanged: (value) => setState(() => _isPressed = value),
              onFocusChange: (value) => setState(() => _isFocused = value),
              child: SizedBox.square(
                dimension: 32,
                child: Center(child: SpectrumIcon(SpectrumIcons.close, size: 12, color: content)),
              ),
            ),
          ),
          // Spectrum focus indicator: a 2px ring with a 2px gap around
          // the button, drawn outside it so the layout does not change.
          Positioned(
            left: -4,
            top: -4,
            right: -4,
            bottom: -4,
            child: IgnorePointer(
              child: Visibility(
                visible: ring,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: SpectrumThemeExtension.of(context).focusIndicator, width: 2),
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
