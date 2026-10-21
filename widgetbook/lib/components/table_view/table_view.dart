import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Presentation', type: SpectrumTableView)
Widget BuildTableViewPresentation(BuildContext context) {
  return _Files(
    selects: context.knobs.object.segmented<SpectrumSelects>(
      label: 'selects',
      options: SpectrumSelects.values,
      initialOption: SpectrumSelects.multiple,
      labelBuilder: (SpectrumSelects value) => value.name,
      description: 'Whether no row, one row or many rows can be selected.',
    ),
    density: context.knobs.object.segmented<VisualDensity>(
      label: 'density',
      options: [VisualDensity.compact, VisualDensity.standard, VisualDensity.comfortable],
      initialOption: VisualDensity.standard,
      labelBuilder: (VisualDensity value) {
        if (value == VisualDensity.compact) {
          return 'compact';
        } else if (value == VisualDensity.comfortable) {
          return 'spacious';
        } else {
          return 'regular';
        }
      },
      description: 'The height of the rows.',
    ),
    isQuiet: context.knobs.object.segmented<bool>(
      label: 'isQuiet',
      options: [true, false],
      initialOption: false,
      description: 'Whether the table has no border nor background.',
    ),
  );
}

/// A table of files that sorts its rows by the tapped column.
class _Files extends StatefulWidget {
  final SpectrumSelects selects;
  final VisualDensity density;
  final bool isQuiet;

  const _Files({required this.selects, required this.density, required this.isQuiet});

  @override
  State<_Files> createState() => _FilesState();
}

class _FilesState extends State<_Files> {
  final List<(String, String, int)> _files = [
    ('Games', 'File folder', 6),
    ('Program Files', 'File folder', 4),
    ('bootmgr', 'System file', 1),
    ('log.txt', 'Text document', 2),
  ];
  Object _column = 'name';
  SpectrumSortDirection _direction = SpectrumSortDirection.ascending;

  @override
  Widget build(BuildContext context) {
    final sorted = [..._files]
      ..sort((a, b) {
        final int result;

        if (_column == 'size') {
          result = a.$3.compareTo(b.$3);
        } else if (_column == 'type') {
          result = a.$2.compareTo(b.$2);
        } else {
          result = a.$1.toLowerCase().compareTo(b.$1.toLowerCase());
        }

        return _direction == SpectrumSortDirection.ascending ? result : -result;
      });

    return SizedBox(
      width: 560,
      child: SpectrumTableView(
        selects: widget.selects,
        density: widget.density,
        isQuiet: widget.isQuiet,
        sortColumn: _column,
        sortDirection: _direction,
        onSortChange: (column, direction) => setState(() {
          _column = column;
          _direction = direction;
        }),
        onSelectionChange: (value) => log('BuildTableViewPresentation selected: $value.'),
        header: SpectrumTableHeader(
          children: [
            SpectrumColumn(id: 'name', flex: 2, allowsSorting: true, child: Text('Name')),
            SpectrumColumn(id: 'type', allowsSorting: true, child: Text('Type')),
            SpectrumColumn(id: 'size', width: 120, align: TextAlign.end, allowsSorting: true, child: Text('Size')),
          ],
        ),
        body: SpectrumTableBody(
          children: [
            for (final (name, type, size) in sorted)
              SpectrumRow(
                id: name,
                children: [
                  SpectrumCell(child: Text(name)),
                  SpectrumCell(child: Text(type)),
                  SpectrumCell(child: Text('$size MB')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
