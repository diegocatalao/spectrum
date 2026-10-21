import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// How a SpectrumCard stands out from the page.
enum SpectrumCardVariant {
  /// Elevated background with a shadow.
  primary,

  /// Layer background with a shadow.
  secondary,

  /// Transparent background with a gray ring.
  tertiary,

  /// No background, ring nor padding, only the content.
  quiet,
}

/// Spectrum Card: a container for an object, like a file or a project, with a
/// preview, a title, a description and a footer.
class SpectrumCard extends StatefulWidget {
  /// Picture shown at the top, from edge to edge.
  final SpectrumCardPreview? preview;

  /// Title of the card, cut after 3 lines.
  final Text? title;

  /// Text below the title, cut after 3 lines.
  final Text? description;

  /// Widget on the right of the title, usually a quiet SpectrumActionMenu.
  final Widget? menu;

  /// Row at the bottom, with actions or details.
  final SpectrumCardFooter? footer;

  /// How the card stands out from the page.
  final SpectrumCardVariant variant;

  /// Space inside the card: 12px compact, 16px standard or 20px comfortable.
  final VisualDensity density;

  /// Called when the card is tapped. Without it, the card is not interactive.
  final VoidCallback? onTap;

  /// Grays out the card and ignores taps.
  final bool isDisabled;

  const SpectrumCard({
    super.key,
    this.preview,
    this.title,
    this.description,
    this.menu,
    this.footer,
    this.variant = SpectrumCardVariant.primary,
    this.density = VisualDensity.standard,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  State<SpectrumCard> createState() => _SpectrumCardState();
}

/// Keeps the hover, press and focus states of the card.
class _SpectrumCardState extends State<SpectrumCard> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isQuiet = widget.variant == SpectrumCardVariant.quiet;
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final isActive = _isHovered || showFocusRing;
    final double spacing;
    final Color background;
    final List<BoxShadow> shadows;

    if (isQuiet) {
      // When the variant is quiet, the content has no padding around it.
      spacing = 0;
    } else if (widget.density == VisualDensity.compact) {
      spacing = 12;
    } else if (widget.density == VisualDensity.comfortable) {
      spacing = 20;
    } else {
      spacing = 16;
    }

    if (widget.variant == SpectrumCardVariant.primary) {
      // When the variant is primary, the card is the elevated layer with a shadow
      // that grows on hover and keyboard focus.
      background = isDark ? colors.surfaceContainer : colors.surface;
      shadows = [BoxShadow(color: colors.shadow, blurRadius: isActive ? 8 : 4, offset: Offset(0, isActive ? 2 : 1))];
    } else if (widget.variant == SpectrumCardVariant.secondary) {
      // When the variant is secondary, the card is the first layer (gray-50) with a shadow.
      background = colors.surfaceContainerLow;
      shadows = [BoxShadow(color: colors.shadow, blurRadius: isActive ? 8 : 4, offset: Offset(0, isActive ? 2 : 1))];
    } else if (widget.variant == SpectrumCardVariant.tertiary) {
      // When the variant is tertiary, the card is transparent with a 2px gray-100
      // ring, gray-200 on hover.
      background = Colors.transparent;
      shadows = [
        BoxShadow(color: isActive ? colors.surfaceContainerHighest : colors.surfaceContainerHigh, spreadRadius: 2),
      ];
    } else {
      // When the variant is quiet, only the content is shown.
      background = Colors.transparent;
      shadows = const [];
    }

    final content = Padding(
      padding: EdgeInsets.all(spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    // Spectrum 2 card title: the small title, bold 14px, in gray-900.
                    Visibility(
                      visible: widget.title != null,
                      child: DefaultTextStyle(
                        style: (textTheme.titleMedium ?? const TextStyle()).copyWith(color: colors.inverseSurface),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        child: widget.title ?? const SizedBox.shrink(),
                      ),
                    ),
                    // Spectrum 2 card description: 12px body text in gray-800.
                    Visibility(
                      visible: widget.description != null,
                      child: DefaultTextStyle(
                        style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                          fontSize: textTheme.labelSmall?.fontSize,
                          color: colors.onSurface,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        child: widget.description ?? const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(visible: widget.menu != null, child: widget.menu ?? const SizedBox.shrink()),
            ],
          ),
          // The footer is 12px below the texts.
          Visibility(
            visible: widget.footer != null,
            child: Padding(
              padding: EdgeInsets.only(top: spacing * 0.75),
              child: widget.footer ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );

    // Inside a SpectrumCardView with selection, the card view selects the card, which
    // shows a 2px border and, in multiple selection, a checkbox at its top left.
    final view = SpectrumCardView.cardOf(context);
    final isSelected = view?.isSelected ?? false;
    final VoidCallback? onTap;

    if (view != null) {
      onTap = () {
        view.onToggle();
        widget.onTap?.call();
      };
    } else {
      onTap = widget.onTap;
    }

    final card = Opacity(
      opacity: widget.isDisabled ? 0.5 : 1,
      // Spectrum 2 card in the M size: 240px wide with 10px corners.
      child: AnimatedContainer(
        duration: SpectrumMotion.duration,
        curve: SpectrumMotion.curve,
        width: 240,
        clipBehavior: isQuiet ? Clip.none : Clip.antiAlias,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: shadows,
          border: Border.all(
            color: showFocusRing ? context.spectrum.focusIndicator : Colors.transparent,
            width: showFocusRing ? 2 : 0,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: widget.isDisabled ? null : onTap,
            onHover: (value) => setState(() => _isHovered = value),
            onHighlightChanged: (value) => setState(() => _isPressed = value),
            onFocusChange: (value) => setState(() => _isFocused = value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // The preview goes from edge to edge, above the padded content.
                Visibility(visible: widget.preview != null, child: widget.preview ?? const SizedBox.shrink()),
                content,
              ],
            ),
          ),
        ),
      ),
    );

    // Spectrum 2 "press scale" when the card is interactive.
    return Semantics(
      container: true,
      button: onTap != null,
      selected: view != null ? isSelected : null,
      enabled: !widget.isDisabled,
      child: SpectrumPressScale(
        isPressed: _isPressed && onTap != null,
        child: Stack(
          children: [
            card,
            // The selection border, 2px of gray-1000 over the card.
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: isSelected ? 1 : 0,
                  duration: SpectrumMotion.duration,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).colorScheme.inverseSurface, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Visibility(
                visible: view?.isMultiple ?? false,
                child: IgnorePointer(
                  child: ExcludeSemantics(child: SpectrumCheckbox(isSelected: isSelected)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
