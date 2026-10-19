import 'package:flutter/material.dart';

import 'package:spectrum/src/utils/selects.dart';

/// Spectrum Menu Group: a section of a menu, with an optional bold title
/// above its options, that can manage the selection of its items.
class SpectrumMenuGroup extends StatelessWidget {
  /// Title of the section.
  final Text? header;

  /// How the group manages the selection. With single or multiple, every item
  /// keeps the space of the checkmark, so the texts stay aligned.
  final SpectrumSelects selects;

  /// Indexes of the selected items, used when selects is single or multiple.
  final List<int> selected;

  /// Called with the new selected indexes when the user taps an item.
  final ValueChanged<List<int>>? onChanged;

  /// Options of the section, usually SpectrumMenuItem.
  final List<Widget> children;

  const SpectrumMenuGroup({
    super.key,
    this.header,
    this.selects = SpectrumSelects.none,
    this.selected = const [],
    this.onChanged,
    this.children = const [],
  });

  /// Returns the selection of the item inside a group with selection,
  /// or null when the group does not manage the selection.
  static ({bool selected, VoidCallback onSelect})? itemOf(BuildContext context) {
    final item = context.dependOnInheritedWidgetOfExactType<_MenuGroupItemScope>();
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = <Widget>[];

    for (final (index, child) in children.indexed) {
      // When the group has a selection, each item receives if it is selected
      // and how to select itself. In single selection, screen readers also
      // announce the items as mutually exclusive.
      if (selects == SpectrumSelects.none) {
        items.add(child);
      } else {
        items.add(
          _MenuGroupItemScope(
            selected: selected.contains(index),
            onSelect: () => _select(index),
            child: Semantics(inMutuallyExclusiveGroup: selects == SpectrumSelects.single, child: child),
          ),
        );
      }
    }

    return Semantics(
      container: true,
      label: header?.data,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Spectrum section header: 14px bold gray-900 text, aligned with
          // the text of the options, 12px from the left edge.
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: DefaultTextStyle.merge(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.inverseSurface,
                ),
                child: ExcludeSemantics(child: header!),
              ),
            ),
          ...items,
        ],
      ),
    );
  }
}

/// Shares the selection of one item of the group with that item.
class _MenuGroupItemScope extends InheritedWidget {
  final bool selected;
  final VoidCallback onSelect;

  const _MenuGroupItemScope({required this.selected, required this.onSelect, required super.child});

  @override
  bool updateShouldNotify(_MenuGroupItemScope oldWidget) => oldWidget.selected != selected;
}
