import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumCheckbox)
Widget BuildCheckboxPresentation(BuildContext context) {
  return SpectrumCheckbox(
    isSelected: context.knobs.object.segmented<bool>(
      label: 'isSelected',
      options: [true, false],
      initialOption: false,
      description: 'Whether the box starts checked.',
    ),
    isIndeterminate: context.knobs.object.segmented<bool>(
      label: 'isIndeterminate',
      options: [true, false],
      initialOption: false,
      description: 'Whether the box shows a dash, for a partially checked group.',
    ),
    isEmphasized: context.knobs.object.segmented<bool>(
      label: 'isEmphasized',
      options: [true, false],
      initialOption: false,
      description: 'Whether the checked box is filled with the accent blue.',
    ),
    isDisabled: context.knobs.object.segmented<bool>(
      label: 'isDisabled',
      options: [true, false],
      initialOption: false,
      description: 'Whether the box is disabled.',
    ),
    onChanged: (value) => log('BuildCheckboxPresentation selected: $value.'),
    description: Text(
      context.knobs.string(
        label: 'description',
        initialValue: 'Get the news once a week.',
        description: 'The text below the label.',
      ),
    ),
    child: Text(
      context.knobs.string(label: 'content', initialValue: 'Subscribe', description: 'The label of the checkbox.'),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: SpectrumCheckbox)
Widget BuildCheckboxStates(BuildContext context) {
  // One row per style and one column per state, to compare all the boxes at once.
  final rows = [('Default', false, false), ('Emphasized', true, false), ('Disabled', false, true)];

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 16,
    children: [
      for (final (name, isEmphasized, isDisabled) in rows)
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            SizedBox(width: 96, child: Text(name)),
            SpectrumCheckbox(isEmphasized: isEmphasized, isDisabled: isDisabled),
            SpectrumCheckbox(isSelected: true, isEmphasized: isEmphasized, isDisabled: isDisabled),
            SpectrumCheckbox(isIndeterminate: true, isEmphasized: isEmphasized, isDisabled: isDisabled),
          ],
        ),
    ],
  );
}

@widgetbook.UseCase(name: 'Select All', type: SpectrumCheckbox)
Widget BuildCheckboxSelectAll(BuildContext context) {
  return const _SelectAll();
}

/// A "select all" box that is indeterminate while only some options are checked.
class _SelectAll extends StatefulWidget {
  const _SelectAll();

  @override
  State<_SelectAll> createState() => _SelectAllState();
}

class _SelectAllState extends State<_SelectAll> {
  final List<String> _options = ['Photos', 'Videos', 'Documents'];
  final Set<String> _selected = {'Photos'};

  @override
  Widget build(BuildContext context) {
    final isAll = _selected.length == _options.length;
    final isSome = _selected.isNotEmpty && !isAll;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        SpectrumCheckbox(
          isSelected: isAll,
          isIndeterminate: isSome,
          onChanged: (value) => setState(() {
            _selected.clear();

            if (value) {
              _selected.addAll(_options);
            }
          }),
          child: const Text('Select all'),
        ),
        for (final option in _options)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: SpectrumCheckbox(
              isSelected: _selected.contains(option),
              onChanged: (value) => setState(() {
                if (value) {
                  _selected.add(option);
                } else {
                  _selected.remove(option);
                }
              }),
              child: Text(option),
            ),
          ),
      ],
    );
  }
}
