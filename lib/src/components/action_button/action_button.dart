import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Action Button: a button for tools and secondary actions,
/// with an icon, a text or both.
class SpectrumActionButton extends StatefulWidget {
  /// Text shown on the right of the icon.
  final Text? child;

  /// When True, each tap switches the selection on and off.
  final bool toggles;

  /// Initial selection of the button.
  final bool isSelected;

  /// Removes the gray background, which only appears on hover and tap.
  final bool isQuiet;

  /// Uses the accent blue instead of the light gray when selected.
  final bool isEmphasized;

  /// Grays out the content and ignores hover, tap and long press.
  final bool isDisabled;

  /// Text read by screen readers. Required in practice for icon only buttons.
  final String? label;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Called on every tap, after the selection changes.
  final VoidCallback? onTap;

  /// Called on long press. When set, the hold affordance triangle is shown.
  final VoidCallback? onLongPress;

  const SpectrumActionButton({
    super.key,
    this.child,
    this.toggles = false,
    this.isSelected = false,
    this.isQuiet = false,
    this.isEmphasized = false,
    this.isDisabled = false,
    this.label,
    this.icon,
    this.onTap,
    this.onLongPress,
  }) : assert(child != null || icon != null);

  @override
  State<SpectrumActionButton> createState() => _SpectrumActionButtonState();
}

/// Paints the hold affordance triangle with the button content color.
class _CornerTrianglePainter extends CustomPainter {
  final Color color;

  const _CornerTrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pathline = Path();

    pathline.moveTo(size.width, 0);
    pathline.lineTo(size.width, size.height);
    pathline.lineTo(0, size.height);
    pathline.close();

    canvas.drawPath(pathline, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CornerTrianglePainter delegate) => delegate.color != color;
}

/// Keeps the selection of the button and picks its colors.
class _SpectrumActionButtonState extends State<SpectrumActionButton> {
  /// The current selection of the button. It starts with isSelected and
  /// is switched by _handleTap when toggles is True, so the button can
  /// change its own colors without the parent rebuilding it.
  bool _isSelected = false;

  /// Hover and press states, kept to change the neutral text color,
  /// since the InkWell only changes the background by itself.
  bool _isHovered = false;
  bool _isPressed = false;

  /// Focus state, kept to draw the focus ring only when the
  /// button is focused by the keyboard, not by a mouse click.
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // When the button is created, the selection starts with the value
    // of isSelected, so a button can already appear selected without
    // the user tapping it first.
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant SpectrumActionButton widget) {
    super.didUpdateWidget(widget);

    // When the parent changes isSelected (here, widget is the old one and
    // this.widget is the new one), the selection follows the new value.
    // Otherwise, the selection made by the user tapping is kept.
    if (widget.isSelected != this.widget.isSelected) {
      _isSelected = this.widget.isSelected;
    }
  }

  /// When toggles is True, the tap switches the selection and rebuilds
  /// the button with the new colors. In both cases, the onTap passed
  /// by the user is called after it.
  void _handleTap() {
    final group = SpectrumActionButtonGroup.itemOf(context);

    // Inside a group with selection, the group decides the selection
    // and the button only tells it was tapped.
    if (group != null) {
      group.onSelect();
    } else if (widget.toggles) {
      setState(() => _isSelected = !_isSelected);
    }

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color background, pressed, content;

    // When the button is hovered or pressed, the neutral text gets
    // one step lighter, from gray-800 to gray-900, as in Spectrum.
    final neutral = _isHovered || _isPressed ? colors.inverseSurface : colors.onSurface;

    // The button is quiet when isQuiet is True or when it is inside
    // a quiet SpectrumActionButtonGroup, like the ones in the Action Bar.
    final quiet = widget.isQuiet || SpectrumActionButtonGroup.isQuietOf(context);
    final emphasized = widget.isEmphasized || SpectrumActionButtonGroup.isEmphasizedOf(context);

    // Inside a group with selection, the selection comes from the group.
    // Otherwise, the button keeps its own selection.
    final group = SpectrumActionButtonGroup.itemOf(context);
    final isSelected = group?.selected ?? _isSelected;

    // Inside a compact group, the group decides which corners are rounded.
    final borderRadius = SpectrumActionButtonGroup.borderRadiusOf(context) ?? BorderRadius.circular(8);

    if (widget.isDisabled && quiet) {
      // When isDisabled and isQuiet are True, the gray color
      // inside the button will be transparent, and just the text will change
      // your own color to gray mixing both behavior.
      background = Colors.transparent;
      pressed = Colors.transparent;
      content = colors.outline;
    } else if (widget.isDisabled) {
      // When isDisabled is True, the button keeps its gray background
      // but stops reacting to hover and tap, and the text changes
      // your own color to gray, even if the button is selected.
      background = colors.surfaceContainerHigh;
      pressed = colors.surfaceContainerHigh;
      content = colors.outline;
    } else if (isSelected && emphasized) {
      // When isSelected and isEmphasized are True, the background will be
      // the accent blue, the text will change your own color to white
      // and the hover will use a different blue from the theme extension.
      background = colors.primary;
      pressed = context.spectrum.accentHover;
      content = colors.onPrimary;
    } else if (isSelected) {
      // When isSelected is True, the colors will be inverted, the background
      // will be a light gray and the text will change your own color
      // to a dark gray, getting a little darker on hover.
      background = colors.secondary;
      pressed = colors.inverseSurface;
      content = colors.surfaceContainerLow;
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

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // Tells screen readers that this is a button, its label, if it is enabled
    // and, when toggles is True, if it is switched on or off.
    return Semantics(
      button: true,
      label: widget.label,
      enabled: !widget.isDisabled,
      toggled: widget.toggles || group != null ? isSelected : null,
      child: Stack(
        // passthrough keeps the width given by the parent, so the button
        // fills an Expanded and keeps its content width everywhere else.
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          Material(
            color: background,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              hoverColor: pressed,
              highlightColor: pressed,
              // When isDisabled is True, or there is no onTap and no toggles, the tap
              // will be null and the InkWell stops reacting to hover and tap. Otherwise,
              // _handleTap switches the selection (if toggles) and calls onTap.
              onTap: !widget.isDisabled && (widget.onTap != null || widget.toggles || group != null)
                  ? _handleTap
                  : null,
              onLongPress: widget.isDisabled ? null : widget.onLongPress,
              onHover: (value) => setState(() => _isHovered = value),
              onHighlightChanged: (value) => setState(() => _isPressed = value),
              onFocusChange: (value) => setState(() => _isFocused = value),
              focusColor: Colors.transparent,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    // widthFactor 1 keeps the button with the width of its content,
                    // only stretching when the parent forces it, like an Expanded.
                    child: Center(
                      widthFactor: 1,
                      child: IconTheme.merge(
                        data: IconThemeData(color: content),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(color: content),
                          child: Row(
                            spacing: 6,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // The icon and the text are only added when they exist, because
                              // an empty child would still receive the Row spacing and push
                              // the content out of the center. The text is Flexible to allow ellipsis.
                              if (widget.icon != null) widget.icon!,
                              if (widget.child != null) Flexible(child: widget.child!),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Spectrum "hold affordance": a small triangle in the bottom right
                  // corner, shown only when onLongPress is set, telling the user
                  // that a long press opens more options.
                  Positioned(
                    right: 3,
                    bottom: 3,
                    child: Visibility(
                      visible: widget.onLongPress != null,
                      child: CustomPaint(size: const Size.square(5), painter: _CornerTrianglePainter(content)),
                    ),
                  ),
                ],
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
