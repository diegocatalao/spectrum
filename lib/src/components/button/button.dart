import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Visual role of a SpectrumButton.
enum SpectrumButtonVariant {
  primary,
  secondary,
  accent,
  negative;

  /// Background color of this variant.
  Color colorsOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (this == accent) {
      return colors.primary;
    } else if (this == negative) {
      return colors.error;
    } else if (this == secondary) {
      return colors.secondaryContainer;
    } else {
      return colors.secondary;
    }
  }

  /// Background color of this variant on hover and tap, one step darker than colorsOf.
  Color hoverOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (this == accent) {
      return context.spectrum.accentHover;
    } else if (this == negative) {
      return context.spectrum.negativeHover;
    } else if (this == secondary) {
      return colors.surfaceContainerHighest;
    } else {
      return colors.inverseSurface;
    }
  }

  /// Text and icon color of this variant, readable over its background.
  Color contentOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (this == accent) {
      return colors.onPrimary;
    } else if (this == negative) {
      return colors.onError;
    } else if (this == secondary) {
      return colors.onSecondaryContainer;
    } else {
      return colors.onSecondary;
    }
  }
}

/// Spectrum Button: the main call to action of a view, with a text and an optional icon.
class SpectrumButton extends StatefulWidget {
  /// Text shown on the right of the icon.
  final String content;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Grays out the button and ignores hover and tap.
  final bool isDisabled;

  /// Visual role of the button, primary by default.
  final SpectrumButtonVariant variant;

  /// Draws only a border in the variant color instead of filling the background.
  final bool isOutline;

  /// Ignores taps while an action is running and, after one second, shows a loading
  /// circle in place of the content, keeping the button size and its focus.
  final bool isPending;

  /// Focuses the button as soon as it is shown.
  final bool isAutoFocus;

  /// Fixed white or black colors for buttons over images or colored backgrounds.
  /// When set, it replaces the variant colors.
  final SpectrumStaticColor? staticColor;

  /// Called on every tap.
  final VoidCallback? onTap;

