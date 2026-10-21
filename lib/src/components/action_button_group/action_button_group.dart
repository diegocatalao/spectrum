import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Action Button Group: places related action buttons side by side
/// (or stacked) and shares the quiet, disabled and static color options with them.
class SpectrumActionButtonGroup extends StatelessWidget {
  /// The buttons of the group, usually SpectrumActionButton or SpectrumToggleButton.
  final List<Widget> children;

  /// Direction of the buttons, horizontal by default.
  final Axis axis;

  /// Compact keeps 2px between the buttons, standard keeps 8px.
  final VisualDensity density;

  /// Fixed white or black colors applied to every button of the group,
  /// for groups over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  /// Makes every button of the group quiet.
  final bool isQuiet;

  /// Disables every button of the group.
  final bool isDisabled;

  const SpectrumActionButtonGroup({
    super.key,
    this.children = const [],
    this.axis = Axis.horizontal,
    this.density = VisualDensity.standard,
    this.staticColor,
    this.isQuiet = false,
    this.isDisabled = false,
  });

  /// Returns True when the widget is inside a quiet group.
  static bool isQuietOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionButtonGroupScope>()?.isQuiet ?? false;
  }

  /// Returns True when the widget is inside a disabled group.
  static bool isDisabledOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionButtonGroupScope>()?.isDisabled ?? false;
  }

  /// Returns the corners of the button inside a compact group,
  /// or null when the button keeps its own rounded corners.
  static BorderRadius? borderRadiusOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionButtonGroupCornerScope>()?.borderRadius;
  }

  /// Rounds only the outer corners of the first and the last button,
  /// following the axis of the group, so a compact group looks like one piece.
  BorderRadius _cornersOf(int index) {
    const radius = Radius.circular(8);
    final isFirst = index == 0;
    final isLast = index == children.length - 1;
    final BorderRadius corners;

    if (isFirst && isLast) {
      // When the group has a single button, all its corners are rounded.
      corners = const BorderRadius.all(radius);
    } else if (isFirst && axis == Axis.horizontal) {
      // When the button is the first of a row, only its left corners are rounded.
      corners = const BorderRadius.horizontal(left: radius);
    } else if (isLast && axis == Axis.horizontal) {
      // When the button is the last of a row, only its right corners are rounded.
      corners = const BorderRadius.horizontal(right: radius);
    } else if (isFirst) {
      // When the button is the first of a column, only its top corners are rounded.
      corners = const BorderRadius.vertical(top: radius);
    } else if (isLast) {
      // When the button is the last of a column, only its bottom corners are rounded.
      corners = const BorderRadius.vertical(bottom: radius);
    } else {
      // Otherwise the button is in the middle and keeps square corners.
      corners = BorderRadius.zero;
    }

    return corners;
  }

  /// Returns the static color of the group, or null when it has none.
  static SpectrumStaticColor? staticColorOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionButtonGroupScope>()?.staticColor;
  }

  @override
  Widget build(BuildContext context) {
    final double spacing;
    final List<Widget> buttons;

    if (density == VisualDensity.compact) {
      // When density is compact, the buttons keep only 2px between them
      // and only the outer corners of the group are rounded, so the
      // middle buttons are square, as the compact Spectrum 2 group.
      spacing = 2;
      buttons = children.indexed.map((e) {
        return _ActionButtonGroupCornerScope(borderRadius: _cornersOf(e.$1), child: e.$2);
      }).toList();
    } else {
      // Otherwise the buttons keep the regular 8px gap of the M size
      // and their own rounded corners.
      spacing = 8;
      buttons = children;
    }

    // Flexible lets each button shrink with an ellipsis when the parent
    // is narrower than their contents, instead of overflowing.
    final items = [for (final button in buttons) Flexible(child: button)];

    // The scope lets every SpectrumActionButton inside read the group options,
    // and Flex places the buttons in a row or in a column following the axis.
    return _ActionButtonGroupScope(
      isQuiet: isQuiet,
      isDisabled: isDisabled,
      staticColor: staticColor,
      child: Flex(
        direction: axis,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing,
        children: items,
      ),
    );
  }
}

/// Shares the group options with the action buttons below it in the tree.
class _ActionButtonGroupScope extends InheritedWidget {
  final bool isQuiet;
  final bool isDisabled;
  final SpectrumStaticColor? staticColor;

  const _ActionButtonGroupScope({
    required this.isQuiet,
    required this.isDisabled,
    required this.staticColor,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ActionButtonGroupScope oldWidget) {
    return oldWidget.isQuiet != isQuiet || oldWidget.isDisabled != isDisabled || oldWidget.staticColor != staticColor;
  }
}

/// Shares the corners of one button of a compact group with that button.
class _ActionButtonGroupCornerScope extends InheritedWidget {
  final BorderRadius borderRadius;

  const _ActionButtonGroupCornerScope({required this.borderRadius, required super.child});

  @override
  bool updateShouldNotify(_ActionButtonGroupCornerScope oldWidget) => oldWidget.borderRadius != borderRadius;
}
