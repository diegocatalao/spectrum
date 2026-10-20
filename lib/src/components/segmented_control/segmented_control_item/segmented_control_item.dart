import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Segmented Control Item: one option of a SpectrumSegmentedControl,
/// with an icon, a text or both.
class SpectrumSegmentedControlItem extends StatefulWidget {
  /// Text of the option.
  final Text? child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Grays out the option and ignores taps.
  final bool isDisabled;

  const SpectrumSegmentedControlItem({super.key, this.child, this.icon, this.isDisabled = false})
    : assert(child != null || icon != null);

  @override
  State<SpectrumSegmentedControlItem> createState() => _SpectrumSegmentedControlItemState();
}

/// Keeps the press and focus states of the option.
class _SpectrumSegmentedControlItemState extends State<SpectrumSegmentedControlItem> {
  /// Press state, kept for the press scale animation.
  bool _isPressed = false;

  /// Focus state, kept to draw the focus ring only for keyboard navigation.
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final control = SpectrumSegmentedControl.itemOf(context);
    final isSelected = control?.isSelected ?? false;
    final isDisabled = widget.isDisabled || (control?.isDisabled ?? false);
    final Color content;

    if (isDisabled) {
      // When isDisabled is True, the option turns gray-400.
      content = colors.outline;
    } else if (isSelected) {
      // When the option is selected, it gets the default text color (gray-800).
      content = colors.onSurface;
    } else {
      // Otherwise the option is a lighter gray (gray-700).
      content = colors.onSurfaceVariant;
    }

    final Widget? text;

    if (widget.child != null) {
      // When there is a text, it is Flexible so it can shrink with an ellipsis.
      text = Flexible(child: widget.child!);
    } else {
      // Otherwise nothing is added, since an empty child would still receive the spacing.
      text = null;
    }

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // Tells screen readers that this is one of mutually exclusive options.
    return Semantics(
      button: true,
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      enabled: !isDisabled,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Spectrum 2 "press scale": the option shrinks a little while pressed.
          SpectrumPressScale(
            isPressed: _isPressed,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                // When isDisabled is True the tap is null and the option can not be focused.
                onTap: isDisabled ? null : control?.onSelect,
                onHighlightChanged: (value) => setState(() => _isPressed = value),
                onFocusChange: (value) => setState(() => _isFocused = value),
                // Spectrum 2 option: 32px high, 12px from the edges, with the icon
                // 6px before the text, in one line.
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    widthFactor: 1,
                    child: IconTheme.merge(
                      data: IconThemeData(color: content),
                      child: DefaultTextStyle(
                        style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: content),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        child: Row(mainAxisSize: MainAxisSize.min, spacing: 6, children: [?widget.icon, ?text]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Spectrum focus indicator: a 2px ring with a 2px gap around the option.
          Positioned(
            left: -4,
            top: -4,
            right: -4,
            bottom: -4,
            child: IgnorePointer(
              child: Visibility(
                visible: showFocusRing,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.spectrum.focusIndicator, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
