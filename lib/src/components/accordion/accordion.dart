import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Accordion: a list of items that expand or collapse to
/// reveal the content associated with each one.
class SpectrumAccordion extends StatefulWidget {
  /// Items of the accordion, shown in order from top to bottom. Each one is a
  /// SpectrumDisclosure whose expansion is decided by the accordion.
  final List<SpectrumAccordionItem> items;

  /// Vertical and horizontal compactness passed to every item.
  final VisualDensity density;

  /// Allows more than one item to be expanded at the same time.
  final bool allowMultiple;

  /// Removes the dividers of every item and the top divider.
  final bool isQuiet;

  /// Grays out every item and ignores hover and tap.
  final bool isDisabled;

  /// Called when an item is expanded or collapsed, with its index.
  final void Function(int index, bool expanded)? onExpansionChange;

  const SpectrumAccordion({
    super.key,
    required this.items,
    this.density = VisualDensity.standard,
    this.allowMultiple = false,
    this.isQuiet = false,
    this.isDisabled = false,
    this.onExpansionChange,
  });

  /// Returns the expansion and the shared options of the item inside an
  /// accordion, or null when the disclosure is on its own.
  static ({bool isExpanded, bool isQuiet, bool isDisabled, VisualDensity density, VoidCallback onToggle})? itemOf(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AccordionItemScope>();

    if (scope == null) {
      return null;
    }

    return (
      isExpanded: scope.isExpanded,
      isQuiet: scope.isQuiet,
      isDisabled: scope.isDisabled,
      density: scope.density,
      onToggle: scope.onToggle,
    );
  }

  @override
  State<SpectrumAccordion> createState() => _SpectrumAccordionState();
}

/// Keeps which items are expanded and rebuilds them on every tap.
class _SpectrumAccordionState extends State<SpectrumAccordion> {
  /// Indexes of the expanded items. It starts with the items created with
  /// isExpanded and is changed by _handleToggle, so the accordion controls
  /// the expansion instead of each item.
  final Set<int> _opened = {};

  @override
  void initState() {
    super.initState();

    final expandeds = widget.items.indexed.where((e) => e.$2.isExpanded).map((e) => e.$1);

    if (widget.allowMultiple) {
      // When allowMultiple is True, every item created with isExpanded
      // starts expanded, so the accordion can open with many items
      // already showing their content.
      _opened.addAll(expandeds);
    } else {
      // When allowMultiple is False, only the first item created with
      // isExpanded starts expanded, and the others are ignored to keep
      // a single item open at a time.
      _opened.addAll(expandeds.take(1));
    }
  }

  /// Expands or collapses the item at index, rebuilds the accordion and
  /// calls onExpansionChange for every item whose expansion changed.
  void _handleToggle(int index) {
    final Set<int> collapsed;

    if (_opened.contains(index)) {
      // When the item is already expanded, the tap collapses it
      // and the other items keep their current state.
      collapsed = {index};
    } else if (widget.allowMultiple) {
      // When allowMultiple is True, the tap expands the item
      // and the other expanded items stay open.
      collapsed = {};
    } else {
      // When allowMultiple is False, every other expanded item is
      // collapsed before expanding this one, so only one item stays open.
      collapsed = Set.of(_opened);
    }

    setState(() {
      _opened.removeAll(collapsed);
      if (!collapsed.contains(index)) _opened.add(index);
    });

    // The collapsed items are told first and the tapped one last, so the
    // parent always ends with the state shown on the screen.
    for (final item in collapsed.difference({index})) {
      widget.onExpansionChange?.call(item, false);
    }

    widget.onExpansionChange?.call(index, !collapsed.contains(index));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The top divider closes the list from above, since each item only
        // draws the divider below itself. When isQuiet is True, there are no
        // dividers, so the top one is not added either.
        Visibility(visible: !widget.isQuiet, child: const SpectrumDivider()),
        ...List.generate(widget.items.length, (int index) {
          // Each item receives the expansion kept by the accordion and the
          // options of the accordion, which apply together with its own.
          return _AccordionItemScope(
            isExpanded: _opened.contains(index),
            isQuiet: widget.isQuiet,
            isDisabled: widget.isDisabled,
            density: widget.density,
            onToggle: () => _handleToggle(index),
            child: widget.items[index],
          );
        }),
      ],
    );
  }
}

/// Shares the expansion of one item and the options of the accordion with that item.
class _AccordionItemScope extends InheritedWidget {
  final bool isExpanded;
  final bool isQuiet;
  final bool isDisabled;
  final VisualDensity density;
  final VoidCallback onToggle;

  const _AccordionItemScope({
    required this.isExpanded,
    required this.isQuiet,
    required this.isDisabled,
    required this.density,
    required this.onToggle,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AccordionItemScope oldWidget) {
    return oldWidget.isExpanded != isExpanded ||
        oldWidget.isQuiet != isQuiet ||
        oldWidget.isDisabled != isDisabled ||
        oldWidget.density != density;
  }
}
