import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumLinkButton)
Widget BuildLinkButtonPresentation(BuildContext context) {
  return SpectrumLinkButton(
    href: Uri.parse(
      context.knobs.string(
        label: 'href',
        initialValue: 'https://react-spectrum.adobe.com/LinkButton',
        description: 'The address opened when the button is tapped.',
      ),
    ),
    content: context.knobs.string(
      label: 'content',
      initialValue: 'Link',
      description: 'The content to display in the Link Button.',
    ),
    variant: context.knobs.object.dropdown<SpectrumButtonVariant>(
      label: 'variant',
      options: SpectrumButtonVariant.values,
      labelBuilder: (SpectrumButtonVariant value) => value.name,
      description: "The visual style of the button.",
    ),
    isOutline: context.knobs.object.segmented<bool>(
      label: 'isOutline',
      options: [true, false],
      initialOption: false,
      description: "Whether the button draws only a border instead of a filled background.",
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: "Whether the button is disabled.",
    ),
    staticColor: context.knobs.objectOrNull.dropdown<SpectrumStaticColor>(
      label: 'staticColor',
      options: SpectrumStaticColor.values,
      labelBuilder: (SpectrumStaticColor value) => value.name,
      description: "Fixed white or black colors for buttons over images or colored backgrounds.",
    ),
  );
}
