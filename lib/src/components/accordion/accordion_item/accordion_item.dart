import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Accordion Item: a header with a chevron and a title that,
/// when tapped, expands or collapses the content below it.
class SpectrumAccordionItem extends StatelessWidget {
  /// Text shown on the right of the chevron.
  final Text title;

  /// Panel revealed below the header when the item is expanded.
  final Widget panel;

  /// Removes the dividers and rounds the corners of the hover background.
  final bool isQuiet;

  /// Widgets shown on the right of the header, outside of its hover and
  /// tap area, like a SpectrumActionButton to edit the item.
  final List<SpectrumActionButton> actions;

  /// Shows the content and points the chevron down.
  final bool isExpanded;

  /// Grays out the title and ignores hover and tap.
  final bool isDisabled;

  /// Called on every tap on the header.
  final VoidCallback? onTap;

  /// Vertical and horizontal compactness of the header.
  final VisualDensity density;

  const SpectrumAccordionItem({
    super.key,
    required this.title,
    required this.panel,
    this.actions = const [],
    this.isQuiet = false,
    this.isExpanded = false,
    this.isDisabled = false,
    this.onTap,
    this.density = VisualDensity.standard,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Light gray background on hover, transparent when disabled.
    final hover = isDisabled ? Colors.transparent : colors.surfaceContainerHigh;
    // Darker gray background on tap, transparent when disabled.
    final pressed = isDisabled ? Colors.transparent : colors.surfaceContainerHighest;
    // A quarter turn points the chevron down when expanded.
    final turns = isExpanded ? 0.25 : 0.0;
    // Full content height when expanded, zero when collapsed.
    final heightFactor = isExpanded ? 1.0 : 0.0;
    // Rounded hover background when quiet, square when it touches the dividers.
    final borderRadius = isQuiet ? BorderRadius.circular(8) : BorderRadius.zero;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // The header takes all the width left by the actions, so its
            // hover background stops before them, as in Spectrum 2.
            Expanded(
              // Tells screen readers that the header is a button, if it is
              // enabled and if the content below it is expanded or collapsed.
              // It only wraps the header, so the actions keep their own semantics.
              child: Semantics(
                button: true,
                enabled: !isDisabled,
                expanded: isExpanded,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: borderRadius,
                  child: InkWell(
                    borderRadius: borderRadius,
                    hoverColor: hover,
                    highlightColor: pressed,
                    // When isDisabled is True the tap will be null and the InkWell
                    // stops reacting to hover and tap. The ListTile below has no
                    // onTap, so the InkWell is the only one drawing the background.
                    onTap: isDisabled ? null : onTap,
                    focusColor: Colors.transparent,
                    child: ListTile(
                      title: title,
                      enabled: !isDisabled,
                      visualDensity: density,
                      leading: AnimatedRotation(
                        turns: turns,
                        duration: const Duration(milliseconds: 130),
                        curve: Curves.easeInOut,
                        child: SpectrumIcon(SpectrumIcons.chevronRight),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // The actions are only added when they exist, because an empty
            // Padding would still push the header away from the right edge.
            // They are outside of the InkWell, so tapping them never toggles the item.
            Visibility(
              visible: actions.isNotEmpty,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: actions),
              ),
            ),
          ],
        ),
        // The ClipRect hides the part of the content outside the animated
        // height, and topStart keeps it aligned with the header while it grows.
        ClipRect(
          child: AnimatedAlign(
            alignment: AlignmentDirectional.topStart,
            heightFactor: heightFactor,
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeInOut,
            // The infinite width stretches the content, as the
            // CrossAxisAlignment.stretch of the Column does.
            child: SizedBox(
              width: double.infinity,
              child: Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 10), child: panel),
            ),
          ),
        ),
        // The divider is only added when the item is not quiet, because
        // the quiet accordion separates its items only by spacing.
        if (!isQuiet) const SpectrumDivider(),
      ],
    );
  }
}
