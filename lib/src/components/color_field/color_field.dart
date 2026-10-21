import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Color Field: a text field to type a color in hexadecimal, like #2D9D78,
/// with a label, a help text and an error message.
class SpectrumColorField extends StatefulWidget {
  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid. Without it, a typed
  /// text that is not a color only turns the field red.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Color at start. When the parent changes it, the field follows.
  final Color? value;

  /// Shows the field in red with the error message.
  final bool isInvalid;

  /// Marks the field as required next to its label.
  final bool isRequired;

  /// Grays out the field and ignores input.
  final bool isDisabled;

  /// Shows the color but ignores changes.
  final bool isReadOnly;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  /// Called with the color when a valid one is typed, or null when the field is emptied.
  final ValueChanged<Color?>? onChange;

  const SpectrumColorField({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.labelPosition,
    this.onChange,
  });

  @override
  State<SpectrumColorField> createState() => _SpectrumColorFieldState();
}

class _SpectrumColorFieldState extends State<SpectrumColorField> {
  final TextEditingController _controller = TextEditingController();

  /// Whether the typed text is not a color.
  bool _isTypedInvalid = false;

  @override
  void initState() {
    super.initState();
    _controller.text = _format(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumColorField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _controller.text = _format(widget.value);
      _isTypedInvalid = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(Color? color) {
    if (color == null) {
      return '';
    }

    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  /// Reads #RGB, #RRGGBB or #RRGGBBAA, with or without the #.
  Color? _parse(String text) {
    var hex = text.trim().replaceFirst('#', '');

    if (hex.length == 3) {
      hex = hex.split('').map((digit) => '$digit$digit').join();
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
    } else if (hex.length == 8) {
      hex = '${hex.substring(6)}${hex.substring(0, 6)}';
    } else {
      return null;
    }

    final value = int.tryParse(hex, radix: 16);
    return value == null ? null : Color(value);
  }

  /// When the field loses the focus or is submitted, the text is checked and formatted.
  void _commit() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() => _isTypedInvalid = false);
      widget.onChange?.call(null);
      return;
    }

    final color = _parse(text);

    if (color == null) {
      setState(() => _isTypedInvalid = true);
    } else {
      setState(() => _isTypedInvalid = false);
      _controller.text = _format(color);
      widget.onChange?.call(color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final isInvalid = widget.isInvalid || _isTypedInvalid;

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      input: SpectrumFieldInput(
        controller: _controller,
        isInvalid: isInvalid,
        isDisabled: isDisabled,
        isReadOnly: widget.isReadOnly,
        onSubmitted: (_) => _commit(),
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            _commit();
          }
        },
      ),
    );
  }
}
