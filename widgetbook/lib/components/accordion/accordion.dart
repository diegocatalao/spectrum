import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

bool _IsQuietKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isQuiet',
    options: [true, false],
    initialOption: false,
    description: 'Whether the accordion should be displayed with a quiet style.',
  );
}

bool _AllowMultipleKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'allowMultiple',
    options: [true, false],
    initialOption: false,
    description: 'Whether multiple accordion items can be expanded at the same time.',
  );
}

bool _IsDisabledKnobsFn(BuildContext context) {
  return context.knobs.object.segmented<bool>(
    label: 'isDisabled',
    options: [true, false],
    initialOption: false,
    description: 'Whether all accordion items are disabled.',
  );
}

VisualDensity _DensityKnobsFn(BuildContext context) {
  return context.knobs.object.dropdown<VisualDensity>(
    label: 'density',
    options: [VisualDensity.comfortable, VisualDensity.compact, VisualDensity.standard],
    initialOption: VisualDensity.standard,
    description: 'Vertical and horizontal compactness of the accordion items.',
    // VisualDensity has no name, so its toString() would be shown,
    // with the horizontal and vertical values in a long text.
    labelBuilder: (VisualDensity value) {
      switch (value) {
        case VisualDensity.comfortable:
          return 'comfortable';
        case VisualDensity.compact:
          return 'compact';
        case VisualDensity.standard:
        default:
          return 'standard';
      }
    },
  );
}

@widgetbook.UseCase(name: 'Presentation', type: SpectrumAccordion)
Widget BuildAccordionPresentation(BuildContext context) {
  return SpectrumAccordion(
    density: _DensityKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    allowMultiple: _AllowMultipleKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    onExpansionChange: (index, expanded) => log("BuildAccordionPresentation item $index expanded: $expanded."),
    items: [
      SpectrumAccordionItem(title: Text('Personal Information'), panel: Text('Personal information from here.')),
      SpectrumAccordionItem(title: Text('Billing Address'), panel: Text('Billing Address from here.')),
    ],
  );
}

@widgetbook.UseCase(name: 'Expanding', type: SpectrumAccordion)
Widget BuildAccordionExpanding(BuildContext context) {
  return SpectrumAccordion(
    density: _DensityKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    allowMultiple: _AllowMultipleKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    items: [
      SpectrumAccordionItem(
        isExpanded: true,
        title: Text('Personal Information'),
        panel: Text('Personal information expanded from here.'),
      ),
      SpectrumAccordionItem(title: Text('Billing Address'), panel: Text('Billing Address from here.')),
    ],
  );
}

@widgetbook.UseCase(name: 'Actions', type: SpectrumAccordion)
Widget BuildAccordionActions(BuildContext context) {
  return SpectrumAccordion(
    density: _DensityKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    allowMultiple: _AllowMultipleKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    items: [
      SpectrumAccordionItem(
        title: Text('Personal Information'),
        panel: Text('Personal information expanded from here.'),
        actions: [
          SpectrumActionButton(
            icon: SpectrumIcon(SpectrumIcons.edit),
            child: Text("Edit"),
            onTap: () => log("BuildAccordionActions button 'EDIT' was tapped."),
          ),
          SpectrumActionButton(
            icon: SpectrumIcon(SpectrumIcons.delete),
            isQuiet: _IsQuietKnobsFn(context),
            child: Text("Remove"),
            onTap: () => log("BuildAccordionActions button 'REMOVE' was tapped."),
          ),
        ],
      ),
      SpectrumAccordionItem(title: Text('Billing Address'), panel: Text('Billing Address from here.')),
    ],
  );
}

@widgetbook.UseCase(name: 'Disabled Item', type: SpectrumAccordion)
Widget BuildAccordionDisabledItem(BuildContext context) {
  return SpectrumAccordion(
    density: _DensityKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    allowMultiple: _AllowMultipleKnobsFn(context),
    items: [
      SpectrumAccordionItem(title: Text('Personal Information'), panel: Text('Personal information from here.')),
      SpectrumAccordionItem(
        isDisabled: true,
        title: Text('Billing Address'),
        panel: Text('Billing Address from here.'),
      ),
      SpectrumAccordionItem(title: Text('Shipping Address'), panel: Text('Shipping Address from here.')),
    ],
  );
}

@widgetbook.UseCase(name: 'Long Title', type: SpectrumAccordion)
Widget BuildAccordionLongTitle(BuildContext context) {
  return SpectrumAccordion(
    density: _DensityKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    allowMultiple: _AllowMultipleKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    items: [
      SpectrumAccordionItem(
        title: Text(
          context.knobs.string(
            label: 'title',
            initialValue: 'Personal Information, contact details and the preferences used across every project',
            description: 'Title of the first item, to check how a long text wraps or overflows.',
          ),
        ),
        panel: Text('Personal information from here.'),
        actions: [
          SpectrumActionButton(
            icon: SpectrumIcon(SpectrumIcons.edit),
            child: Text("Edit"),
            onTap: () => log("BuildAccordionLongTitle button 'EDIT' was tapped."),
          ),
        ],
      ),
      SpectrumAccordionItem(title: Text('Billing Address'), panel: Text('Billing Address from here.')),
    ],
  );
}

@widgetbook.UseCase(name: 'Rich Panel', type: SpectrumAccordion)
Widget BuildAccordionRichPanel(BuildContext context) {
  return SpectrumAccordion(
    density: _DensityKnobsFn(context),
    isQuiet: _IsQuietKnobsFn(context),
    allowMultiple: _AllowMultipleKnobsFn(context),
    isDisabled: _IsDisabledKnobsFn(context),
    items: [
      SpectrumAccordionItem(
        isExpanded: true,
        title: Text('Personal Information'),
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text('Name: Jane Doe'),
            Text('Email: jane.doe@example.com'),
            Text('Phone: +1 555 0100'),
            const SpectrumDivider(),
            Row(
              spacing: 8,
              children: [
                SpectrumActionButton(
                  child: Text("Cancel"),
                  onTap: () => log("BuildAccordionRichPanel button 'CANCEL' was tapped."),
                ),
                SpectrumActionButton(
                  child: Text("Save"),
                  onTap: () => log("BuildAccordionRichPanel button 'SAVE' was tapped."),
                ),
              ],
            ),
          ],
        ),
      ),
      SpectrumAccordionItem(title: Text('Billing Address'), panel: Text('Billing Address from here.')),
    ],
  );
}
