import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Custom Dialog: a dialog surface with any content, for layouts the
/// other dialogs do not cover.
class SpectrumCustomDialog extends StatelessWidget {
  /// Content of the dialog.
  final Widget child;

  /// Space around the content, 32px by default.
  final EdgeInsetsGeometry padding;

  /// Shows a close button at the top right.
  final bool isDismissible;

  /// Width of the dialog, 480px by default.
  final double width;

  const SpectrumCustomDialog({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
    this.isDismissible = false,
    this.width = 480,
  });

  @override
  Widget build(BuildContext context) {
    return SpectrumDialogSurface(
      width: width,
      child: Stack(
        children: [
          Padding(padding: padding, child: child),
          // The close button stands 12px from the top right corner.
          PositionedDirectional(
            top: 12,
            end: 12,
            child: Visibility(
              visible: isDismissible,
              child: SpectrumActionButton(
                icon: SpectrumIcon(SpectrumIcons.close),
                isQuiet: true,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
