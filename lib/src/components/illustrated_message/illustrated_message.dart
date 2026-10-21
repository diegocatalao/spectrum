import 'package:flutter/material.dart';

/// Spectrum Illustrated Message: an illustration with a heading, a text and
/// optional buttons, for empty states, errors and first uses.
class SpectrumIllustratedMessage extends StatelessWidget {
  /// Illustration of the message, like a large SpectrumIcon.
  final Widget? illustration;

  /// Title of the message.
  final Text? heading;

  /// Text below the heading.
  final Widget? content;

  /// Buttons below the text, usually a SpectrumButtonGroup.
  final Widget? buttonGroup;

  /// Illustration above the texts (vertical) or on their left (horizontal).
  final Axis orientation;

  const SpectrumIllustratedMessage({
    super.key,
    this.illustration,
    this.heading,
    this.content,
    this.buttonGroup,
    this.orientation = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isVertical = orientation == Axis.vertical;
    final align = isVertical ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isVertical ? TextAlign.center : TextAlign.start;

    // Spectrum 2 texts: the extra large title in gray-900 and the body in gray-800,
    // 4px apart, with the buttons 16px below.
    final texts = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        Visibility(
          visible: heading != null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Semantics(
              header: true,
              child: DefaultTextStyle(
                style: (textTheme.headlineSmall ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                textAlign: textAlign,
                child: heading ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        Visibility(
          visible: content != null,
          child: DefaultTextStyle(
            style: (textTheme.bodySmall ?? const TextStyle()).copyWith(color: colors.onSurface),
            textAlign: textAlign,
            child: content ?? const SizedBox.shrink(),
          ),
        ),
        Visibility(
          visible: buttonGroup != null,
          child: Padding(padding: const EdgeInsets.only(top: 16), child: buttonGroup ?? const SizedBox.shrink()),
        ),
      ],
    );

    final picture = Visibility(
      visible: illustration != null,
      child: IconTheme.merge(
        data: IconThemeData(color: colors.onSurface),
        child: illustration ?? const SizedBox.shrink(),
      ),
    );

    final Widget layout;

    if (isVertical) {
      // When the orientation is vertical, the illustration is centered above the
      // texts, 12px from the heading, up to 380px wide.
      layout = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(mainAxisSize: MainAxisSize.min, spacing: 12, children: [picture, texts]),
      );
    } else {
      // Otherwise the illustration is on the left of the texts, 12px from them,
      // up to 528px wide.
      layout = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 528),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            picture,
            Flexible(child: texts),
          ],
        ),
      );
    }

    return Semantics(container: true, child: layout);
  }
}
