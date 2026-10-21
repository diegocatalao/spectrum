import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Side Nav Item: one item of a SpectrumSideNav, a link to a page with an
/// optional icon and actions, that can expand to show its sub items.
class SpectrumSideNavItem extends StatefulWidget {
  /// Route of the page, compared with the selectedRoute of the navigation.
  final Object id;

  /// Text of the item.
  final Text child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Widgets on the right of the item, like a quiet SpectrumActionMenu.
  final Widget? actions;

  /// Sub items, shown below the item when it is expanded.
  final List<SpectrumSideNavItem> children;

  /// Whether the sub items start expanded.
  final bool isExpanded;

  /// Grays out the item and ignores taps.
  final bool isDisabled;

  const SpectrumSideNavItem({
    super.key,
    required this.id,
    required this.child,
    this.icon,
    this.actions,
    this.children = const [],
    this.isExpanded = false,
    this.isDisabled = false,
  });

  @override
  State<SpectrumSideNavItem> createState() => _SpectrumSideNavItemState();
}

/// Keeps the expansion and the hover and focus states of the item.
class _SpectrumSideNavItemState extends State<SpectrumSideNavItem> {
  bool _isExpanded = false;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  /// Whether the current route is one of the sub items, at any depth.
  bool _hasCurrent(List<SpectrumSideNavItem> items, Object? route) {
    return items.any((item) => item.id == route || _hasCurrent(item.children, route));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final nav = SpectrumSideNav.of(context);
    final level = nav?.level ?? 0;
    final isCurrent = nav?.selectedRoute == widget.id;
    // Inside a collapsed SpectrumSideNavPanel, only the icons are shown.
    final isCollapsed = SpectrumSideNavPanel.isCollapsedOf(context);
    final hasChildren = widget.children.isNotEmpty;
    final isCurrentAncestor = _hasCurrent(widget.children, nav?.selectedRoute);
    // A collapsed item shows as current when its current sub item is hidden.
    final isMarked = isCurrent || (isCurrentAncestor && !_isExpanded);
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final Color content;

    if (widget.isDisabled) {
      // When isDisabled is True, the item is gray-400.
      content = colors.outline;
    } else if (isMarked || isCurrentAncestor) {
      // When the item is the current page, or holds it, it is gray-800.
      content = colors.onSurface;
    } else {
      // Otherwise the item is a lighter gray (gray-700).
      content = colors.onSurfaceVariant;
    }

    final Color indicator;

    if (isMarked && widget.isDisabled) {
      indicator = colors.outline;
    } else if (isMarked) {
      // The current item shows a 2px gray-800 line on its left.
      indicator = colors.onSurface;
    } else if (_isHovered && !widget.isDisabled) {
      // A hovered item shows the line in gray-400.
      indicator = colors.outline;
    } else {
      indicator = Colors.transparent;
    }

    // Spectrum 2 row: at least 32px high, 4px corners, a gray-100 background on hover,
    // 12px from the start plus 16px for each level, the bold text when current.
    final row = Semantics(
      link: true,
      label: isCollapsed ? widget.child.data : null,
      selected: isCurrent,
      expanded: hasChildren ? _isExpanded : null,
      enabled: !widget.isDisabled,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          hoverColor: colors.surfaceContainerHigh,
          highlightColor: colors.surfaceContainerHighest,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: widget.isDisabled ? null : () => nav?.onSelect?.call(widget.id),
          onHover: (value) => setState(() => _isHovered = value),
          onFocusChange: (value) => setState(() => _isFocused = value),
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: showFocusRing ? SpectrumThemeExtension.of(context).focusIndicator : Colors.transparent,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // The 18px indicator line, 4px from the start of the level.
                Positioned(
                  left: 2 + level * 16.0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 2,
                      height: 18,
                      decoration: BoxDecoration(color: indicator, borderRadius: BorderRadius.circular(1)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 10 + level * 16.0, end: 2),
                  child: Row(
                    spacing: 6,
                    children: [
                      Visibility(
                        visible: widget.icon != null,
                        child: IconTheme.merge(
                          data: IconThemeData(color: content),
                          child: widget.icon ?? const SizedBox.shrink(),
                        ),
                      ),
                      Expanded(
                        child: Visibility(
                          visible: !isCollapsed,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: DefaultTextStyle(
                              style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                                color: content,
                                fontWeight: isMarked ? FontWeight.w700 : FontWeight.w400,
                              ),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.actions != null && !isCollapsed,
                        child: widget.actions ?? const SizedBox.shrink(),
                      ),
                      // Items with sub items show a quiet chevron that expands them.
                      Visibility(
                        visible: hasChildren && !isCollapsed,
                        child: SpectrumActionButton(
                          icon: SpectrumIcon(_isExpanded ? SpectrumIcons.chevronDown : SpectrumIcons.chevronRight),
                          isQuiet: true,
                          isDisabled: widget.isDisabled,
                          onTap: () => setState(() => _isExpanded = !_isExpanded),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        row,
        // The sub items are one level deeper, shown only when the item is expanded.
        Visibility(
          visible: hasChildren && _isExpanded && !isCollapsed,
          child: SpectrumSideNavLevel(
            level: level + 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
