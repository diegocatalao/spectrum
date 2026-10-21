import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Labeled Value: a value that can not be edited, with a label above it,
/// aligned with the fields of a form.
class SpectrumLabeledValue extends StatelessWidget {
  /// Label of the value.
  final Text label;

  /// Value shown, usually a Text already formatted for the locale.
  final Widget value;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumLabeledValue({
    super.key,
    required this.label,
    required this.value,
    this.contextualHelp,
    this.labelPosition,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Spectrum 2 labeled value: the field label and the 14px gray-800 value, centered
    // in 32px inside a form so it lines up with the fields.
    return SpectrumField(
      label: label,
      contextualHelp: contextualHelp,
      labelPosition: labelPosition,
      // The value never shows the necessity indicator, as in Spectrum 2.
      necessityIndicator: SpectrumNecessityIndicator.icon,
      input: Container(
        constraints: const BoxConstraints(minHeight: 32),
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(color: colors.onSurface),
          child: value,
        ),
      ),
    );
  }
}
