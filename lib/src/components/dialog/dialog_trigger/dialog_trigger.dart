import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// How a SpectrumDialogTrigger shows its dialog.
enum SpectrumDialogType {
  /// Over the app, with the dark underlay.
  modal,

  /// In a popover next to the trigger.
  popover,
}

/// Spectrum Dialog Trigger: opens a dialog from a trigger, like a button, as a
/// modal over the app or in a popover next to the trigger.
class SpectrumDialogTrigger extends StatelessWidget {
  /// Builds the widget that opens the dialog, receiving the function that opens it.
  final Widget Function(BuildContext context, VoidCallback onOpen) trigger;

  /// Builds the dialog, usually a SpectrumDialog or a SpectrumAlertDialog.
  final WidgetBuilder builder;

  /// How the dialog is shown, as a modal by default.
  final SpectrumDialogType type;

  /// Closes the modal with a tap on the underlay.
  final bool isDismissible;

  /// Placement of the dialog when the type is popover.
  final SpectrumPopoverPlacement placement;

  const SpectrumDialogTrigger({
    super.key,
    required this.trigger,
    required this.builder,
    this.type = SpectrumDialogType.modal,
    this.isDismissible = false,
    this.placement = SpectrumPopoverPlacement.bottom,
  });

  @override
  Widget build(BuildContext context) {
    if (type == SpectrumDialogType.popover) {
      // When the type is popover, the dialog is the content of a popover anchored
      // to the trigger, without padding, since the dialog has its own.
      return SpectrumPopover(
        placement: placement,
        padding: EdgeInsets.zero,
        trigger: trigger,
        child: Builder(builder: builder),
      );
    }

    // Otherwise the trigger opens the dialog as a modal over the app.
    return trigger(
      context,
      () => showSpectrumDialog<void>(context: context, isDismissible: isDismissible, builder: builder),
    );
  }
}
