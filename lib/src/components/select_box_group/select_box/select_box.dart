import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Select Box: one box of a SpectrumSelectBoxGroup, with an illustration,
/// a label and, in the horizontal group, a description.
class SpectrumSelectBox extends StatefulWidget {
  /// Label of the box.
  final Text child;

  /// Text shown below the label in a horizontal group.
  final Text? description;

  /// Illustration or icon of the box, at least 48px.
  final Widget? illustration;

  /// Grays out the box and ignores taps.
  final bool isDisabled;

  const SpectrumSelectBox({
    super.key,
    required this.child,
    this.description,
    this.illustration,
    this.isDisabled = false,
  });

  @override
  State<SpectrumSelectBox> createState() => _SpectrumSelectBoxState();
}

/// Keeps the interaction states of the box.
class _SpectrumSelectBoxState extends State<SpectrumSelectBox> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final group = SpectrumSelectBoxGroup.boxOf(context);
    final isSelected = group?.isSelected ?? false;
    final isMultiple = group?.isMultiple ?? false;
    final isDisabled = widget.isDisabled || (group?.isDisabled ?? false);
    final isHorizontal = group?.orientation == Axis.horizontal;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final Color background, border, content;
    final List<BoxShadow> shadows;

    if (isDisabled) {
      // When isDisabled is True, the box is flat and gray, with gray texts.
      background = colors.surfaceContainerHigh;
      border = Colors.transparent;
      content = colors.outline;
      shadows = const [];
    } else {
      // Otherwise the box is the elevated layer, with a gray-900 border when
      // selected, and its shadow grows on hover and when selected.
      background = isDark ? colors.surfaceContainer : colors.surface;
      border = isSelected ? colors.inverseSurface : Colors.transparent;
      content = colors.onSurface;

      if (isSelected || _isHovered) {
        shadows = [BoxShadow(color: colors.shadow, blurRadius: 8, offset: const Offset(0, 2))];
      } else {
        shadows = [BoxShadow(color: colors.shadow, blurRadius: 4, offset: const Offset(0, 1))];
      }
    }

    final illustration = Visibility(
      visible: widget.illustration != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: IconTheme.merge(
            data: IconThemeData(color: content),
            child: widget.illustration ?? const SizedBox(),
          ),
        ),
      ),
    );

    final Widget layout;

    if (isHorizontal) {
      // When the group is horizontal, the box is 368px wide, with the illustration
      // on the left and the bold label above the description on the right.
      layout = Container(
        width: 368,
        constraints: const BoxConstraints(minHeight: 80),
        padding: const EdgeInsetsDirectional.fromSTEB(32, 16, 24, 16),
        child: Row(
          spacing: 10,
          children: [
            illustration,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  DefaultTextStyle(
                    style: style.copyWith(color: content, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: widget.child,
                  ),
                  Visibility(
                    visible: widget.description != null,
                    child: DefaultTextStyle(
                      style: style.copyWith(color: content),
                      child: widget.description ?? const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Otherwise the box is a 170px square, with the illustration centered above
      // the label, and no description.
      layout = Container(
        width: 170,
        height: 170,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            illustration,
            DefaultTextStyle(
              style: style.copyWith(color: content),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: widget.child,
            ),
          ],
        ),
      );
    }

    // The focus ring is only shown for keyboard navigation.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

    // Tells screen readers that this is a selectable option.
    return Semantics(
      button: true,
      selected: isSelected,
      enabled: !isDisabled,
      inMutuallyExclusiveGroup: !isMultiple,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Spectrum 2 "press scale": the box shrinks a little while pressed.
          SpectrumPressScale(
            isPressed: _isPressed,
            // Spectrum 2 select box: 10px corners, a 2px border and a shadow.
            child: AnimatedContainer(
              duration: SpectrumMotion.duration,
              curve: SpectrumMotion.curve,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border, width: 2),
                boxShadow: shadows,
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: isDisabled ? null : group?.onToggle,
                  onHover: (value) => setState(() => _isHovered = value),
                  onHighlightChanged: (value) => setState(() => _isPressed = value),
                  onFocusChange: (value) => setState(() => _isFocused = value),
                  child: layout,
                ),
              ),
            ),
          ),
          // In a multiple group, a checkbox at the top left shows the selection.
          Positioned(
            top: 8,
            left: 8,
            child: Visibility(
              visible: isMultiple && !isDisabled,
              child: IgnorePointer(
                child: ExcludeSemantics(child: SpectrumCheckbox(isSelected: isSelected)),
              ),
            ),
          ),
          // Spectrum focus indicator: a 2px ring with a 2px gap around the box.
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
