import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Meaning of a SpectrumToast, which picks its color and icon.
enum SpectrumToastVariant { neutral, info, positive, negative }

/// Where a SpectrumToastContainer shows its toasts.
enum SpectrumToastPlacement { top, topEnd, bottom, bottomEnd }

/// Spectrum Toast: a short message that appears over the app for a while, with an
/// optional action, created by SpectrumToastQueue and shown by SpectrumToastContainer.
class SpectrumToast {
  /// Text of the toast.
  final String message;

  /// Meaning of the toast.
  final SpectrumToastVariant variant;

  /// Text of the action button. Toasts with an action stay until they are closed.
  final String? actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onAction;

  /// Closes the toast when the action button is tapped.
  final bool shouldCloseOnAction;

  /// Called when the toast closes.
  final VoidCallback? onClose;

  const SpectrumToast._({
    required this.message,
    required this.variant,
    this.actionLabel,
    this.onAction,
    this.shouldCloseOnAction = false,
    this.onClose,
  });
}

/// Spectrum Toast Queue: adds toasts to the SpectrumToastContainer of the app.
/// Each method returns a function that closes the toast.
abstract final class SpectrumToastQueue {
  /// Toasts shown now, the newest last.
  static final ValueNotifier<List<SpectrumToast>> toasts = ValueNotifier(const []);

  /// Shows a neutral toast.
  static VoidCallback neutral(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool shouldCloseOnAction = false,
    Duration? timeout,
    VoidCallback? onClose,
  }) => _add(SpectrumToastVariant.neutral, message, actionLabel, onAction, shouldCloseOnAction, timeout, onClose);

  /// Shows an informative toast, with the info icon.
  static VoidCallback info(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool shouldCloseOnAction = false,
    Duration? timeout,
    VoidCallback? onClose,
  }) => _add(SpectrumToastVariant.info, message, actionLabel, onAction, shouldCloseOnAction, timeout, onClose);

  /// Shows a positive toast, with the checkmark icon.
  static VoidCallback positive(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool shouldCloseOnAction = false,
    Duration? timeout,
    VoidCallback? onClose,
  }) => _add(SpectrumToastVariant.positive, message, actionLabel, onAction, shouldCloseOnAction, timeout, onClose);

  /// Shows a negative toast, with the alert icon.
  static VoidCallback negative(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    bool shouldCloseOnAction = false,
    Duration? timeout,
    VoidCallback? onClose,
  }) => _add(SpectrumToastVariant.negative, message, actionLabel, onAction, shouldCloseOnAction, timeout, onClose);

  static VoidCallback _add(
    SpectrumToastVariant variant,
    String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool shouldCloseOnAction,
    Duration? timeout,
    VoidCallback? onClose,
  ) {
    final toast = SpectrumToast._(
      message: message,
      variant: variant,
      actionLabel: actionLabel,
      onAction: onAction,
      shouldCloseOnAction: shouldCloseOnAction,
      onClose: onClose,
    );
    toasts.value = [...toasts.value, toast];

    // As in Spectrum 2, a timeout is never shorter than 5 seconds, and toasts with
    // an action stay until they are closed, so the action is not missed.
    if (timeout != null && actionLabel == null) {
      Timer(timeout < const Duration(seconds: 5) ? const Duration(seconds: 5) : timeout, () => close(toast));
    }

    return () => close(toast);
  }

  /// Closes the toast, if it is still shown.
  static void close(SpectrumToast toast) {
    if (toasts.value.contains(toast)) {
      toasts.value = [...toasts.value]..remove(toast);
      toast.onClose?.call();
    }
  }
}

/// Spectrum Toast Container: shows the toasts of SpectrumToastQueue over its
/// child. It should wrap the whole app, like the builder of the MaterialApp.
class SpectrumToastContainer extends StatelessWidget {
  /// The app below the toasts.
  final Widget child;

  /// Where the toasts are shown, at the bottom center by default.
  final SpectrumToastPlacement placement;

