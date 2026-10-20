import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Checkbox: a box that turns an option on or off, followed by its label.
class SpectrumCheckbox extends StatefulWidget {
  /// Label shown on the right of the box.
  final Text? child;

  /// Text shown below the label.
  final Text? description;

  /// Whether the box starts checked. When the parent changes it, the box follows.
  final bool isSelected;

  /// Fills the checked box with the accent blue instead of the neutral gray.
  final bool isEmphasized;

  /// Shows a dash instead of the checkmark, for a partially checked group,
  /// like a "select all" with only some options checked.
  final bool isIndeterminate;

  /// Grays out the box and ignores hover and tap.
  final bool isDisabled;

  /// Called with the new value when the box is tapped.
  final ValueChanged<bool>? onChanged;

  const SpectrumCheckbox({
    super.key,
    this.child,
    this.description,
    this.isSelected = false,
    this.isEmphasized = false,
    this.isIndeterminate = false,
    this.isDisabled = false,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _SpectrumCheckbox();
}

/// Keeps the interaction states of the box and picks its colors.
class _SpectrumCheckbox extends State<SpectrumCheckbox> {
  /// Hover and press states, kept to darken the box, since the InkWell
  /// does not change the border by itself.
  bool _isHovered = false;
  bool _isPressed = false;

  /// Focus state, kept to draw the focus ring only for keyboard navigation.
  bool _isFocused = false;

  /// Whether the box is checked, changed on every tap.
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant SpectrumCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes isSelected, the box follows it.
    if (oldWidget.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  /// Checks or unchecks the box and tells the parent. A tap on an indeterminate
  /// box checks it, as in Spectrum 2.
  void _handleTap() {
    if (widget.isIndeterminate) {
      setState(() => _isSelected = true);
    } else {
      setState(() => _isSelected = !_isSelected);
    }

    widget.onChanged?.call(_isSelected);
  }

  /// Inside a disabled SpectrumForm the control is disabled too.
  bool get _isDisabled => widget.isDisabled || SpectrumForm.isDisabledOf(context);

  /// Inside an emphasized SpectrumForm the control is emphasized too.
  bool get _isEmphasized => widget.isEmphasized || SpectrumForm.isEmphasizedOf(context);

  /// Whether the box is hovered or pressed, which darkens it.
  bool get _isActive => _isHovered || _isPressed;

  /// Fill of a checked box: gray-400 when disabled, the accent blue when emphasized,
  /// and the neutral gray-800 otherwise, getting darker on hover and tap.
  Color _fillOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (_isDisabled) {
      return colors.outline;
    } else if (_isEmphasized) {
      return _isActive ? context.spectrum.accentHover : colors.primary;
    } else {
      return _isActive ? colors.inverseSurface : colors.onSurface;
    }
  }

  /// Spectrum 2 checkbox box: 16px in the M size, with 2px corners and a 2px border, changing
  /// its colors with the default 130ms transition.
  Widget _box({required Color color, required Color border, Widget? child}) {
    return AnimatedContainer(
      duration: SpectrumMotion.duration,
      curve: SpectrumMotion.curve,
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: border, width: 2),
      ),
      child: Center(child: child),
    );
  }

  /// Selected: the box is filled and shows a checkmark in the background color.
  Widget _buildSelected(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _box(
      color: _fillOf(context),
      border: Colors.transparent,
      child: SpectrumIcon(SpectrumIcons.checkmark, size: 10, color: colors.surface),
    );
  }

  /// Unselected: the opposite of the selected box, empty with a border in the color
  /// of the fill, gray-400 when disabled and gray-900 on hover and tap.
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

    return _box(color: colors.surface, border: border);
  }

  /// Indeterminate: the box is filled like the selected one, with a dash
  /// instead of the checkmark.
  Widget _buildIndeterminate(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _box(
      color: _fillOf(context),
      border: Colors.transparent,
      child: Container(width: 8, height: 2, color: colors.surface),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget box;

    if (widget.isIndeterminate) {
      // When isIndeterminate is True, the dash is shown even if the box is
      // selected, since the group below it is only partially checked.
      box = _buildIndeterminate(context);
    } else if (_isSelected) {
      // When the box is selected, the box is filled with the checkmark.
      box = _buildSelected(context);
    } else {
      // Otherwise the box is empty, only with its border.
      box = _buildUnselected(context);
    }

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final Color content;

    if (_isDisabled) {
      // When isDisabled is True, the label turns gray-400 like the box.
      content = colors.outline;
    } else if (_isActive) {
      // When the checkbox is hovered or pressed, the label gets darker (gray-900).
      content = colors.inverseSurface;
    } else {
      // Otherwise the label keeps the default text color (gray-800).
      content = colors.onSurface;
    }

    final Widget? label;

    if (widget.child != null) {
      // When there is a label, it is Flexible so a long text wraps.
      label = Flexible(
        child: DefaultTextStyle(
          style: style.copyWith(color: content),
          child: widget.child!,
        ),
      );
    } else {
      // Otherwise nothing is added, since an empty child would still
      // receive the Row spacing and push the box to the left.
      label = null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tells screen readers that this is a checkbox, if it is checked,
        // partially checked (mixed) and enabled. The label is read from the
        // text inside, so it is not repeated here.
        Semantics(
          checked: _isSelected,
          mixed: widget.isIndeterminate,
          enabled: !_isDisabled,
          // The box and the label react to hover and tap together, as in Spectrum 2.
          // The description is outside, so tapping it does not toggle the box.
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              // When isDisabled is True the tap is null, so the checkbox ignores
              // hover and tap and can not be focused.
              onTap: _isDisabled ? null : _handleTap,
              onHover: (value) => setState(() => _isHovered = value),
              onHighlightChanged: (value) => setState(() => _isPressed = value),
              onFocusChange: (value) => setState(() => _isFocused = value),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // The label is centered with the box.
                crossAxisAlignment: CrossAxisAlignment.center,
                // Spectrum 2 "text-to-control" gap of the M size.
                spacing: 10,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Spectrum 2 "press scale": the box shrinks a little while pressed.
                      SpectrumPressScale(isPressed: _isPressed, child: box),
                      // Spectrum focus indicator: a 2px ring with a 2px gap around the box,
                      // drawn outside it so the layout does not change.
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
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: context.spectrum.focusIndicator, width: 2),
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
        // The description starts at the left edge of the box, 8px below it,
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
