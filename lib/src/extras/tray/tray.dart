import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Shows a Spectrum Tray: a panel that slides up from the bottom of the screen over a
/// dark underlay, the mobile place of popovers and dialogs. Returns the value it closes with.
Future<T?> showSpectrumTray<T>({required BuildContext context, required WidgetBuilder builder}) {
  final colors = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: isDark ? colors.surfaceContainer : colors.surface,
    barrierColor: SpectrumColors.black.withValues(alpha: 0.5),
    // Spectrum tray: 10px corners at the top, up to 90% of the screen high.
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
    constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
    builder: (context) => SpectrumTray(child: builder(context)),
  );
}

/// Spectrum Tray: the content of a tray shown with showSpectrumTray, with the
/// padding of Spectrum and the bottom inset of the device.
class SpectrumTray extends StatelessWidget {
  /// Content of the tray.
  final Widget child;

  const SpectrumTray({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}
