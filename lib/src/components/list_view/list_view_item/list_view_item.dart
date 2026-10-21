import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum List View Item: one item of a SpectrumListView, with an optional icon or
/// image, a label, a description and actions on the right.
class SpectrumListViewItem extends StatefulWidget {
  /// Label of the item.
  final Text child;

  /// Text below the label.
  final Text? description;

  /// Icon shown on the left of the label.
  final SpectrumIcon? icon;

  /// Small picture shown on the left of the label, in place of the icon.
  final Widget? image;

  /// Widgets on the right, like a quiet SpectrumActionMenu or a SpectrumActionButtonGroup.
  final Widget? actions;

  /// Grays out the item and ignores taps.
  final bool isDisabled;

  const SpectrumListViewItem({
    super.key,
    required this.child,
    this.description,
    this.icon,
    this.image,
    this.actions,
    this.isDisabled = false,
  });

  @override
  State<SpectrumListViewItem> createState() => _SpectrumListViewItemState();
}

/// Keeps the hover, press and focus states of the item.
class _SpectrumListViewItemState extends State<SpectrumListViewItem> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final list = SpectrumListView.itemOf(context);
    final isSelected = list?.isSelected ?? false;
    final isDisabled = widget.isDisabled || (list?.isDisabled ?? false);
    final isCheckbox =
        list?.selects != SpectrumSelects.none &&
        list?.selects != null &&
        list?.selectionStyle == SpectrumListSelectionStyle.checkbox;
    final isHighlight = list?.selectionStyle == SpectrumListSelectionStyle.highlight;
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final separator = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
    final Color background, content;

    if (isDisabled) {
      // When the item is disabled, it is gray-400 without background.
      background = Colors.transparent;
      content = colors.outline;
    } else if (isSelected && isHighlight) {
      // When the highlight style is selected, the item is a light blue, stronger on hover.
      background = colors.primary.withValues(alpha: _isHovered || _isPressed ? 0.15 : 0.1);
      content = colors.onSurface;
    } else if (isSelected) {
      // When the item is selected with checkboxes, it is a light gray, stronger on hover.
      background = colors.inverseSurface.withValues(alpha: _isHovered || _isPressed ? 0.1 : 0.07);
      content = colors.onSurface;
    } else if (_isPressed) {
      background = colors.inverseSurface.withValues(alpha: 0.1);
      content = colors.onSurfaceVariant;
    } else if (_isHovered) {
      // A hovered item shows a 5% gray-900 background.
      background = colors.inverseSurface.withValues(alpha: 0.05);
      content = colors.onSurfaceVariant;
    } else {
      // Otherwise the item is gray-700 text over nothing.
      background = Colors.transparent;
      content = colors.onSurfaceVariant;
    }

    // The separator is hidden on the last item and between selected items.
    final hasSeparator = !(list?.isLast ?? true) && !isSelected && !(list?.isNextSelected ?? false);

    final Widget? leading;

    if (widget.image != null) {
      leading = ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox.square(dimension: 32, child: widget.image),
      );
    } else if (widget.icon != null) {
      leading = IconTheme.merge(
        data: IconThemeData(color: content),
        child: widget.icon!,
      );
    } else {
      leading = null;
    }

    final Widget? checkbox;

    if (isCheckbox) {
      // With checkboxes, every item shows its box at the start.
      checkbox = IgnorePointer(
        child: ExcludeSemantics(
          child: SpectrumCheckbox(isSelected: isSelected, isDisabled: isDisabled),
        ),
      );
    } else {
      checkbox = null;
    }

    // Tells screen readers that this is an item of the list and if it is selected.
    return Semantics(
      button: true,
      selected: isSelected,
      enabled: !isDisabled,
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: isDisabled ? null : list?.onTap,
        onHover: (value) => setState(() => _isHovered = value),
        onHighlightChanged: (value) => setState(() => _isPressed = value),
        onFocusChange: (value) => setState(() => _isFocused = value),
        // Spectrum 2 item: at least 40px high, 8px above and below, 12px from the
        // start, with a 1px gray-300 separator below it.
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 6, 8),
          decoration: BoxDecoration(
            color: background,
            border: Border(
              bottom: BorderSide(color: hasSeparator && !(list?.isQuiet ?? false) ? separator : Colors.transparent),
            ),
          ),
          foregroundDecoration: BoxDecoration(
            border: showFocusRing
                ? Border.all(color: SpectrumThemeExtension.of(context).focusIndicator, width: 2)
                : null,
          ),
          child: Row(
            spacing: 8,
            children: [
              ?checkbox,
              ?leading,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 1,
                  children: [
                    DefaultTextStyle(
                      style: style.copyWith(color: content),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: widget.child,
                    ),
                    Visibility(
                      visible: widget.description != null,
                      child: DefaultTextStyle(
                        style: style.copyWith(
                          fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                          color: isDisabled ? colors.outline : colors.onSurfaceVariant,
                        ),
                        child: widget.description ?? const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(visible: widget.actions != null, child: widget.actions ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
