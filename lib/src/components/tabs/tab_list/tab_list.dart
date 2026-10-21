import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tab List: the row (or column) of SpectrumTab of a SpectrumTabs, with
/// the line that slides to the selected tab.
class SpectrumTabList extends StatefulWidget {
  /// Tabs of the list.
  final List<SpectrumTab> children;

  const SpectrumTabList({super.key, required this.children});

  /// Returns the index of the tab inside a list, or null outside of one.
  static int? indexOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TabIndexScope>()?.index;
  }

  @override
  State<SpectrumTabList> createState() => _SpectrumTabListState();
}

/// Keeps the position of the selected tab, so the line can slide to it.
class _SpectrumTabListState extends State<SpectrumTabList> {
  /// Position of the selected tab inside the list, measured after each layout.
  Rect? _indicator;

  /// Key of the stack that holds the line and the tabs.
  final GlobalKey _stackKey = GlobalKey();

  /// Keys of the tabs, to measure the selected one.
  final List<GlobalKey> _tabKeys = [];

  /// Measures the selected tab after the layout and moves the line to it.
  void _measure(Duration timeStamp) {
    final selected = SpectrumTabs.of(context)?.selected ?? 0;

    if (!mounted || selected >= _tabKeys.length) {
      return;
    }

    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    final tab = _tabKeys[selected].currentContext?.findRenderObject() as RenderBox?;

    if (stack == null || tab == null) {
      return;
    }

    final rect = tab.localToGlobal(Offset.zero, ancestor: stack) & tab.size;

    if (rect != _indicator) {
      setState(() => _indicator = rect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tabs = SpectrumTabs.of(context);
    final isVertical = tabs?.orientation == Axis.vertical;
    final isDisabled = tabs?.isDisabled ?? false;
    final indicator = _indicator;

    while (_tabKeys.length < widget.children.length) {
      _tabKeys.add(GlobalKey());
    }

    // The line follows the selected tab after every layout.
    WidgetsBinding.instance.addPostFrameCallback(_measure);

    final children = [
      for (final (index, tab) in widget.children.indexed)
        _TabIndexScope(
          index: index,
          child: KeyedSubtree(key: _tabKeys[index], child: tab),
        ),
    ];

    final Rect line;

    if (indicator == null) {
      line = Rect.zero;
    } else if (isVertical) {
      // When the tabs are vertical, the 2px line is on their left, 12px away.
      line = Rect.fromLTWH(indicator.left - 12, indicator.top, 2, indicator.height);
    } else {
      // Otherwise the 2px line is at the bottom of the selected tab.
      line = Rect.fromLTWH(indicator.left, indicator.bottom - 2, indicator.width, 2);
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Stack(
        key: _stackKey,
        clipBehavior: Clip.none,
        children: [
          Flex(
            direction: isVertical ? Axis.vertical : Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // Spectrum 2 gap between the tabs: 32px, or 24px when compact.
            spacing: isVertical ? 0 : ((tabs?.isCompact ?? false) ? 24 : 32),
            children: children,
          ),
          // Spectrum 2 selection line: 2px, gray-800, sliding in 200ms.
          Visibility(
            visible: indicator != null,
            child: AnimatedPositioned.fromRect(
              rect: line,
              duration: const Duration(milliseconds: 200),
              curve: SpectrumMotion.easeOut,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDisabled ? colors.outline : colors.onSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shares the index of a tab with that tab.
class _TabIndexScope extends InheritedWidget {
  final int index;

  const _TabIndexScope({required this.index, required super.child});

  @override
  bool updateShouldNotify(_TabIndexScope oldWidget) => oldWidget.index != index;
}
