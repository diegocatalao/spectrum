import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Action Button: a button for tools and secondary actions,
/// with an icon, a text or both.
class SpectrumActionButton extends StatefulWidget {
  /// Text shown on the right of the icon.
  final Text? child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Removes the gray background, which only appears on hover and tap.
  final bool isQuiet;

  /// Grays out the content and ignores hover and tap.
  final bool isDisabled;

  /// Ignores taps while an action is running and, after one second, shows a loading
  /// circle in place of the content, keeping the button size and its focus.
  final bool isPending;

  /// Fixed white or black colors for buttons over images or colored backgrounds.
  /// When set, it replaces the theme colors.
  final SpectrumStaticColor? staticColor;

  /// Focuses the button as soon as it is shown.
  final bool isAutoFocus;

  /// Called on every tap.
  final VoidCallback? onTap;

  const SpectrumActionButton({
    super.key,
    this.child,
    this.icon,
    this.isQuiet = false,
    this.isDisabled = false,
    this.isPending = false,
    this.staticColor,
    this.isAutoFocus = false,
    this.onTap,
  }) : assert(child != null || icon != null);

  @override
  State<SpectrumActionButton> createState() => _SpectrumActionButtonState();
}

/// Keeps the interaction states of the button and picks its colors.
class _SpectrumActionButtonState extends State<SpectrumActionButton> {
  /// Hover and press states, kept to change the neutral text color,
  /// since the InkWell only changes the background by itself.
  bool _isHovered = false;
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
  void didUpdateWidget(covariant SpectrumActionButton widget) {
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
    final Color background, pressed, content;
    final Color tone;

    // When the button is hovered or pressed, the neutral text gets
    // one step lighter, from gray-800 to gray-900, as in Spectrum.
    final neutral = _isHovered || _isPressed ? colors.inverseSurface : colors.onSurface;

    // The button is quiet when isQuiet is True or when it is inside
    // a quiet SpectrumActionButtonGroup, like the ones in the Action Bar.
    final quiet = widget.isQuiet || SpectrumActionButtonGroup.isQuietOf(context);

    // A pending button looks disabled, as in Spectrum 2, once the loading circle appears.
    final isDisabled = widget.isDisabled;
    final staticColor = widget.staticColor;
    final isInactive = isDisabled || _isSpinnerVisible;

    // Inside a compact group, the group decides which corners are rounded.
    final borderRadius = SpectrumActionButtonGroup.borderRadiusOf(context) ?? BorderRadius.circular(8);

    if (staticColor == SpectrumStaticColor.black) {
      // When staticColor is black, the button uses black tones over light images.
      tone = SpectrumColors.black;
    } else {
      // Otherwise the static tone is white, used over dark images when staticColor is white.
      tone = SpectrumColors.white;
    }

    if (staticColor != null && isInactive && quiet) {
      // When staticColor is set and isDisabled (or isPending) and isQuiet are True,
      // the background stays transparent and the text keeps the static tone
      // with low opacity, so it stays visible but can not be tapped.
      background = Colors.transparent;
      pressed = Colors.transparent;
      content = tone.withValues(alpha: 0.4);
    } else if (staticColor != null && isInactive) {
      // When staticColor is set and isDisabled (or isPending) is True, the background
      // and the text keep the static tone with low opacity, so the button
      // stays visible over the image but clearly can not be tapped.
      background = tone.withValues(alpha: 0.1);
      pressed = tone.withValues(alpha: 0.1);
      content = tone.withValues(alpha: 0.4);
    } else if (staticColor != null && quiet) {
      // When staticColor is set and isQuiet is True, the background is
      // transparent and a translucent tone only appears on hover and tap.
      background = Colors.transparent;
      pressed = tone.withValues(alpha: 0.2);
      content = tone;
    } else if (staticColor != null) {
      // When staticColor is set, the background is a translucent static tone,
      // getting a little stronger on hover and tap, with the text in the tone.
      background = tone.withValues(alpha: 0.1);
      pressed = tone.withValues(alpha: 0.2);
      content = tone;
    } else if (isInactive && quiet) {
      // When isDisabled (or isPending) and isQuiet are True, the background
      // is transparent and just the text changes its color to gray.
      background = Colors.transparent;
      pressed = Colors.transparent;
      content = colors.outline;
    } else if (isInactive) {
      // When isDisabled (or isPending) is True, the button keeps its gray
      // background but stops reacting to hover and tap, and the text
      // changes its color to gray.
      background = colors.surfaceContainerHigh;
      pressed = colors.surfaceContainerHigh;
      content = colors.outline;
    } else if (quiet) {
      // When isQuiet is True, the gray color inside the button will be
      // transparent, and the gray background just appears on hover
      // and tap, keeping the default text color.
      background = Colors.transparent;
      pressed = colors.surfaceContainerHighest;
      content = neutral;
    } else {
      // When no option is True, the button will have the default
      // gray background, getting a lighter gray on hover and tap,
      // and the text will keep the default color.
      background = colors.surfaceContainerHigh;
      pressed = colors.surfaceContainerHighest;
      content = neutral;
    }

    final Color spinner, track;

    if (staticColor != null) {
      // When staticColor is set, the loading circle uses the solid static tone
      // over a translucent track, so it stays visible over the image.
      spinner = tone;
      track = tone.withValues(alpha: 0.25);
    } else {
      // Otherwise the loading circle is the accent blue over a gray track,
      // as the Spectrum 2 progress circle inside a pending button.
      spinner = colors.primary;
      track = colors.surfaceContainerHighest;
    }

    final Widget? text;

    if (widget.child != null) {
      // When there is a text, it is Flexible so it can shrink with an ellipsis.
      text = Flexible(child: widget.child!);
    } else {
      // Otherwise nothing is added, since an empty child would still
      // receive the Row spacing and push the icon out of the center.
      text = null;
    }

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // Tells screen readers that this is a button and if it is enabled.
    return Semantics(
      button: true,
      enabled: !isDisabled,
      child: Stack(
        // passthrough keeps the width given by the parent, so the button
        // fills an Expanded and keeps its content width everywhere else.
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          // Spectrum 2 "press scale": the button shrinks a little while it is
          // pressed and grows back when released, as the SpectrumButton.
          AnimatedScale(
            scale: _isPressed ? 0.95 : 1,
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeInOut,
            child: Material(
              color: background,
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                hoverColor: pressed,
                highlightColor: pressed,
                focusColor: Colors.transparent,
                autofocus: widget.isAutoFocus,
                // When isDisabled is True the tap is null and the button can not be
                // focused. When isPending is True, _handleTap ignores the tap but
                // the button stays focusable, as in Spectrum 2.
                onTap: isDisabled ? null : _handleTap,
                onHover: (value) => setState(() => _isHovered = value),
                onHighlightChanged: (value) => setState(() => _isPressed = value && !widget.isPending),
                onFocusChange: (value) => setState(() => _isFocused = value),
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  // widthFactor 1 keeps the button with the width of its content,
                  // only stretching when the parent forces it, like an Expanded.
                  child: Center(
                    widthFactor: 1,
                    child: IconTheme.merge(
                      data: IconThemeData(color: content),
                      // One line with ellipsis keeps the button 32px high when its text
                      // gets less width than it needs, instead of wrapping and being cut.
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: content),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
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
                              child: Row(spacing: 6, mainAxisSize: MainAxisSize.min, children: [?widget.icon, ?text]),
                            ),
                            Visibility(
                              visible: _isSpinnerVisible,
                              // liveRegion makes screen readers announce the pending state when it appears.
                              child: Semantics(
                                label: 'Pending',
                                liveRegion: true,
                                child: SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: spinner,
                                    backgroundColor: track,
                                  ),
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.spectrum.focusIndicator, width: 2),
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
