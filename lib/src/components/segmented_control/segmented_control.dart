import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Segmented Control: a row of mutually exclusive options, like the
/// views of a page, with a white indicator sliding to the selected one.
class SpectrumSegmentedControl extends StatefulWidget {
  /// Options of the control, shown from left to right.
  final List<SpectrumSegmentedControlItem> children;

  /// Index of the option selected at start. When the parent changes it, the control follows.
  final int selectedIndex;

  /// Called with the index of the option selected by a tap.
  final ValueChanged<int>? onSelectionChange;

  /// Grays out every option and ignores taps.
  final bool isDisabled;

  /// Stretches the control to the available width, with options of the same width.
  final bool isJustified;

  const SpectrumSegmentedControl({
    super.key,
    required this.children,
    this.selectedIndex = 0,
    this.onSelectionChange,
    this.isDisabled = false,
    this.isJustified = false,
  });

  /// Returns the selection of the option inside a control, or null outside of one.
  static ({bool isSelected, bool isDisabled, VoidCallback onSelect})? itemOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SegmentedControlItemScope>();

    if (scope == null) {
      return null;
    }

    return (isSelected: scope.isSelected, isDisabled: scope.isDisabled, onSelect: scope.onSelect);
  }

  @override
  State<SpectrumSegmentedControl> createState() => _SpectrumSegmentedControlState();
}

/// Keeps the selected option and the position of the indicator below it.
class _SpectrumSegmentedControlState extends State<SpectrumSegmentedControl> {
  /// Index of the selected option, changed on every tap.
  int _selected = 0;

  /// Position of the selected option inside the control, measured after each layout,
  /// so the indicator can slide to it. Null until the first measure.
  Rect? _indicator;

  /// Key of the stack that holds the indicator and the options.
  final GlobalKey _stackKey = GlobalKey();

  /// Keys of the options, to measure the selected one.
  final List<GlobalKey> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant SpectrumSegmentedControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes selectedIndex, the control follows it.
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selected = widget.selectedIndex;
    }
  }

  void _handleSelect(int index) {
    if (index != _selected) {
      setState(() => _selected = index);
      widget.onSelectionChange?.call(index);
    }
  }

  /// Measures the selected option after the layout and moves the indicator to it.
  void _measure(Duration timeStamp) {
    if (!mounted || _selected >= _itemKeys.length) {
      return;
    }

    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final item = _itemKeys[_selected].currentContext?.findRenderObject() as RenderBox?;

    if (stack == null || item == null) {
      return;
    }

    final rect = item.localToGlobal(Offset.zero, ancestor: stack) & item.size;

    if (rect != _indicator) {
      setState(() => _indicator = rect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    while (_itemKeys.length < widget.children.length) {
      _itemKeys.add(GlobalKey());
    }

    // The indicator follows the selected option after every layout, as the
    // options can change their width.
    WidgetsBinding.instance.addPostFrameCallback(_measure);

    final items = <Widget>[];

    for (final (index, child) in widget.children.indexed) {
      // Each option receives if it is selected and how to select itself.
      final item = _SegmentedControlItemScope(
        isSelected: index == _selected,
        isDisabled: widget.isDisabled,
        onSelect: () => _handleSelect(index),
        child: KeyedSubtree(key: _itemKeys[index], child: child),
      );

      if (widget.isJustified) {
        // When isJustified is True, the options share the width equally.
        items.add(Expanded(child: item));
      } else {
        // Otherwise each option keeps the width of its content.
        items.add(item);
      }
    }

    final indicator = _indicator;

    // Tells screen readers that the options are mutually exclusive.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      // Spectrum 2 segmented control: gray-100 background with 8px corners.
      child: Container(
        decoration: BoxDecoration(color: colors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
        child: Stack(
          key: _stackKey,
          children: [
            // Spectrum 2 selection indicator: gray-25 with a 2px gray-900 border and
            // 10px corners, sliding to the selected option in 200ms.
            Visibility(
              visible: indicator != null,
              child: AnimatedPositioned.fromRect(
                rect: indicator ?? Rect.zero,
                duration: const Duration(milliseconds: 200),
                curve: SpectrumMotion.easeOut,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: widget.isDisabled ? colors.outline : colors.inverseSurface, width: 2),
                  ),
                ),
              ),
            ),
            Row(mainAxisSize: widget.isJustified ? MainAxisSize.max : MainAxisSize.min, spacing: 4, children: items),
          ],
        ),
      ),
    );
  }
}

/// Shares the selection of one option with that option.
class _SegmentedControlItemScope extends InheritedWidget {
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onSelect;

  const _SegmentedControlItemScope({
    required this.isSelected,
    required this.isDisabled,
    required this.onSelect,
    required super.child,
  });

  @override
  bool updateShouldNotify(_SegmentedControlItemScope oldWidget) {
    return oldWidget.isSelected != isSelected || oldWidget.isDisabled != isDisabled;
  }
}
