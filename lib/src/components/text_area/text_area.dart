import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Text Area: a multiline text input that grows with its text, with a
/// label, a help text and an error message.
class SpectrumTextArea extends StatelessWidget {
  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Controller of the text. Without it, the field keeps its own, starting with value.
  final TextEditingController? controller;

  /// Text at start when there is no controller.
  final String? value;

  /// Text shown while the field is empty. Spectrum 2 recommends a description instead.
  final String? placeholder;

  /// Shows the field in red with the error message.
  final bool isInvalid;

  /// Marks the field as required next to its label.
  final bool isRequired;

  /// Grays out the field and ignores input.
  final bool isDisabled;

  /// Shows the text but ignores changes.
  final bool isReadOnly;

  /// Focuses the field as soon as it is shown.
  final bool isAutoFocus;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  /// Called with the text on every change.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the user submits it, like with the Enter key.
  final ValueChanged<String>? onSubmitted;

  /// Lines shown while the text is short, 3 by default.
  final int minLines;

  /// Most lines shown before the text scrolls. Null grows without limit.
  final int? maxLines;

  const SpectrumTextArea({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.controller,
    this.value,
    this.placeholder,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.isAutoFocus = false,
    this.labelPosition,
    this.onChanged,
    this.onSubmitted,
    this.minLines = 3,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    // Spectrum 2 text area: the field box growing with its lines.
    final isDisabled = this.isDisabled || SpectrumForm.isDisabledOf(context);

    return SpectrumField(
      label: label,
      description: description,
      errorMessage: errorMessage,
      contextualHelp: contextualHelp,
      isInvalid: isInvalid,
      isRequired: isRequired,
      isDisabled: isDisabled,
      labelPosition: labelPosition,
      input: SpectrumFieldInput(
        controller: controller,
        value: value,
        placeholder: placeholder,
        isInvalid: isInvalid,
        isDisabled: isDisabled,
        isReadOnly: isReadOnly,
        isAutoFocus: isAutoFocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
