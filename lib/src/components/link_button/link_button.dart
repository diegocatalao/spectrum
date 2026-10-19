import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:url_launcher/link.dart';

/// Spectrum Link Button: a SpectrumButton that opens a link instead of running an action.
class SpectrumLinkButton extends StatelessWidget {
  /// Address opened when the button is tapped.
  final Uri href;

  /// Text shown on the right of the icon.
  final String content;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Grays out the button and ignores hover and tap.
  final bool isDisabled;

  /// Visual role of the button, primary by default.
  final SpectrumButtonVariant variant;

  /// Draws only a border in the variant color instead of filling the background.
  final bool isOutline;

  /// Fixed white or black colors for buttons over images or colored backgrounds.
  final SpectrumStaticColor? staticColor;

  /// Focuses the button as soon as it is shown.
  final bool isAutoFocus;

  const SpectrumLinkButton({
    super.key,
    required this.href,
    required this.content,
    this.icon,
    this.variant = SpectrumButtonVariant.primary,
    this.isDisabled = false,
    this.isOutline = false,
    this.staticColor,
    this.isAutoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    // Link opens the address in the system browser on every platform, and on
    // the web it also gives the button the native link behaviors, like
    // opening it in a new tab with the middle click.
    return Link(
      uri: href,
      builder: (context, followLink) {
        // Tells screen readers that this is a link, not a button,
        // since it navigates instead of running an action.
        return Semantics(
          link: true,
          child: SpectrumButton(
            content: content,
            icon: icon,
            variant: variant,
            isDisabled: isDisabled,
            isOutline: isOutline,
            staticColor: staticColor,
            isAutoFocus: isAutoFocus,
            onTap: followLink,
          ),
        );
      },
    );
  }
}
