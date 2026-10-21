import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Switch: a track with a handle that turns a setting on or off,
/// followed by its label.
class SpectrumSwitch extends StatefulWidget {
  /// Label shown on the right of the track.
  final Text? child;

  /// Text shown below the switch, outside of its tap area.
  final Text? description;

  /// Whether the switch starts on. When the parent changes it, the switch follows.
  final bool isSelected;

  /// Fills the track with the accent blue when on, instead of the neutral gray.
  final bool isEmphasized;

  /// Grays out the switch and ignores hover and tap.
  final bool isDisabled;

  /// Called with the new value when the switch is tapped.
  final ValueChanged<bool>? onChanged;

  const SpectrumSwitch({
    super.key,
    this.child,
    this.description,
    this.isSelected = false,
    this.isEmphasized = false,
    this.isDisabled = false,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _SpectrumSwitchState();
}

/// Keeps the value and the interaction states of the switch and picks its colors.
class _SpectrumSwitchState extends State<SpectrumSwitch> {
  /// Whether the switch is on, changed on every tap.
  bool _isSelected = false;

  /// Hover and press states, kept to darken the track and the label.
  bool _isHovered = false;
  bool _isPressed = false;

  /// Focus state, kept to draw the focus ring only for keyboard navigation.
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant SpectrumSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes isSelected, the switch follows it.
    if (oldWidget.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  /// Turns the switch on or off and tells the parent.
  void _handleTap() {
    setState(() => _isSelected = !_isSelected);
    widget.onChanged?.call(_isSelected);
  }

  /// Inside a disabled SpectrumForm the control is disabled too.
  bool get _isDisabled => widget.isDisabled || SpectrumForm.isDisabledOf(context);

  /// Inside an emphasized SpectrumForm the control is emphasized too.
  bool get _isEmphasized => widget.isEmphasized || SpectrumForm.isEmphasizedOf(context);

  /// Whether the switch is hovered or pressed, which darkens it.
  bool get _isActive => _isHovered || _isPressed;

  /// Fill of the track when on: gray-400 when disabled, the accent blue when
  /// emphasized, and the neutral gray-800 otherwise, darker on hover and tap.
  Color _fillOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (_isDisabled) {
      return colors.outline;
    } else if (_isEmphasized) {
      return _isActive ? SpectrumThemeExtension.of(context).accentHover : colors.primary;
    } else {
      return _isActive ? colors.inverseSurface : colors.onSurface;
    }
  }

  /// Spectrum 2 switch track: 26x16px pill in the M size with a 2px border, and the
  /// handle inside it, in a 12px square at the start or at the end of the track.
  Widget _track({required Color color, required Color border, required Color handle, required double size}) {
    return AnimatedContainer(
      duration: SpectrumMotion.duration,
      curve: SpectrumMotion.curve,
      width: 26,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border, width: 2),
      ),
      child: AnimatedAlign(
        duration: SpectrumMotion.duration,
        curve: SpectrumMotion.curve,
        alignment: _isSelected ? Alignment.centerRight : Alignment.centerLeft,
        child: SizedBox.square(
          dimension: 12,
          child: Center(
            // Spectrum 2 "press scale": the handle shrinks a little while pressed.
            child: SpectrumPressScale(
              isPressed: _isPressed,
              child: AnimatedContainer(
                duration: SpectrumMotion.duration,
                curve: SpectrumMotion.curve,
                width: size,
                height: size,
                decoration: BoxDecoration(color: handle, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// On: the track is filled and the handle is a 10px light dot at the end.
  Widget _buildSelected(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _track(color: _fillOf(context), border: Colors.transparent, handle: colors.surface, size: 10);
  }

  /// Off: the opposite of the on track, empty with a border, and the handle is a
  /// 8px dot at the start in the color of the border.
  Widget _buildUnselected(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color border;

    if (_isDisabled) {
      border = colors.outline;
    } else if (_isActive) {
      border = colors.inverseSurface;
    } else {
      border = colors.onSurface;
    }

    return _track(color: colors.surface, border: border, handle: border, size: 8);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    // The extra line height above the first line and below the last one is removed,
    // so the text box is the height of the letters and the label looks centered.
    const textHeightBehavior = TextHeightBehavior(applyHeightToFirstAscent: false, applyHeightToLastDescent: false);
    final Widget track;
    final Color content;

    if (_isSelected) {
      // When the switch is on, the track is filled with the handle at the end.
      track = _buildSelected(context);
    } else {
      // Otherwise the track is empty with the handle at the start.
      track = _buildUnselected(context);
    }

    if (_isDisabled) {
      // When isDisabled is True, the texts turn gray-400 like the track.
      content = colors.outline;
    } else if (_isActive) {
      // When the switch is hovered or pressed, the texts get darker (gray-900).
      content = colors.inverseSurface;
    } else {
      // Otherwise the texts keep the default color (gray-800).
      content = colors.onSurface;
    }

    final Widget? label;

    if (widget.child != null) {
      // When there is a label, it is Flexible so a long text wraps.
      label = Flexible(
        child: DefaultTextStyle(
          style: style.copyWith(color: content),
          textHeightBehavior: textHeightBehavior,
          child: widget.child!,
        ),
      );
    } else {
      // Otherwise nothing is added, since an empty child would still
      // receive the Row spacing and push the track to the left.
      label = null;
    }

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tells screen readers that this is a switch, if it is on and enabled.
        Semantics(
          toggled: _isSelected,
          enabled: !_isDisabled,
          // The track and the label react to hover and tap together, as in Spectrum 2.
          // The description is outside, so tapping it does not toggle the switch.
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              // When isDisabled is True the tap is null, so the switch ignores
              // hover and tap and can not be focused.
              onTap: _isDisabled ? null : _handleTap,
              onHover: (value) => setState(() => _isHovered = value),
              onHighlightChanged: (value) => setState(() => _isPressed = value),
              onFocusChange: (value) => setState(() => _isFocused = value),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // The label is centered with the track.
                crossAxisAlignment: CrossAxisAlignment.center,
                // Spectrum 2 "text-to-control" gap of the M size.
                spacing: 10,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      track,
                      // Spectrum focus indicator: a 2px ring with a 2px gap around the
                      // track, drawn outside it so the layout does not change.
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
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: SpectrumThemeExtension.of(context).focusIndicator, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ?label,
                ],
              ),
            ),
          ),
        ),
        // The description starts at the left edge of the track, 8px below it,
        // with the same style as the label.
        Visibility(
          visible: widget.description != null,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(
              style: style.copyWith(color: content),
              child: widget.description ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
