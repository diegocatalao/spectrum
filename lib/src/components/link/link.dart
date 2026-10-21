import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:url_launcher/link.dart';

/// Visual role of a SpectrumLink.
enum SpectrumLinkVariant {
  /// Accent blue, the default link color.
  primary,

  /// Neutral gray, for links that should not draw attention.
  secondary,
}

/// Spectrum Link: an underlined text that opens an address, used inside or after text.
class SpectrumLink extends StatefulWidget {
  /// Address opened when the link is tapped.
  final Uri href;

  /// Text of the link.
  final String content;

  /// Visual role of the link, primary by default.
  final SpectrumLinkVariant variant;

  /// Hides the underline until the link is hovered or focused.
  /// Only applies to standalone links, as in Spectrum 2.
  final bool isQuiet;

  /// Marks a link used on its own, outside of a sentence, which is drawn in bold
  /// so it stands out like a navigation item.
  final bool isStandalone;

  /// Fixed white or black color for links over images or colored backgrounds.
  /// When set, it replaces the variant color.
  final SpectrumStaticColor? staticColor;

  const SpectrumLink({
    super.key,
    required this.href,
    required this.content,
    this.variant = SpectrumLinkVariant.primary,
    this.isQuiet = false,
    this.isStandalone = false,
    this.staticColor,
  });

  @override
  State<SpectrumLink> createState() => _SpectrumLinkState();
}

class _SpectrumLinkState extends State<SpectrumLink> {
  /// Hover state, kept to darken the text and show the underline of quiet links.
  bool _isHovered = false;

  /// Focus state, kept to draw the focus ring only when the
  /// link is focused by the keyboard, not by a mouse click.
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color color, hover;

    if (widget.staticColor == SpectrumStaticColor.black) {
      // When staticColor is black, the link is black over light images,
      // and gets slightly translucent on hover.
      color = SpectrumColors.black;
      hover = SpectrumColors.black.withValues(alpha: 0.8);
    } else if (widget.staticColor == SpectrumStaticColor.white) {
      // When staticColor is white, the link is white over dark images,
      // and gets slightly translucent on hover.
      color = SpectrumColors.white;
      hover = SpectrumColors.white.withValues(alpha: 0.8);
    } else if (widget.variant == SpectrumLinkVariant.secondary) {
      // When the variant is secondary, the link uses the neutral text gray
      // and gets one step darker on hover, as the other neutral content.
      color = colors.onSurface;
      hover = colors.inverseSurface;
    } else {
      // When the variant is primary, the link is the accent blue
      // and uses the accent hover blue of the theme extension.
      color = colors.primary;
      hover = SpectrumThemeExtension.of(context).accentHover;
    }

    // The focus ring is only shown for keyboard navigation, as the
    // :focus-visible of the web, so a mouse click never shows it.
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final isActive = _isHovered || _isFocused;
    final Color text, ring;
    final TextDecoration decoration;

    if (widget.isQuiet && widget.isStandalone && !isActive) {
      // When isQuiet and isStandalone are True, the underline is hidden while
      // the link is idle, since a link inside a sentence must always be
      // underlined to be recognized, and comes back on hover or focus.
      text = color;
      decoration = TextDecoration.none;
    } else if (isActive) {
      // When the link is hovered or focused, the text gets the hover color
      // and is underlined, also for quiet links.
      text = hover;
      decoration = TextDecoration.underline;
    } else {
      // Otherwise the link is always underlined, the main sign that it is a link.
      text = color;
      decoration = TextDecoration.underline;
    }

    final FontWeight weight;

    if (widget.isStandalone) {
      // When isStandalone is True, the link is bold, since there is
      // no sentence around it to show that it is a link.
      weight = FontWeight.w700;
    } else {
      // Otherwise the link keeps the weight of the text around it,
      // standing out only by its color and underline.
      weight = FontWeight.w400;
    }

    if (showFocusRing) {
      // When the link is focused by the keyboard, the Spectrum
      // focus ring is drawn around the text.
      ring = SpectrumThemeExtension.of(context).focusIndicator;
    } else {
      // Otherwise the ring stays transparent, keeping the same size
      // so the text does not move when the focus changes.
      ring = Colors.transparent;
    }

    // Link opens the address in the system browser on every platform, and on
    // the web it also gives the native link behaviors, like the middle click.
    return Link(
      uri: widget.href,
      builder: (context, followLink) {
        // Tells screen readers that this is a link and its text.
        return Semantics(
          link: true,
          label: widget.content,
          excludeSemantics: true,
          child: InkWell(
            onTap: followLink,
            onHover: (value) => setState(() => _isHovered = value),
            onFocusChange: (value) => setState(() => _isFocused = value),
            // A link has no background feedback, only the text color changes.
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            child: DecoratedBox(
              // Spectrum focus indicator: a 2px ring around the text, only for the keyboard.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: ring, width: 2),
              ),
              child: Text(
                widget.content,
                style: TextStyle(color: text, fontWeight: weight, decoration: decoration, decorationColor: text),
              ),
            ),
          ),
        );
      },
    );
  }
}
