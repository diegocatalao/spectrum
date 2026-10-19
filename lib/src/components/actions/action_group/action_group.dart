import 'package:flutter/material.dart';

import 'package:spectrum/src/components/actions/selects.dart';

/// Spectrum Action Group: places action buttons side by side (or stacked),
/// passes shared options down to them and can manage their selection.
class SpectrumActionGroup extends StatelessWidget {
  /// The action buttons of the group.
  final List<Widget> children;

  /// Makes every action button inside the group quiet.
  final bool isQuiet;

  /// Makes every action button inside the group use the accent blue when selected.
  final bool isEmphasized;

  /// Stacks the buttons in a column instead of a row.
  final bool isVertical;

  /// Stretches the buttons to fill the available width.
  final bool isJustified;

  /// Removes the gap between the buttons and keeps only the outer corners
  /// of the group rounded, joining the buttons in one block.
  final bool isCompact;

  /// How the group manages the selection. With none, each button behaves on its own.
  final SpectrumSelects selects;

  /// Indexes of the selected buttons, used when selects is single or multiple.
  final List<int> selected;

  /// Called with the new selected indexes when the user taps a button.
  final ValueChanged<List<int>>? onChanged;

  /// Text read by screen readers to describe the group.
  final String? label;

  const SpectrumActionGroup({
    super.key,
    this.children = const [],
    this.isQuiet = false,
    this.isEmphasized = false,
    this.isVertical = false,
    this.isJustified = false,
    this.isCompact = false,
    this.selects = SpectrumSelects.none,
    this.selected = const [],
    this.onChanged,
    this.label,
  });

  /// Returns True when the widget is inside a quiet group.
  static bool isQuietOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionGroupScope>()?.isQuiet ?? false;
  }

  /// Returns True when the widget is inside an emphasized group.
  static bool isEmphasizedOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionGroupScope>()?.isEmphasized ?? false;
  }

  /// Returns the corners of the button inside a compact group,
  /// or null when the button keeps its own rounded corners.
  static BorderRadius? borderRadiusOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ActionGroupCornerScope>()?.borderRadius;
  }

  /// Returns the selection of the button inside a group with selection,
  /// or null when the group does not manage the selection.
  static ({bool selected, VoidCallback onSelect})? itemOf(BuildContext context) {
    final item = context.dependOnInheritedWidgetOfExactType<_ActionGroupItemScope>();
    if (item == null) return null;
    return (selected: item.selected, onSelect: item.onSelect);
  }

  /// In multiple, the tap adds or removes the index from the selection.
  /// In single, the tapped index becomes the only selected one, and tapping
  /// it again keeps it selected, as a radio button.
  void _select(int index) {
    if (selects == SpectrumSelects.multiple && selected.contains(index)) {
      onChanged?.call([...selected]..remove(index));
    } else if (selects == SpectrumSelects.multiple) {
      onChanged?.call([...selected, index]);
    } else {
      onChanged?.call([index]);
    }
  }

  /// Rounds only the outer corners of the first and the last button,
  /// following the direction of the group.
  BorderRadius _cornersOf(int index) {
    const radius = Radius.circular(8);
    final isFirst = index == 0;
    final isLast = index == children.length - 1;

    if (isVertical) {
      return BorderRadius.vertical(
        top: isFirst ? radius : Radius.zero,
        bottom: isLast ? radius : Radius.zero,
      );
    } else {
      return BorderRadius.horizontal(
        left: isFirst ? radius : Radius.zero,
        right: isLast ? radius : Radius.zero,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (final (index, child) in children.indexed) {
      Widget item = child;

      // When the group has a selection, each button receives if it is
      // selected and how to select itself. In single selection, screen
      // readers also announce the buttons as mutually exclusive.
      if (selects != SpectrumSelects.none) {
        item = _ActionGroupItemScope(
          selected: selected.contains(index),
          onSelect: () => _select(index),
          child: Semantics(inMutuallyExclusiveGroup: selects == SpectrumSelects.single, child: item),
        );
      }

      // When isCompact is True, the buttons are joined in one block, even when
      // quiet: the first and the last keep the outer rounded corners and every
      // corner between two buttons becomes square, so hover and selection fit together.
      if (isCompact) {
        item = _ActionGroupCornerScope(borderRadius: _cornersOf(index), child: item);
      }

      // Horizontal and justified: every button takes the same share of the row.
      if (isJustified && !isVertical) {
        items.add(Expanded(child: item));
      } else {
        items.add(item);
      }
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      child: _ActionGroupScope(
        isQuiet: isQuiet,
        isEmphasized: isEmphasized,
        child: Flex(
          direction: isVertical ? Axis.vertical : Axis.horizontal,
          spacing: isCompact ? 0 : 8,
          // Horizontal and justified fills the row. Vertical and justified
          // stretches the buttons to the column width instead.
          mainAxisSize: isJustified && !isVertical ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: isJustified && isVertical ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
          children: items,
        ),
      ),
    );
  }
}

/// Shares the group options with the action buttons below it in the tree,
/// as the sp-action-group does with its children on the web.
class _ActionGroupScope extends InheritedWidget {
  final bool isQuiet;
  final bool isEmphasized;

  const _ActionGroupScope({required this.isQuiet, required this.isEmphasized, required super.child});

  @override
  bool updateShouldNotify(_ActionGroupScope oldWidget) {
    return oldWidget.isQuiet != isQuiet || oldWidget.isEmphasized != isEmphasized;
  }
}

/// Shares the selection of one button of the group with that button.
class _ActionGroupItemScope extends InheritedWidget {
  final bool selected;
  final VoidCallback onSelect;

  const _ActionGroupItemScope({required this.selected, required this.onSelect, required super.child});

  @override
  bool updateShouldNotify(_ActionGroupItemScope oldWidget) => oldWidget.selected != selected;
}

/// Shares the corners of one button of a compact group with that button.
class _ActionGroupCornerScope extends InheritedWidget {
  final BorderRadius borderRadius;

  const _ActionGroupCornerScope({required this.borderRadius, required super.child});

  @override
  bool updateShouldNotify(_ActionGroupCornerScope oldWidget) => oldWidget.borderRadius != borderRadius;
}
