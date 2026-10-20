import 'package:flutter/material.dart';

/// Where the labels of the fields of a SpectrumForm are placed.
enum SpectrumLabelPosition { top, side }

/// How the labels of the fields of a SpectrumForm are aligned.
enum SpectrumLabelAlign { start, end }

/// How the fields of a SpectrumForm show that they are required or optional.
enum SpectrumNecessityIndicator { icon, label }

/// Spectrum Form: groups fields with the Spectrum 2 spacing and shares its
/// options, like isDisabled and isEmphasized, with every field inside it.
class SpectrumForm extends StatelessWidget {
  /// Fields of the form, shown from top to bottom.
  final List<Widget> children;

  /// Where the labels of the fields are placed, above them by default.
  final SpectrumLabelPosition labelPosition;

  /// How the labels of the fields are aligned.
  final SpectrumLabelAlign labelAlign;

  /// How the fields show that they are required or optional.
  final SpectrumNecessityIndicator necessityIndicator;

  /// Marks every field as required.
  final bool isRequired;

  /// Grays out every field and ignores hover and tap.
  final bool isDisabled;

  /// Shows every field with its emphasized style, like the accent checkboxes.
  final bool isEmphasized;

  /// Key of the Flutter Form inside, used to validate, save or reset the fields.
  final GlobalKey<FormState>? formKey;

  const SpectrumForm({
    super.key,
    this.children = const [],
    this.labelPosition = SpectrumLabelPosition.top,
    this.labelAlign = SpectrumLabelAlign.start,
    this.necessityIndicator = SpectrumNecessityIndicator.icon,
    this.isRequired = false,
    this.isDisabled = false,
    this.isEmphasized = false,
    this.formKey,
  });

  /// Returns True when the field is inside a disabled form.
  static bool isDisabledOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>()?.form.isDisabled ?? false;
  }

  /// Returns True when the field is inside an emphasized form.
  static bool isEmphasizedOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>()?.form.isEmphasized ?? false;
  }

  /// Returns True when the field is inside a form where every field is required.
  static bool isRequiredOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>()?.form.isRequired ?? false;
  }

  /// Returns the label position of the form, or top outside of a form.
  static SpectrumLabelPosition labelPositionOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>()?.form.labelPosition ?? SpectrumLabelPosition.top;
  }

  /// Returns the label alignment of the form, or start outside of a form.
  static SpectrumLabelAlign labelAlignOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>()?.form.labelAlign ?? SpectrumLabelAlign.start;
  }

  /// Returns the necessity indicator of the form, or icon outside of a form.
  static SpectrumNecessityIndicator necessityIndicatorOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>()?.form.necessityIndicator ??
        SpectrumNecessityIndicator.icon;
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter Form keeps the validation of the fields, and the scope shares
    // the options of this form with every field inside it.
    return Form(
      key: formKey,
      child: _FormScope(
        form: this,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Spectrum 2 gap between the fields of a form, in the M size.
          spacing: 24,
          children: children,
        ),
      ),
    );
  }
}

/// Shares the options of the form with the fields inside it.
class _FormScope extends InheritedWidget {
  final SpectrumForm form;

  const _FormScope({required this.form, required super.child});

  @override
  bool updateShouldNotify(_FormScope oldWidget) {
    return oldWidget.form.isDisabled != form.isDisabled ||
        oldWidget.form.isEmphasized != form.isEmphasized ||
        oldWidget.form.isRequired != form.isRequired ||
        oldWidget.form.labelPosition != form.labelPosition ||
        oldWidget.form.labelAlign != form.labelAlign ||
        oldWidget.form.necessityIndicator != form.necessityIndicator;
  }
}
