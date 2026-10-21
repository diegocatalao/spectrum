import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Kind of a SpectrumContextualHelp, which picks its icon.
enum SpectrumContextualHelpVariant { help, info }

/// Spectrum Contextual Help: a quiet help (or info) button that opens a small
/// popover with a heading, a text and an optional footer, like a link.
class SpectrumContextualHelp extends StatelessWidget {
  /// Title of the popover.
  final Text? heading;

  /// Text of the popover.
  final Widget child;

  /// Widget below the text, like a SpectrumLink to the documentation.
  final Widget? footer;

  /// Help shows a question mark, info shows an "i".
  final SpectrumContextualHelpVariant variant;

  /// Placement of the popover, below the button and aligned with its start by default.
  final SpectrumPopoverPlacement placement;

  const SpectrumContextualHelp({
    super.key,
    this.heading,
    required this.child,
    this.footer,
    this.variant = SpectrumContextualHelpVariant.help,
    this.placement = SpectrumPopoverPlacement.bottomStart,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isHelp = variant == SpectrumContextualHelpVariant.help;
    final body = (textTheme.bodySmall ?? const TextStyle()).copyWith(color: colors.onSurface);

    return SpectrumPopover(
      placement: placement,
      hideArrow: true,
      padding: EdgeInsets.zero,
      // The quiet button with the help or info icon, announced by screen readers.
      trigger: (context, onToggle) => Semantics(
        label: isHelp ? 'Help' : 'Information',
        child: SpectrumActionButton(
          icon: SpectrumIcon(isHelp ? SpectrumIcons.help : SpectrumIcons.info),
          isQuiet: true,
          onTap: onToggle,
        ),
      ),
      // Spectrum 2 contextual help: a 268px wide popover with 24px of padding, the
      // heading, the text and the footer 16px below.
      child: SizedBox(
        width: 268,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Visibility(
                visible: heading != null,
                child: Semantics(
                  header: true,
                  child: DefaultTextStyle(
                    style: (textTheme.titleMedium ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                    child: heading ?? const SizedBox.shrink(),
                  ),
                ),
              ),
              DefaultTextStyle(style: body, child: child),
              Visibility(
                visible: footer != null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: DefaultTextStyle(style: body, child: footer ?? const SizedBox.shrink()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
