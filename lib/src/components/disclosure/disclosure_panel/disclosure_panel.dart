import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Disclosure Panel: the content revealed below the header of a
/// SpectrumDisclosure when it is expanded.
class SpectrumDisclosurePanel extends StatelessWidget {
  /// Content of the panel.
  final Widget child;

  const SpectrumDisclosurePanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isExpanded = SpectrumDisclosure.stateOf(context)?.isExpanded ?? false;

    // When collapsed, the content can not be focused nor read by screen
    // readers, since it is hidden.
    return ExcludeFocus(
      excluding: !isExpanded,
      child: ExcludeSemantics(
        excluding: !isExpanded,
        // The ClipRect hides the part of the content outside the animated
        // height, and topStart keeps it aligned with the header while it grows.
        child: ClipRect(
          child: AnimatedAlign(
            alignment: AlignmentDirectional.topStart,
            heightFactor: isExpanded ? 1 : 0,
            duration: SpectrumMotion.duration,
            curve: SpectrumMotion.curve,
            // The infinite width stretches the content, as the
            // CrossAxisAlignment.stretch of the disclosure does.
            child: SizedBox(
              width: double.infinity,
              child: Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 10), child: child),
            ),
          ),
        ),
      ),
    );
  }
}