  const SpectrumToastContainer({super.key, required this.child, this.placement = SpectrumToastPlacement.bottom});

  @override
  Widget build(BuildContext context) {
    final isTop = placement == SpectrumToastPlacement.top || placement == SpectrumToastPlacement.topEnd;
    final isEnd = placement == SpectrumToastPlacement.topEnd || placement == SpectrumToastPlacement.bottomEnd;

    return Stack(
      children: [
        child,
        // The toasts stand 16px from the edge, the newest closest to it.
        Positioned(
          left: 16,
          right: 16,
          top: isTop ? 16 : null,
          bottom: isTop ? null : 16,
          child: SafeArea(
            child: Align(
              alignment: Alignment(isEnd ? 1 : 0, isTop ? -1 : 1),
              child: ValueListenableBuilder<List<SpectrumToast>>(
                valueListenable: SpectrumToastQueue.toasts,
                builder: (context, toasts, _) {
                  final ordered = isTop ? toasts.reversed.toList() : toasts;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.center,
                    spacing: 8,
                    children: [for (final toast in ordered) _ToastView(key: ObjectKey(toast), toast: toast)],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One toast on the screen.
class _ToastView extends StatelessWidget {
  final SpectrumToast toast;

  const _ToastView({super.key, required this.toast});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background;
    final SpectrumIcons? icon;

    if (toast.variant == SpectrumToastVariant.info) {
      // When the variant is info, the toast is the informative blue with the info icon.
      background = isDark ? SpectrumDarkColors.blue800 : SpectrumColors.blue900;
      icon = SpectrumIcons.info;
    } else if (toast.variant == SpectrumToastVariant.positive) {
      // When the variant is positive, the toast is green with the checkmark icon.
      background = isDark ? SpectrumDarkColors.green800 : SpectrumColors.green900;
      icon = SpectrumIcons.checkmarkCircle;
    } else if (toast.variant == SpectrumToastVariant.negative) {
      // When the variant is negative, the toast is red with the alert icon.
      background = isDark ? SpectrumDarkColors.red800 : SpectrumColors.red900;
      icon = SpectrumIcons.alert;
    } else {
      // When the variant is neutral, the toast is the subdued gray, without an icon.
      background = isDark ? SpectrumDarkColors.gray500 : SpectrumColors.gray700;
      icon = null;
    }

    final style = (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: SpectrumColors.white);

    // Tells screen readers to announce the toast when it appears.
    return Semantics(
      liveRegion: true,
      container: true,
      // Spectrum 2 toast entrance: it fades in while moving 8px towards its place.
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 200),
        curve: SpectrumMotion.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(offset: Offset(0, 8 * (1 - value)), child: child),
          );
        },
        // Spectrum 2 toast: at least 56px high, up to 336px wide, 10px corners, white
        // texts over the color of the variant and the elevated shadow.
        child: Container(
          constraints: const BoxConstraints(minHeight: 56, maxWidth: 336),
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Flexible(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Visibility(
                          visible: icon != null,
                          child: SpectrumIcon(icon ?? SpectrumIcons.info, size: 20, color: SpectrumColors.white),
                        ),
                        Flexible(child: Text(toast.message, style: style)),
                      ],
                    ),
                    // The action is an outline button in static white.
                    Visibility(
                      visible: toast.actionLabel != null,
                      child: SpectrumButton(
                        content: toast.actionLabel ?? '',
                        variant: SpectrumButtonVariant.secondary,
                        isOutline: true,
                        staticColor: SpectrumStaticColor.white,
                        onTap: () {
                          toast.onAction?.call();

                          if (toast.shouldCloseOnAction) {
                            SpectrumToastQueue.close(toast);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // The close button is a quiet action button in static white.
              SpectrumActionButton(
                icon: SpectrumIcon(SpectrumIcons.close),
                isQuiet: true,
                staticColor: SpectrumStaticColor.white,
                onTap: () => SpectrumToastQueue.close(toast),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
