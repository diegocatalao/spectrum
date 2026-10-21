import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tree View Item: one item of a SpectrumTreeView, with a chevron that
/// expands its nested items, an optional icon and actions.
class SpectrumTreeViewItem extends StatefulWidget {
  /// Id of the item, used for the selection.
  final Object id;

  /// Text of the item.
  final Text child;

  /// Icon shown before the text.
  final SpectrumIcon? icon;

  /// Widgets on the right, like a quiet SpectrumActionMenu.
  final Widget? actions;

  /// Nested items, shown below the item when it is expanded.
  final List<SpectrumTreeViewItem> children;

  /// Whether the nested items start expanded.
  final bool isExpanded;

  /// Grays out the item and ignores taps.
  final bool isDisabled;

  const SpectrumTreeViewItem({
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
  State<SpectrumTreeViewItem> createState() => _SpectrumTreeViewItemState();
}

class _SpectrumTreeViewItemState extends State<SpectrumTreeViewItem> {
  bool _isExpanded = false;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tree = SpectrumTreeView.itemOf(context);
    final level = tree?.level ?? 0;
    final isSelected = tree?.selected.contains(widget.id) ?? false;
    final isDisabled = widget.isDisabled || (tree?.isDisabled ?? false);
    final hasChildren = widget.children.isNotEmpty;
    final isMultiple = tree?.selects == SpectrumSelects.multiple;
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final Color background, content;

    if (isDisabled) {
      background = Colors.transparent;
      content = colors.outline;
    } else if (isSelected) {
      // A selected item is a light gray, stronger on hover.
      background = colors.inverseSurface.withValues(alpha: _isHovered ? 0.1 : 0.07);
      content = colors.onSurface;
    } else if (_isHovered) {
      background = colors.inverseSurface.withValues(alpha: 0.05);
      content = colors.onSurfaceVariant;
    } else {
      background = Colors.transparent;
      content = colors.onSurfaceVariant;
    }

    final row = Semantics(
      button: true,
      selected: isSelected,
      expanded: hasChildren ? _isExpanded : null,
      enabled: !isDisabled,
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: isDisabled ? null : () => tree?.onTap(widget.id),
        onHover: (value) => setState(() => _isHovered = value),
        onFocusChange: (value) => setState(() => _isFocused = value),
        // Spectrum 2 row: at least 40px high, indented 16px per level, with a 1px
        // gray-300 separator below it.
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: EdgeInsetsDirectional.only(start: 4 + level * 16.0, end: 6),
          decoration: BoxDecoration(
            color: background,
            border: Border(bottom: BorderSide(color: isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300)),
          ),
          foregroundDecoration: BoxDecoration(
            border: showFocusRing
                ? Border.all(color: SpectrumThemeExtension.of(context).focusIndicator, width: 2)
                : null,
          ),
          child: Row(
            spacing: 4,
            children: [
              // The chevron expands the nested items; items without them keep its space.
              Visibility(
                visible: hasChildren,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SpectrumActionButton(
                  icon: SpectrumIcon(_isExpanded ? SpectrumIcons.chevronDown : SpectrumIcons.chevronRight),
                  isQuiet: true,
                  isDisabled: isDisabled,
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ),
              Visibility(
                visible: isMultiple,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: SpectrumCheckbox(isSelected: isSelected, isDisabled: isDisabled),
                  ),
                ),
              ),
              Visibility(
                visible: widget.icon != null,
                child: IconTheme.merge(
                  data: IconThemeData(color: content),
                  child: widget.icon ?? const SizedBox.shrink(),
                ),
              ),
              Expanded(
                child: DefaultTextStyle(
                  style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: content),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: widget.child,
                ),
              ),
              Visibility(visible: widget.actions != null, child: widget.actions ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row,
        Visibility(
          visible: hasChildren && _isExpanded,
          child: SpectrumTreeLevel(
            level: level + 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}
