import 'package:flutter/material.dart';

/// Spectrum Disclosure Title: the text of a SpectrumDisclosureHeader, announced
/// by screen readers as a heading.
class SpectrumDisclosureTitle extends StatelessWidget {
  /// Text of the title.
  final Text child;

  const SpectrumDisclosureTitle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(header: true, child: child);
  }
}
