import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tab: one tab of a SpectrumTabList, with an icon, a text or both.
class SpectrumTab extends StatefulWidget {
  /// Text of the tab.
  final Text? child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Grays out the tab and ignores taps.
  final bool isDisabled;

  const SpectrumTab({super.key, this.child, this.icon, this.isDisabled = false})
    : assert(child != null || icon != null);

  @override
  State<SpectrumTab> createState() => _SpectrumTabState();
}

/// Keeps the hover and focus states of the tab.
class _SpectrumTabState extends State<SpectrumTab> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tabs = SpectrumTabs.of(context);
    final index = SpectrumTabList.indexOf(context) ?? 0;
    final isSelected = tabs?.selected == index;
    final isDisabled = widget.isDisabled || (tabs?.isDisabled ?? false);
    final Color content;

    if (isDisabled) {
      // When isDisabled is True, the tab turns gray-400.
      content = colors.outline;
    } else if (isSelected || _isHovered) {
      // When the tab is selected or hovered, it gets the default text color (gray-800).
      content = colors.onSurface;
    } else {
      // Otherwise the tab is a lighter gray (gray-700).
      content = colors.onSurfaceVariant;
    }

    final Widget? text;

    if (widget.child != null) {
      text = widget.child;
    } else {
      // Without a text, nothing is added, so the icon is not pushed by the spacing.
      text = null;
    }

    // The focus ring is only shown for keyboard navigation.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // Tells screen readers that this is a tab and if it is selected.
    return Semantics(
      button: true,
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      enabled: !isDisabled,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: isDisabled ? null : () => tabs?.onSelect(index),
        onHover: (value) => setState(() => _isHovered = value),
        onFocusChange: (value) => setState(() => _isFocused = value),
        // Spectrum 2 tab: 48px high, or 32px when compact, with the icon 6px
        // before the text and 4px corners for the focus ring.
        child: Container(
          height: (tabs?.isCompact ?? false) ? 32 : 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: showFocusRing ? context.spectrum.focusIndicator : Colors.transparent, width: 2),
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: content),
            child: DefaultTextStyle(
              style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: content),
              maxLines: 1,
              child: Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: [?widget.icon, ?text]),
            ),
          ),
        ),
      ),
    );
  }
}
