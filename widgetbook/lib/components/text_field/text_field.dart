import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

bool _knob(BuildContext context, String label, String description) {
  return context.knobs.object.segmented<bool>(
    label: label,
    options: [true, false],
    initialOption: false,
    description: description,
  );
}

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTextField)
Widget BuildTextFieldPresentation(BuildContext context) {
  return SizedBox(
    width: 280,
    child: SpectrumTextField(
      label: Text(context.knobs.string(label: 'label', initialValue: 'Name', description: 'The label.')),
      description: Text('Your full name, as in your documents.'),
      errorMessage: Text('Enter your name.'),
      contextualHelp: SpectrumContextualHelp(
        heading: Text('Why the name?'),
        child: Text('It is shown on your invoices.'),
      ),
      isInvalid: _knob(context, 'isInvalid', 'Whether the field shows the error.'),
      isRequired: _knob(context, 'isRequired', 'Whether the label shows the required asterisk.'),
      isDisabled: _knob(context, 'isDisabled', 'Whether the field is disabled.'),
      isReadOnly: _knob(context, 'isReadOnly', 'Whether the text can not be changed.'),
      labelPosition: context.knobs.object.segmented<SpectrumLabelPosition>(
        label: 'labelPosition',
        options: SpectrumLabelPosition.values,
        initialOption: SpectrumLabelPosition.top,
        labelBuilder: (SpectrumLabelPosition value) => value.name,
        description: 'Where the label is placed.',
      ),
      onChanged: (value) => log('BuildTextFieldPresentation text: $value.'),
    ),
  );
}

@widgetbook.UseCase(name: 'Form', type: SpectrumTextField)
Widget BuildTextFieldForm(BuildContext context) {
  return SizedBox(
    width: 360,
    child: SpectrumForm(
      labelPosition: context.knobs.object.segmented<SpectrumLabelPosition>(
        label: 'labelPosition',
        options: SpectrumLabelPosition.values,
        initialOption: SpectrumLabelPosition.top,
        labelBuilder: (SpectrumLabelPosition value) => value.name,
        description: 'Where the labels of the form are placed.',
      ),
      necessityIndicator: context.knobs.object.segmented<SpectrumNecessityIndicator>(
        label: 'necessityIndicator',
        options: SpectrumNecessityIndicator.values,
        initialOption: SpectrumNecessityIndicator.icon,
        labelBuilder: (SpectrumNecessityIndicator value) => value.name,
        description: 'How the required fields are marked.',
      ),
      children: [
        SpectrumTextField(label: Text('Name'), isRequired: true),
        SpectrumTextField(label: Text('Email'), keyboardType: TextInputType.emailAddress),
        SpectrumTextField(label: Text('Password'), isObscured: true, isRequired: true),
      ],
    ),
  );
}
