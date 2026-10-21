import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumContextualHelp)
Widget BuildContextualHelpPresentation(BuildContext context) {
  return SpectrumContextualHelp(
    variant: context.knobs.object.segmented<SpectrumContextualHelpVariant>(
      label: 'variant',
      options: SpectrumContextualHelpVariant.values,
      initialOption: SpectrumContextualHelpVariant.help,
      labelBuilder: (SpectrumContextualHelpVariant value) => value.name,
      description: 'A question mark or an "i".',
    ),
    heading: Text('What is a segment?'),
    footer: SpectrumLink(href: Uri.parse('https://example.com'), content: 'Learn more about segments'),
    child: Text(
      'Segments identify who your visitors are, what devices and services they use, where they navigated from, and much more.',
    ),
  );
}
