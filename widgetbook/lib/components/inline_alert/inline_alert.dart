import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumInlineAlert)
Widget BuildInlineAlertPresentation(BuildContext context) {
  return SizedBox(
    width: 360,
    child: SpectrumInlineAlert(
      variant: context.knobs.object.dropdown<SpectrumInlineAlertVariant>(
        label: 'variant',
        options: SpectrumInlineAlertVariant.values,
        initialOption: SpectrumInlineAlertVariant.informative,
        labelBuilder: (SpectrumInlineAlertVariant value) => value.name,
        description: 'The meaning of the alert, which picks its colors and icon.',
      ),
      fillStyle: context.knobs.object.segmented<SpectrumInlineAlertFillStyle>(
        label: 'fillStyle',
        options: SpectrumInlineAlertFillStyle.values,
        initialOption: SpectrumInlineAlertFillStyle.border,
        labelBuilder: (SpectrumInlineAlertFillStyle value) => value.name,
        description: 'How the alert is drawn.',
      ),
      heading: Text(
        context.knobs.string(label: 'heading', initialValue: 'Payment information', description: 'The title.'),
      ),
      child: Text(
        context.knobs.string(
          label: 'content',
          initialValue: 'Enter your billing address, shipping address, and payment method to complete the purchase.',
          description: 'The text of the alert.',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Variants', type: SpectrumInlineAlert)
Widget BuildInlineAlertVariants(BuildContext context) {
  final fillStyle = context.knobs.object.segmented<SpectrumInlineAlertFillStyle>(
    label: 'fillStyle',
    options: SpectrumInlineAlertFillStyle.values,
    initialOption: SpectrumInlineAlertFillStyle.border,
    labelBuilder: (SpectrumInlineAlertFillStyle value) => value.name,
    description: 'How the alerts are drawn.',
  );

  return SizedBox(
    width: 360,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        for (final variant in SpectrumInlineAlertVariant.values)
          SpectrumInlineAlert(
            variant: variant,
            fillStyle: fillStyle,
            heading: Text('${variant.name[0].toUpperCase()}${variant.name.substring(1)}'),
            child: Text('A message about the content next to it.'),
          ),
      ],
    ),
  );
}
