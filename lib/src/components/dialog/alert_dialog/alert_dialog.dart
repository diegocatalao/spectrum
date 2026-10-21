import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Kind of a SpectrumAlertDialog, which picks the button of its primary action
/// and the icon next to its title.
enum SpectrumAlertDialogVariant { confirmation, information, destructive, error, warning }

/// Spectrum Alert Dialog: a dialog that asks the user to confirm or acknowledge
/// something, with up to three buttons. Each button closes the dialog.
class SpectrumAlertDialog extends StatelessWidget {
  /// Title of the dialog.
  final String title;

  /// Text of the dialog.
  final Widget child;

  /// Kind of the dialog, confirmation by default.
  final SpectrumAlertDialogVariant variant;

  /// Text of the primary button.
  final String primaryActionLabel;

  /// Text of the secondary button.
  final String? secondaryActionLabel;

  /// Text of the cancel button.
  final String? cancelLabel;

  /// Called when the primary button is tapped.
  final VoidCallback? onPrimaryAction;

  /// Called when the secondary button is tapped.
  final VoidCallback? onSecondaryAction;

  /// Called when the cancel button is tapped.
  final VoidCallback? onCancel;

  /// Disables the primary button.
  final bool isPrimaryActionDisabled;

  /// Disables the secondary button.
  final bool isSecondaryActionDisabled;

  const SpectrumAlertDialog({
    super.key,
    required this.title,
    required this.child,
    required this.primaryActionLabel,
    this.variant = SpectrumAlertDialogVariant.confirmation,
    this.secondaryActionLabel,
    this.cancelLabel,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onCancel,
    this.isPrimaryActionDisabled = false,
    this.isSecondaryActionDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final SpectrumButtonVariant primary;
    final SpectrumIcon? icon;

    if (variant == SpectrumAlertDialogVariant.confirmation) {
      // A confirmation is answered with the accent button.
      primary = SpectrumButtonVariant.accent;
      icon = null;
    } else if (variant == SpectrumAlertDialogVariant.destructive) {
      // A destructive action is answered with the negative button.
      primary = SpectrumButtonVariant.negative;
      icon = null;
    } else if (variant == SpectrumAlertDialogVariant.error) {
      // An error shows the red alert icon next to the title.
      primary = SpectrumButtonVariant.primary;
      icon = SpectrumIcon(SpectrumIcons.alert, size: 20, color: colors.error);
    } else if (variant == SpectrumAlertDialogVariant.warning) {
      // A warning shows the orange alert icon next to the title.
      primary = SpectrumButtonVariant.primary;
      icon = SpectrumIcon(
        SpectrumIcons.alert,
        size: 20,
        color: isDark ? SpectrumDarkColors.orange900 : SpectrumColors.orange900,
      );
    } else {
      // Information is only acknowledged.
      primary = SpectrumButtonVariant.primary;
      icon = null;
    }

    final navigator = Navigator.of(context);

    // Spectrum 2 alert dialog: the M dialog with the cancel, secondary and primary
    // buttons from left to right, each one closing the dialog.
    return Semantics(
      label: title,
      child: SpectrumDialog(
        heading: Text(title),
        header: icon,
        content: child,
        buttonGroup: SpectrumButtonGroup(
          children: [
            ?_button(cancelLabel, SpectrumButtonVariant.secondary, false, () {
              navigator.maybePop();
              onCancel?.call();
            }),
            ?_button(secondaryActionLabel, SpectrumButtonVariant.secondary, isSecondaryActionDisabled, () {
              navigator.maybePop();
              onSecondaryAction?.call();
            }),
            SpectrumButton(
              content: primaryActionLabel,
              variant: primary,
              isDisabled: isPrimaryActionDisabled,
              isAutoFocus: true,
              onTap: () {
                navigator.maybePop();
                onPrimaryAction?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an outline button, or nothing when there is no label.
  SpectrumButton? _button(String? label, SpectrumButtonVariant variant, bool isDisabled, VoidCallback onTap) {
    if (label == null) {
      return null;
    }

    return SpectrumButton(content: label, variant: variant, isOutline: true, isDisabled: isDisabled, onTap: onTap);
  }
}
