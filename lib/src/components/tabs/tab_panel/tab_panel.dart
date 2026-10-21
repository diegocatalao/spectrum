import 'package:flutter/material.dart';

/// Spectrum Tab Panel: the content shown by a SpectrumTabs when its tab is selected.
class SpectrumTabPanel extends StatelessWidget {
  /// Content of the panel.
  final Widget child;

  const SpectrumTabPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Spectrum 2 tab panel: the texts are gray-800.
    return Semantics(
      container: true,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: colors.onSurface),
        child: child,
      ),
    );
  }
}
