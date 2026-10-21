import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Fullscreen Dialog: a dialog almost as large as the screen, for complex
/// tasks, with its buttons at the top right.
class SpectrumFullscreenDialog extends StatelessWidget {
  /// Title of the dialog.
  final Text? heading;

  /// Widget next to the heading.
  final Widget? header;

  /// Content of the dialog.
  final Widget? content;

  /// Buttons at the top right, usually a SpectrumButtonGroup.
  final Widget? buttonGroup;

  /// Covers the whole screen without corners (takeover), instead of leaving 20px around it.
  final bool isTakeover;

  const SpectrumFullscreenDialog({
    super.key,
    this.heading,
    this.header,
    this.content,
    this.buttonGroup,
    this.isTakeover = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screen = MediaQuery.sizeOf(context);
    final double width, height, radius;

    if (isTakeover) {
      // When isTakeover is True, the dialog covers the whole screen without corners.
      width = screen.width;
      height = screen.height;
      radius = 0;
    } else {
      // Otherwise it leaves 20px around it, with the 16px corners of the dialogs.
      width = screen.width - 40;
      height = screen.height - 40;
      radius = 16;
    }

    return SpectrumDialogSurface(
      width: width,
      height: height,
      radius: radius,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            // The heading on the left and the buttons on the right, on the same line.
            Row(
              spacing: 24,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 24,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Semantics(
                        header: true,
                        child: DefaultTextStyle(
                          style: (textTheme.headlineMedium ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                          child: heading ?? const SizedBox.shrink(),
                        ),
                      ),
                      Visibility(visible: header != null, child: header ?? const SizedBox.shrink()),
                    ],
                  ),
                ),
                Visibility(visible: buttonGroup != null, child: buttonGroup ?? const SizedBox.shrink()),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(color: colors.onSurface),
                  child: content ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
