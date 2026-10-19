import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumLink)
Widget BuildLinkPresentation(BuildContext context) {
  return SpectrumLink(
    href: Uri.parse(
      context.knobs.string(
        label: 'href',
        initialValue: 'https://react-spectrum.adobe.com/Link',
        description: 'The address opened when the link is tapped.',
      ),
    ),
    content: context.knobs.string(
      label: 'content',
      initialValue: 'The missing link',
      description: 'The text of the link.',
    ),
    variant: context.knobs.object.segmented<SpectrumLinkVariant>(
      label: 'variant',
      options: SpectrumLinkVariant.values,
      initialOption: SpectrumLinkVariant.primary,
      labelBuilder: (SpectrumLinkVariant value) => value.name,
      description: 'The visual style of the link.',
    ),
    isQuiet: context.knobs.object.segmented<bool>(
      label: 'isQuiet',
      options: [true, false],
      initialOption: false,
      description: 'Whether a standalone link hides its underline until hovered or focused.',
    ),
    isStandalone: context.knobs.object.segmented<bool>(
      label: 'isStandalone',
      options: [true, false],
      initialOption: false,
      description: 'Whether the link is used on its own, outside of a sentence.',
    ),
    staticColor: context.knobs.objectOrNull.dropdown<SpectrumStaticColor>(
      label: 'staticColor',
      options: SpectrumStaticColor.values,
      labelBuilder: (SpectrumStaticColor value) => value.name,
      description: 'Fixed white or black color for links over images or colored backgrounds.',
    ),
  );
}

@widgetbook.UseCase(name: 'Inside Text', type: SpectrumLink)
Widget BuildLinkInsideText(BuildContext context) {
  // A link in the middle of a sentence, the most common use of the component.
  return Text.rich(
    TextSpan(
      children: [
        const TextSpan(text: 'Read the '),
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: SpectrumLink(href: Uri.parse('https://react-spectrum.adobe.com/'), content: 'Spectrum documentation'),
        ),
        const TextSpan(text: ' before building a new component.'),
      ],
    ),
  );
}
