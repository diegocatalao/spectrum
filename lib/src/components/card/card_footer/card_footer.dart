import 'package:flutter/material.dart';

/// Spectrum Card Footer: the row at the bottom of a SpectrumCard, with its actions
/// or details spread from one side to the other.
class SpectrumCardFooter extends StatelessWidget {
  /// Widgets of the footer, like a SpectrumStatusLight and a SpectrumButton.
  final List<Widget> children;

  const SpectrumCardFooter({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    // Spectrum 2 footer: the widgets aligned at the bottom, spread with 8px between them.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: children,
    );
  }
}
