import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Frame shared by the Spectrum 2 fields, like SpectrumTextField: the label with the
/// necessity indicator and the contextual help, the input, and the help text or the
/// error message below it. The options of a SpectrumForm around it apply too.
class SpectrumField extends StatelessWidget {
  /// Label of the field.
  final Text? label;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Help text below the input, hidden while the field is invalid.
  final Text? description;

  /// Error message below the input, shown while the field is invalid.
  final Text? errorMessage;

  /// Whether the field is invalid.
  final bool isInvalid;

  /// Whether the field is required.
  final bool isRequired;

  /// Whether the field is disabled.
  final bool isDisabled;

  /// Where the label is placed, from the form when null.
  final SpectrumLabelPosition? labelPosition;

  /// How the label is aligned, from the form when null.
  final SpectrumLabelAlign? labelAlign;

  /// How the field shows that it is required, from the form when null.
  final SpectrumNecessityIndicator? necessityIndicator;

  /// The input of the field, usually a SpectrumFieldBox.
  final Widget input;

  const SpectrumField({
    super.key,
    this.label,
    this.contextualHelp,
    this.description,
    this.errorMessage,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.labelPosition,
    this.labelAlign,
    this.necessityIndicator,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final position = labelPosition ?? SpectrumForm.labelPositionOf(context);
    final align = labelAlign ?? SpectrumForm.labelAlignOf(context);
    final necessity = necessityIndicator ?? SpectrumForm.necessityIndicatorOf(context);
    final isFieldRequired = isRequired || SpectrumForm.isRequiredOf(context);
    final isFieldDisabled = isDisabled || SpectrumForm.isDisabledOf(context);
    final labelColor = isFieldDisabled ? colors.outline : colors.onSurfaceVariant;
    final String marker;

    if (isFieldRequired && necessity == SpectrumNecessityIndicator.icon) {
      // When the field is required and the indicator is an icon, an asterisk follows the label.
      marker = ' *';
    } else if (isFieldRequired) {
      // When the indicator is a label, "(required)" follows the label.
      marker = ' (required)';
    } else if (necessity == SpectrumNecessityIndicator.label) {
      // Optional fields say so when the indicator is a label.
      marker = ' (optional)';
    } else {
      marker = '';
    }

    // Spectrum 2 field label: 14px gray-700, with the contextual help on its right.
    final labelRow = Visibility(
      visible: label != null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Flexible(
            child: DefaultTextStyle(
              style: style.copyWith(color: labelColor),
              textAlign: align == SpectrumLabelAlign.end ? TextAlign.end : TextAlign.start,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: label?.data ?? ''),
                    TextSpan(text: marker),
                  ],
                ),
              ),
            ),
          ),
          Visibility(visible: contextualHelp != null, child: contextualHelp ?? const SizedBox.shrink()),
        ],
      ),
    );

    final Widget? helpText;

    if (isInvalid && errorMessage != null) {
      // When the field is invalid, the error message is red, after the alert icon.
      helpText = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SpectrumIcon(SpectrumIcons.alert, size: 14, color: colors.error),
          ),
          Expanded(
            child: DefaultTextStyle(
              style: style.copyWith(color: colors.error),
              child: errorMessage!,
            ),
          ),
        ],
      );
    } else if (description != null) {
      // Otherwise the description is gray-700, or gray-400 when disabled.
      helpText = DefaultTextStyle(
        style: style.copyWith(color: labelColor),
        child: description!,
      );
    } else {
      helpText = null;
    }

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4,
      children: [input, ?helpText],
    );

    if (position == SpectrumLabelPosition.side) {
      // When the label is on the side, it stands 12px on the left of the input, in
      // the middle of its first line.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Padding(padding: const EdgeInsets.only(top: 7), child: labelRow),
          Expanded(child: column),
        ],
      );
    }

    // Otherwise the label stands 4px above the input.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align == SpectrumLabelAlign.end ? CrossAxisAlignment.end : CrossAxisAlignment.stretch,
      spacing: 4,
      children: [labelRow, column],
    );
  }
}

/// Box of the Spectrum 2 inputs: 32px high (or more for text areas), 2px border in
/// gray-300, gray-900 while focused, red while invalid, and 8px corners.
class SpectrumFieldBox extends StatelessWidget {
  /// Content of the box, usually the text input with its icons.
  final Widget child;