  const SpectrumButton({
    super.key,
    required this.content,
    this.icon,
    this.variant = SpectrumButtonVariant.primary,
    this.isDisabled = false,
    this.isOutline = false,
    this.isPending = false,
    this.isAutoFocus = false,
    this.staticColor,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _SpectrumButtonState();
}

class _SpectrumButtonState extends State<SpectrumButton> {
  /// Press state, kept to shrink the button while it is held down.
  bool _isPressed = false;

  /// Focus state, kept to draw the focus ring only when the
  /// button is focused by the keyboard, not by a mouse click.
  bool _isFocused = false;

  /// Whether the loading circle is shown. It turns True one second after
  /// isPending, as in Spectrum 2, so quick actions never flash the circle.
  bool _isSpinnerVisible = false;

  /// Timer that shows the loading circle one second after isPending.
  Timer? _pendingTimer;

  @override
  void initState() {
    super.initState();
    // When the button is created already pending, the one second
    // delay starts right away, as if isPending had just turned True.
    _updatePending();
  }

  @override
  void didUpdateWidget(covariant SpectrumButton widget) {
    super.didUpdateWidget(widget);

    // When the parent changes isPending (here, widget is the old one and
    // this.widget is the new one), the delay starts or the circle hides.
    if (widget.isPending != this.widget.isPending) {
      _updatePending();
    }
  }

  @override
  void dispose() {
    _pendingTimer?.cancel();
    super.dispose();
  }

  /// Starts the one second delay when pending, or hides the circle at once when not.
  void _updatePending() {
    _pendingTimer?.cancel();

    if (widget.isPending) {
      // When isPending is True, the content stays visible for one second
      // and only then the loading circle replaces it.
      _pendingTimer = Timer(const Duration(seconds: 1), () => setState(() => _isSpinnerVisible = true));
    } else {
      // When isPending is False, the loading circle hides immediately
      // and the content comes back without waiting.
      _isSpinnerVisible = false;
    }
  }

  /// Ignores the tap while pending, so the running action is not started again.
  /// The InkWell keeps a tap handler so the pending button stays focusable.
  void _handleTap() {
    if (!widget.isPending) {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color background, pressed, content, border;
    final Color tone, contrast;

    if (widget.staticColor == SpectrumStaticColor.black) {
      // When staticColor is black, the button is drawn in black
      // with white text, for light images and backgrounds.
      tone = SpectrumColors.black;
      contrast = SpectrumColors.white;
    } else {
      // Otherwise the static tone is white with black text, used
      // for dark images and backgrounds when staticColor is white.
      tone = SpectrumColors.white;
      contrast = SpectrumColors.black;
    }

    // A pending button looks disabled, as in Spectrum 2, once the loading circle appears.
    // Inside a disabled SpectrumButtonGroup, the button is disabled too.
    final isDisabled = widget.isDisabled || SpectrumButtonGroup.isDisabledOf(context);
    final isInactive = isDisabled || _isSpinnerVisible;

    if (widget.staticColor != null && isInactive && widget.isOutline) {
      // When staticColor is set and isDisabled (or isPending) and isOutline are True,
      // the border and the text keep the static tone with low opacity,
      // so the button stays visible over the image but can not be tapped.
      background = Colors.transparent;
      pressed = Colors.transparent;
      content = tone.withValues(alpha: 0.4);
      border = tone.withValues(alpha: 0.25);
    } else if (widget.staticColor != null && isInactive) {
      // When staticColor is set and isDisabled (or isPending) is True, the background
      // and the text keep the static tone with low opacity, so the button
      // stays visible over the image but clearly can not be tapped.
      background = tone.withValues(alpha: 0.1);
      pressed = tone.withValues(alpha: 0.1);
      content = tone.withValues(alpha: 0.4);
      border = Colors.transparent;
    } else if (widget.staticColor != null && widget.isOutline) {
      // When staticColor is set and isOutline is True, the border and
      // the text use the static tone, and hover and tap show a
      // translucent background of the same tone.
      background = Colors.transparent;
      pressed = tone.withValues(alpha: 0.1);
      content = tone;
      border = tone;
    } else if (widget.staticColor != null) {
      // When staticColor is set, the button is filled with the static
      // tone and the text uses the opposite one, ignoring the variant,
      // and hover and tap make the background slightly translucent.
      background = tone;
      pressed = tone.withValues(alpha: 0.9);
      content = contrast;
      border = Colors.transparent;
    } else if (isInactive && widget.isOutline) {
      // When isDisabled (or isPending) and isOutline are True, the background stays
      // transparent, and the border and the text change their
      // color to gray to show the button can not be tapped.
      background = Colors.transparent;
      pressed = Colors.transparent;
      content = colors.outline;
      border = colors.surfaceContainerHigh;
    } else if (isInactive) {
      // When isDisabled (or isPending) is True, the button keeps a light gray
      // background whatever the variant, and the text changes
      // its color to gray to show it can not be tapped.
      background = colors.surfaceContainerHigh;
      pressed = colors.surfaceContainerHigh;
      content = colors.outline;
      border = Colors.transparent;
    } else if (widget.isOutline && widget.variant == SpectrumButtonVariant.secondary) {
      // When isOutline is True and the variant is secondary, the border
      // is the neutral gray of the theme, since the secondary fill
      // is too light to be seen as a border.
      background = Colors.transparent;
      pressed = colors.surfaceContainerHigh;
      content = widget.variant.contentOf(context);
      border = colors.outline;
    } else if (widget.isOutline) {
      // When isOutline is True, the background is transparent, the border
      // and the text use the variant color, and hover and tap
      // show a light gray background behind them.
      background = Colors.transparent;
      pressed = colors.surfaceContainerHigh;
      content = widget.variant.colorsOf(context);
      border = widget.variant.colorsOf(context);
    } else {
      // When isDisabled is False, the background and the text
      // follow the variant, and hover and tap darken the background
      // one step, as in Spectrum, in the light and dark themes.
      background = widget.variant.colorsOf(context);
      pressed = widget.variant.hoverOf(context);
      content = widget.variant.contentOf(context);
      border = Colors.transparent;
    }

    // The stadium is the Spectrum pill shape, and its side draws the outline,
    // transparent in the fill style so both styles keep the same size.
    final Color spinner, track;

    if (widget.staticColor != null) {
      // When staticColor is set, the loading circle uses the solid static tone
      // over a translucent track, so it stays visible over the image even
      // while the rest of the pending button is faded.
      spinner = tone;
      track = tone.withValues(alpha: 0.25);
    } else {
      // Otherwise the loading circle is the accent blue over a gray track,
      // as the Spectrum 2 progress circle inside a pending button.
      spinner = colors.primary;
      track = colors.surfaceContainerHighest;
    }

    final shape = StadiumBorder(side: BorderSide(color: border, width: 2));

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // Tells screen readers that this is a button, its text and if it is enabled.
    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: widget.content,
      child: Stack(
        // passthrough keeps the size of the button, and Clip.none lets
        // the focus ring be drawn outside of it.
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          // Spectrum 2 "press scale": the button shrinks a little while it is
          // pressed and grows back when released, giving a physical feedback.
          AnimatedScale(
            scale: _isPressed ? 0.95 : 1,
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeInOut,
            child: Material(
              shape: shape,
              color: background,
              child: InkWell(
                customBorder: shape,
                hoverColor: pressed,
                highlightColor: pressed,
                focusColor: Colors.transparent,
                autofocus: widget.isAutoFocus,
                // When isDisabled is True the tap is null and the button can not be
                // focused. When isPending is True, _handleTap ignores the tap but
                // the button stays focusable, as in Spectrum 2.
                onTap: isDisabled ? null : _handleTap,
                onHighlightChanged: (value) => setState(() => _isPressed = value && !widget.isPending),
                onFocusChange: (value) => setState(() => _isFocused = value),
                child: Container(
                  height: 32,
                  padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
                  child: IconTheme.merge(
                    data: IconThemeData(color: content),
                    // The Stack keeps the content in the layout while pending, so the
                    // button does not change its width when the loading circle appears.
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: !_isSpinnerVisible,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Row(
                            spacing: 6,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ?widget.icon,
                              // Flexible lets the text shrink with an ellipsis when the button
                              // gets less width than its content, like inside a narrow group.
                              Flexible(
                                child: Text(
                                  widget.content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: content, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _isSpinnerVisible,
                          // liveRegion makes screen readers announce the pending state when it appears.
                          child: Semantics(
                            label: 'Pending',
                            liveRegion: true,
                            child: SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: spinner, backgroundColor: track),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                visible: showFocusRing,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(side: BorderSide(color: context.spectrum.focusIndicator, width: 2)),
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
