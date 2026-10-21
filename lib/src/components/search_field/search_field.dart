import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Search Field: a rounded text input with a magnifier, and a button
/// that clears the text, to search content.
class SpectrumSearchField extends StatefulWidget {
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

  /// Called when the clear button removes the text.
  final VoidCallback? onClear;

  const SpectrumSearchField({
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
    this.onClear,
  });

  @override
  State<SpectrumSearchField> createState() => _SpectrumSearchFieldState();
}

/// Keeps the controller, to show the clear button only while there is text.
class _SpectrumSearchFieldState extends State<SpectrumSearchField> {
  /// Controller used when the parent gives none.
  TextEditingController? _ownController;

  TextEditingController get _controller => widget.controller ?? _ownController!;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _ownController = TextEditingController(text: widget.value);
    }

    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _ownController?.dispose();
    super.dispose();
  }

  void _handleChange() => setState(() {});

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: widget.isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      // Spectrum 2 search field: a fully rounded box, 16px from the start, with the
      // magnifier before the text and the clear button after it while there is text.
      input: Semantics(
        textField: true,
        label: widget.label?.data ?? 'Search',
        child: SpectrumFieldInput(
          controller: _controller,
          placeholder: widget.placeholder,
          isInvalid: widget.isInvalid,
          isDisabled: isDisabled,
          isReadOnly: widget.isReadOnly,
          isAutoFocus: widget.isAutoFocus,
          textInputAction: TextInputAction.search,
          radius: 999,
          padding: const EdgeInsetsDirectional.only(start: 12, end: 2),
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          leading: SpectrumIcon(SpectrumIcons.search, size: 16, color: isDisabled ? colors.outline : colors.onSurface),
          trailing: Visibility(
            visible: _controller.text.isNotEmpty && !widget.isReadOnly && !isDisabled,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Semantics(
              label: 'Clear search',
              child: SpectrumActionButton(icon: SpectrumIcon(SpectrumIcons.close), isQuiet: true, onTap: _handleClear),
            ),
          ),
        ),
      ),
    );
  }
}