  /// Whether the input inside has the focus.
  final bool isFocused;

  /// Whether the field is invalid.
  final bool isInvalid;

  /// Whether the field is disabled.
  final bool isDisabled;

  /// Corners of the box, 8px by default; search fields are fully rounded.
  final double radius;

  /// Space inside the box, 12px on the sides by default.
  final EdgeInsetsGeometry padding;

  const SpectrumFieldBox({
    super.key,
    required this.child,
    this.isFocused = false,
    this.isInvalid = false,
    this.isDisabled = false,
    this.radius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color border;

    if (isDisabled) {
      // When the field is disabled, the border is the disabled gray-200.
      border = colors.outlineVariant;
    } else if (isInvalid && isFocused) {
      // When the invalid field has the focus, the border is a darker red.
      border = isDark ? SpectrumDarkColors.red1000 : SpectrumColors.red1000;
    } else if (isInvalid) {
      // When the field is invalid, the border is red.
      border = colors.error;
    } else if (isFocused) {
      // When the field has the focus, the border is gray-900.
      border = colors.inverseSurface;
    } else {
      // Otherwise the border is gray-300.
      border = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
    }

    return AnimatedContainer(
      duration: SpectrumMotion.duration,
      curve: SpectrumMotion.curve,
      constraints: const BoxConstraints(minHeight: 32),
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 2),
      ),
      child: child,
    );
  }
}

/// Text input shared by the Spectrum 2 text fields: the input inside a
/// SpectrumFieldBox, with optional widgets before and after the text and the
/// red alert icon while invalid.
class SpectrumFieldInput extends StatefulWidget {
  /// Controller of the text. Without it, the input keeps its own, starting with value.
  final TextEditingController? controller;

  /// Text at start when there is no controller.
  final String? value;

  /// Text shown while the input is empty. Spectrum 2 recommends a description instead.
  final String? placeholder;

  /// Widget before the text, like the magnifier of the search field.
  final Widget? leading;

  /// Widget after the text, like the steppers of the number field.
  final Widget? trailing;

  final bool isInvalid;
  final bool isDisabled;
  final bool isReadOnly;
  final bool isAutoFocus;

  /// Hides the text, for passwords.
  final bool isObscured;

  /// Lines of the input: 1 for fields, more for text areas.
  final int? maxLines;
  final int minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Corners of the box.
  final double radius;

  /// Space inside the box.
  final EdgeInsetsGeometry padding;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<bool>? onFocusChange;

  const SpectrumFieldInput({
    super.key,
    this.controller,
    this.value,
    this.placeholder,
    this.leading,
    this.trailing,
    this.isInvalid = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.isAutoFocus = false,
    this.isObscured = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.radius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.onChanged,
    this.onSubmitted,
    this.onFocusChange,
  });

  @override
  State<SpectrumFieldInput> createState() => _SpectrumFieldInputState();
}

class _SpectrumFieldInputState extends State<SpectrumFieldInput> {
  /// Controller used when the parent gives none.
  TextEditingController? _ownController;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  TextEditingController get _controller => widget.controller ?? _ownController!;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _ownController = TextEditingController(text: widget.value);
    }

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      widget.onFocusChange?.call(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _ownController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: widget.isDisabled ? colors.outline : colors.onSurface,
    );

    return SpectrumFieldBox(
      isFocused: _isFocused,
      isInvalid: widget.isInvalid,
      isDisabled: widget.isDisabled,
      radius: widget.radius,
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: widget.maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        spacing: 6,
        children: [
          ?widget.leading,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: widget.maxLines == 1 ? 0 : 6),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !widget.isDisabled,
                readOnly: widget.isReadOnly,
                autofocus: widget.isAutoFocus,
                obscureText: widget.isObscured,
                maxLines: widget.isObscured ? 1 : widget.maxLines,
                minLines: widget.minLines,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                style: style,
                cursorColor: colors.onSurface,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                // The box draws the border, so the Material decoration is removed.
                decoration: InputDecoration.collapsed(
                  hintText: widget.placeholder,
                  hintStyle: style.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ),
          ),
          // While invalid, the red alert icon stands at the end of the text.
          Visibility(
            visible: widget.isInvalid && !widget.isDisabled,
            child: SpectrumIcon(SpectrumIcons.alert, size: 14, color: colors.error),
          ),
          ?widget.trailing,
        ],
      ),
    );
  }
}
