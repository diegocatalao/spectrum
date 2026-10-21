import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Number Field: a text input for numbers, with buttons that decrease and
/// increase the value by its step, inside the minimum and the maximum.
class SpectrumNumberField extends StatefulWidget {
  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Number at start. When the parent changes it, the field follows.
  final num? value;

  /// Smallest number accepted.
  final num? minValue;

  /// Largest number accepted.
  final num? maxValue;

  /// Amount added or removed by the buttons and the arrow keys, 1 by default.
  final num step;

  /// Hides the decrease and increase buttons.
  final bool hideStepper;

  /// Shows the field in red with the error message.
  final bool isInvalid;

  /// Marks the field as required next to its label.
  final bool isRequired;

  /// Grays out the field and ignores input.
  final bool isDisabled;

  /// Shows the number but ignores changes.
  final bool isReadOnly;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  /// Called with the number when it changes, or null when the text is empty.
  final ValueChanged<num?>? onChanged;

  const SpectrumNumberField({
    super.key,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value,
    this.minValue,
    this.maxValue,
    this.step = 1,
    this.hideStepper = false,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.labelPosition,
    this.onChanged,
  });

  @override
  State<SpectrumNumberField> createState() => _SpectrumNumberFieldState();
}

/// Keeps the text of the number.
class _SpectrumNumberFieldState extends State<SpectrumNumberField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = _format(widget.value);
  }

  @override
  void didUpdateWidget(covariant SpectrumNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the field follows it.
    if (oldWidget.value != widget.value) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(num? value) {
    if (value == null) {
      return '';
    }

    return value == value.roundToDouble() ? value.round().toString() : value.toString();
  }

  num? get _current => num.tryParse(_controller.text.replaceAll(',', '.'));

  /// Keeps the number inside the minimum and the maximum.
  num _clamp(num value) {
    var result = value;

    if (widget.minValue != null && result < widget.minValue!) {
      result = widget.minValue!;
    }

    if (widget.maxValue != null && result > widget.maxValue!) {
      result = widget.maxValue!;
    }

    return result;
  }

  /// Adds the step times the direction (1 or -1) to the number.
  void _stepBy(int direction) {
    final base = _current ?? widget.minValue ?? 0;
    final next = _clamp(base + widget.step * direction);
    _controller.text = _format(next);
    widget.onChanged?.call(next);
  }

  /// When the field loses the focus, the number is kept inside the bounds.
  void _commit() {
    final current = _current;

    if (current != null) {
      final clamped = _clamp(current);
      _controller.text = _format(clamped);
      widget.onChanged?.call(clamped);
    } else {
      widget.onChanged?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final canChange = !isDisabled && !widget.isReadOnly;

    Widget stepButton(SpectrumIcons icon, int direction, String label) {
      // Spectrum 2 step button: a 24px gray-100 circle with the dash or the plus.
      return Semantics(
        button: true,
        label: label,
        child: SpectrumPressScale(
          isPressed: false,
          child: Material(
            color: colors.surfaceContainerHigh,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              hoverColor: colors.surfaceContainerHighest,
              onTap: canChange ? () => _stepBy(direction) : null,
              child: SizedBox.square(
                dimension: 24,
                child: Center(
                  child: SpectrumIcon(icon, size: 10, color: isDisabled ? colors.outline : colors.onSurface),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: widget.isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      // The arrow keys also step the number up and down.
      input: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () => canChange ? _stepBy(1) : null,
          const SingleActivator(LogicalKeyboardKey.arrowDown): () => canChange ? _stepBy(-1) : null,
        },
        child: SpectrumFieldInput(
          controller: _controller,
          isInvalid: widget.isInvalid,
          isDisabled: isDisabled,
          isReadOnly: widget.isReadOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          padding: EdgeInsetsDirectional.only(start: 12, end: widget.hideStepper ? 12 : 4),
          onSubmitted: (_) => _commit(),
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _commit();
            }
          },
          trailing: Visibility(
            visible: !widget.hideStepper,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                stepButton(SpectrumIcons.remove, -1, 'Decrease'),
                stepButton(SpectrumIcons.add, 1, 'Increase'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
