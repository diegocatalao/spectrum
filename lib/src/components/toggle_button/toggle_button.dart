import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Toggle Button: an action button that turns a setting or a mode on
/// or off, filled while it is selected.
class SpectrumToggleButton extends StatefulWidget {
  /// Text shown on the right of the icon.
  final Text? child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Whether the button starts selected. When the parent changes it, the button follows.
  final bool isSelected;

  /// Fills the selected button with the accent blue instead of the neutral gray.
  final bool isEmphasized;

  /// Removes the gray background while the button is not selected.
  final bool isQuiet;

  /// Grays out the button and ignores hover and tap.
  final bool isDisabled;

  /// Fixed white or black colors for buttons over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  /// Focuses the button as soon as it is shown.
  final bool isAutoFocus;

  /// Called with the new value when the button is tapped.
  final ValueChanged<bool>? onChanged;

  const SpectrumToggleButton({
    super.key,
    this.child,
    this.icon,
    this.isSelected = false,
    this.isEmphasized = false,
    this.isQuiet = false,
    this.isDisabled = false,
    this.staticColor,
    this.isAutoFocus = false,
    this.onChanged,
  }) : assert(child != null || icon != null);

  /// Returns the selection of the action button inside a toggle button, or null
  /// when the action button is not a toggle button.
  static ({bool isSelected, bool isEmphasized})? stateOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ToggleButtonScope>();

    if (scope == null) {
      return null;
    }

    return (isSelected: scope.isSelected, isEmphasized: scope.isEmphasized);
  }

  @override
  State<SpectrumToggleButton> createState() => _SpectrumToggleButtonState();
}

/// Keeps the selection of a toggle button that is not inside a group.
class _SpectrumToggleButtonState extends State<SpectrumToggleButton> {
  /// Whether the button is selected, changed on every tap.
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant SpectrumToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes isSelected, the button follows it.
    if (oldWidget.isSelected != widget.isSelected) {
      _isSelected = widget.isSelected;
    }
  }

  /// Inside a SpectrumToggleButtonGroup, the group selects the button. Otherwise
  /// the button toggles itself and tells the parent.
  void _handleTap() {
    final group = SpectrumToggleButtonGroup.buttonOf(context);

    if (group != null) {
      group.onToggle();
    } else {
      setState(() => _isSelected = !_isSelected);
      widget.onChanged?.call(_isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = SpectrumToggleButtonGroup.buttonOf(context);

    // As in Spectrum 2, the toggle button is an action button with a selected state,
    // shared through the scope, so both keep the same sizes, colors and animations.
    return _ToggleButtonScope(
      isSelected: group?.isSelected ?? _isSelected,
      isEmphasized: widget.isEmphasized || (group?.isEmphasized ?? false),
      child: SpectrumActionButton(
        icon: widget.icon,
        isQuiet: widget.isQuiet,
        isDisabled: widget.isDisabled,
        staticColor: widget.staticColor,
        isAutoFocus: widget.isAutoFocus,
        onTap: _handleTap,
        child: widget.child,
      ),
    );
  }
}

/// Shares the selection of the toggle button with its action button.
class _ToggleButtonScope extends InheritedWidget {
  final bool isSelected;
  final bool isEmphasized;

  const _ToggleButtonScope({required this.isSelected, required this.isEmphasized, required super.child});

  @override
  bool updateShouldNotify(_ToggleButtonScope oldWidget) {
    return oldWidget.isSelected != isSelected || oldWidget.isEmphasized != isEmphasized;
  }
}
