import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Disclosure Header: the chevron and the title that expand or collapse
/// a SpectrumDisclosure, with optional actions on the right.
class SpectrumDisclosureHeader extends StatelessWidget {
  /// Title shown on the right of the chevron.
  final SpectrumDisclosureTitle child;

  /// Widgets shown on the right of the header, outside of its hover and
  /// tap area, like a SpectrumActionButton to edit the item.
  final List<SpectrumActionButton> actions;

  const SpectrumDisclosureHeader({super.key, required this.child, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disclosure = SpectrumDisclosure.stateOf(context);
    final isExpanded = disclosure?.isExpanded ?? false;
    final isDisabled = disclosure?.isDisabled ?? false;
    final isQuiet = disclosure?.isQuiet ?? false;
    // Light gray background on hover, transparent when disabled.
    final hover = isDisabled ? Colors.transparent : colors.surfaceContainerHigh;
    // Darker gray background on tap, transparent when disabled.
    final pressed = isDisabled ? Colors.transparent : colors.surfaceContainerHighest;
    // Rounded hover background when quiet, square when it touches the dividers.
    final borderRadius = isQuiet ? BorderRadius.circular(8) : BorderRadius.zero;

    return Row(
      children: [
        // The header takes all the width left by the actions, so its
        // hover background stops before them, as in Spectrum 2.
        Expanded(
          // Tells screen readers that the header is a button, if it is
          // enabled and if the panel below it is expanded or collapsed.
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
                onTap: isDisabled ? null : disclosure?.onToggle,
                focusColor: Colors.transparent,
                child: ListTile(
                  title: child,
                  enabled: !isDisabled,
                  visualDensity: disclosure?.density ?? VisualDensity.standard,
                  // A quarter turn points the chevron down when expanded.
                  leading: AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: SpectrumMotion.duration,
                    curve: SpectrumMotion.curve,
                    child: SpectrumIcon(SpectrumIcons.chevronRight),
                  ),
                ),
              ),
            ),
          ),
        ),
        // The actions are outside of the InkWell, so tapping them never toggles
        // the disclosure. Without actions, the Padding is not added, since it
        // would still push the header away from the right edge.
        Visibility(
          visible: actions.isNotEmpty,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: actions),
          ),
        ),
      ],
    );
  }
}
