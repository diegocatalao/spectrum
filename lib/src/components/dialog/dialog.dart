import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Shows a Spectrum 2 modal over the app: a 50% black underlay and the dialog built
/// by builder, fading in while it moves 20px up. Returns the value it closes with.
Future<T?> showSpectrumDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = false,
  bool isKeyboardDismissDisabled = false,
}) {
  return showGeneralDialog<T>(
    context: context,
    // When isDismissible is True, a tap on the underlay closes the dialog.
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: SpectrumColors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      final dialog = SafeArea(child: Center(child: builder(context)));

      // When isKeyboardDismissDisabled is True, the Escape key does not close the dialog.
      if (isKeyboardDismissDisabled) {
        return PopScope(canPop: false, child: dialog);
      }

      return dialog;
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: SpectrumMotion.easeOut);

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Spectrum Dialog: a window over the app with a heading, a content and buttons,
/// shown with showSpectrumDialog or a SpectrumDialogTrigger.
class SpectrumDialog extends StatelessWidget {
  /// Picture at the top of the dialog, 140px high, from edge to edge.
  final Widget? image;

  /// Title of the dialog.
  final Text? heading;

  /// Widget on the right of the heading, like a switch or a link.
  final Widget? header;

  /// Content of the dialog, scrolled when it is taller than the screen.
  final Widget? content;

  /// Widget on the left of the buttons, like a checkbox.
  final Widget? footer;

  /// Buttons at the bottom right, usually a SpectrumButtonGroup. Hidden when
  /// isDismissible is True, since the close button takes their place.
  final Widget? buttonGroup;

  /// Shows a close button at the top right instead of the buttons.
  final bool isDismissible;

  /// Width of the dialog, 480px by default (the M dialog of Spectrum 2).
  final double width;

  const SpectrumDialog({
    super.key,
    this.image,
    this.heading,
    this.header,
    this.content,
    this.footer,
    this.buttonGroup,
    this.isDismissible = false,
    this.width = 480,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasBottom = footer != null || (buttonGroup != null && !isDismissible);

    return SpectrumDialogSurface(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The hero image, 140px high, cut by the corners of the dialog.
          Visibility(
            visible: image != null,
            child: SizedBox(
              height: 140,
              child: FittedBox(fit: BoxFit.cover, clipBehavior: Clip.hardEdge, child: image),
            ),
          ),
          // Spectrum 2 top: the 2XL title and the header, 32px from the edges, with
          // the close button 12px from the corner when the dialog is dismissible.
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(32, 12, isDismissible ? 12 : 32, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 16),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Semantics(
                          header: true,
                          child: DefaultTextStyle(
                            style: (textTheme.headlineMedium ?? const TextStyle()).copyWith(
                              color: colors.inverseSurface,
                            ),
                            child: heading ?? const SizedBox.shrink(),
                          ),
                        ),
                        Visibility(visible: header != null, child: header ?? const SizedBox.shrink()),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isDismissible,
                  child: SpectrumActionButton(
                    icon: SpectrumIcon(SpectrumIcons.close),
                    isQuiet: true,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            ),
          ),
          // The content scrolls when the dialog is taller than the screen.
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: DefaultTextStyle(
                style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(color: colors.onSurface),
                child: content ?? const SizedBox.shrink(),
              ),
            ),
          ),
          // Spectrum 2 bottom: the footer on the left and the buttons on the right,
          // 32px from the edges and 24px apart.
          Padding(
            padding: EdgeInsets.fromLTRB(32, hasBottom ? 32 : 0, 32, 32),
            child: Visibility(
              visible: hasBottom,
              child: Wrap(
                spacing: 24,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Visibility(visible: footer != null, child: footer ?? const SizedBox.shrink()),
                  Visibility(
                    visible: buttonGroup != null && !isDismissible,
                    child: buttonGroup ?? const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Surface shared by the Spectrum 2 dialogs: the elevated layer with 16px corners,
/// up to 90% of the screen, announced as a dialog by screen readers.
class SpectrumDialogSurface extends StatelessWidget {
  /// Content of the dialog.
  final Widget child;

  /// Width of the dialog, or null to fill the screen up to 90%.
  final double? width;

  /// Height of the dialog, or null to fit the content.
  final double? height;

  /// Corners of the dialog, 16px by default.
  final double radius;

  const SpectrumDialogSurface({super.key, required this.child, this.width, this.height, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screen = MediaQuery.sizeOf(context);

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: Material(
        color: isDark ? colors.surfaceContainer : colors.surface,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screen.width * 0.9, maxHeight: screen.height * 0.9),
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );
  }
}
