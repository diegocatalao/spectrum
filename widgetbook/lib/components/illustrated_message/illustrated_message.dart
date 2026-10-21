import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumIllustratedMessage)
Widget BuildIllustratedMessagePresentation(BuildContext context) {
  return SpectrumIllustratedMessage(
    orientation: context.knobs.object.segmented<Axis>(
      label: 'orientation',
      options: Axis.values,
      initialOption: Axis.vertical,
      labelBuilder: (Axis value) => value.name,
      description: 'Illustration above or on the left of the texts.',
    ),
    illustration: SpectrumIcon(SpectrumIcons.cloud, size: 96),
    heading: Text(context.knobs.string(label: 'heading', initialValue: 'No results', description: 'The title.')),
    content: Text(
      context.knobs.string(
        label: 'content',
        initialValue: 'Try another search term or remove the filters.',
        description: 'The text.',
      ),
    ),
    buttonGroup: SpectrumButtonGroup(
      children: [
        SpectrumButton(content: 'Clear filters', variant: SpectrumButtonVariant.secondary, onTap: () {}),
        SpectrumButton(content: 'New search', variant: SpectrumButtonVariant.accent, onTap: () {}),
      ],
    ),
  );
}
