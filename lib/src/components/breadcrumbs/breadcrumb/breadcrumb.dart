import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:url_launcher/link.dart';

/// Spectrum Breadcrumb: one item of a SpectrumBreadcrumbs, a link to a page of the
/// path followed by a chevron, or the bold current page when it is the last one.
class SpectrumBreadcrumb extends StatefulWidget {
  /// Text of the item.
  final Text child;

  /// Address opened when the item is tapped.
  final Uri? href;

  /// Menu shown in place of the text, used by the breadcrumbs for the hidden items.
  final Widget? menu;

  const SpectrumBreadcrumb({super.key, required this.child, this.href, this.menu});

  @override
  State<SpectrumBreadcrumb> createState() => _SpectrumBreadcrumbState();
}

/// Keeps the hover and focus states of the item.
class _SpectrumBreadcrumbState extends State<SpectrumBreadcrumb> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final item = SpectrumBreadcrumbs.itemOf(context);
    final isCurrent = item?.isCurrent ?? false;
    final isDisabled = item?.isDisabled ?? false;
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final Widget label;

    if (widget.menu != null) {
      // When the item holds the hidden items, the menu is shown in place of the text.
      label = widget.menu!;
    } else if (isCurrent) {
      // When the item is the current page, it is bold gray-800 text, not a link.
      label = Semantics(
        header: true,
        child: DefaultTextStyle(
          style: style.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
          child: widget.child,
        ),
      );
    } else {
      // Otherwise it is a gray-700 link, underlined on hover and keyboard focus,
      // gray-400 when disabled.
      final isUnderlined = !isDisabled && (_isHovered || showFocusRing);
      final content = DefaultTextStyle(
        style: style.copyWith(
          color: isDisabled ? colors.outline : colors.onSurfaceVariant,
          decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
          decorationColor: colors.onSurfaceVariant,
        ),
        child: widget.child,
      );

      label = Link(
        uri: widget.href,
        builder: (context, followLink) {
          return Semantics(
            link: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: isDisabled
                  ? null
                  : () {
                      item?.onTap?.call();

                      if (widget.href != null) {
                        followLink?.call();
                      }
                    },
              onHover: (value) => setState(() => _isHovered = value),
              onFocusChange: (value) => setState(() => _isFocused = value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: showFocusRing ? context.spectrum.focusIndicator : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: content,
              ),
            ),
          );
        },
      );
    }

    // Spectrum 2 item: 32px high, with the gray-800 chevron 6px after the text,
    // except on the current page.
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          label,
          Visibility(
            visible: !isCurrent,
            child: SpectrumIcon(
              Directionality.of(context) == TextDirection.rtl ? SpectrumIcons.chevronLeft : SpectrumIcons.chevronRight,
              color: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
