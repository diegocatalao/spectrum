import 'package:flutter/material.dart';

/// Spectrum Menu: a list of options shown directly on the screen, out of a
/// popover. Inside an Action Menu, pass the options as its children instead.
class SpectrumMenu extends StatelessWidget {
  /// Options of the menu: SpectrumMenuItem, SpectrumMenuSection, SpectrumSubmenuTrigger
  /// and SpectrumDivider.
  final List<Widget> children;

  /// Text read by screen readers to describe the menu.
  final String? label;

  const SpectrumMenu({super.key, this.children = const [], this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: label,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
