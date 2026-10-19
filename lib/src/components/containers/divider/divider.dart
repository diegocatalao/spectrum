import 'package:flutter/material.dart';

class SpectrumDivider extends StatelessWidget {
  final bool vertical;

  const SpectrumDivider({super.key, this.vertical = false});

  @override
  Widget build(BuildContext context) {
    final thickness = 1.0;
    final color = Theme.of(context).colorScheme.outlineVariant;

    return Container(
      width: vertical ? thickness : double.infinity,
      height: vertical ? double.infinity : thickness,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(thickness / 2),
      ),
    );
  }
}
