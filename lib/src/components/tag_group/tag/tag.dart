import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tag: one tag of a SpectrumTagGroup, with an optional icon, avatar or
/// image before its text and a remove button when the group allows removing.
class SpectrumTag extends StatefulWidget {
  /// Text of the tag.
  final Text child;

  /// Icon, SpectrumAvatar or small image shown before the text.
  final Widget? leading;

  /// Grays out the tag and ignores taps.
  final bool isDisabled;

  const SpectrumTag({super.key, required this.child, this.leading, this.isDisabled = false});

  @override
  State<SpectrumTag> createState() => _SpectrumTagState();
}

class _SpectrumTagState extends State<SpectrumTag> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final group = SpectrumTagGroup.tagOf(context);
    final isSelected = group?.isSelected ?? false;
    final isDisabled = widget.isDisabled || (group?.isDisabled ?? false);
    final isActive =
        _isHovered ||
        _isPressed ||
        (_isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional);
    final Color background, content;

    if (isDisabled) {
      // When disabled, the tag is the disabled gray.
      background = colors.surfaceContainerHigh;
      content = colors.outline;
    } else if (isSelected && (group?.isEmphasized ?? false)) {
      // When selected and emphasized, the tag is the accent blue with white text.
      background = isActive ? SpectrumThemeExtension.of(context).accentHover : colors.primary;
      content = colors.onPrimary;
    } else if (isSelected) {
      // When selected, the tag is gray-800 with gray-25 text.
      background = isActive ? colors.inverseSurface : colors.onSurface;
      content = colors.surface;
    } else {
      // Otherwise the tag is gray-100, gray-200 on hover and focus.
      background = isActive ? colors.surfaceContainerHighest : colors.surfaceContainerHigh;
      content = colors.onSurface;
    }

    final showsRemove = group?.onRemove != null;

    // Spectrum 2 tag in the M size: 32px high, 12px from the edges (none at the end
    // when removable), 8px corners and the leading widget 6px before the text.
    return Semantics(
      button: group?.onTap != null,
      selected: isSelected,
      enabled: !isDisabled,
      child: SpectrumPressScale(
        isPressed: _isPressed,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: isDisabled ? null : group?.onTap,
            onHover: (value) => setState(() => _isHovered = value),
            onHighlightChanged: (value) => setState(() => _isPressed = value),
            onFocusChange: (value) => setState(() => _isFocused = value),
            child: Container(
              height: 32,
              padding: EdgeInsetsDirectional.only(start: 12, end: showsRemove ? 0 : 12),
              child: IconTheme.merge(
                data: IconThemeData(color: content),
                child: DefaultTextStyle(
                  style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: content),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      ?widget.leading,
                      Flexible(child: widget.child),
                      // The remove button, a small quiet cross at the end.
                      Visibility(
                        visible: showsRemove,
                        child: Semantics(
                          button: true,
                          label: 'Remove ${widget.child.data ?? ''}',
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: isDisabled ? null : group?.onRemove,
                            child: SizedBox.square(
                              dimension: 32,
                              child: Center(child: SpectrumIcon(SpectrumIcons.close, size: 10, color: content)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
