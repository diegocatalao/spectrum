import 'package:flutter/material.dart';

/// Spectrum Column: one column of a SpectrumTableHeader, with its title, its width
/// and whether it can sort the rows.
class SpectrumColumn {
  /// Id of the column, sent when the rows are sorted by it.
  final Object id;

  /// Title of the column.
  final Text child;

  /// Fixed width of the column. Without it, the column shares the free width by flex.
  final double? width;

  /// Share of the free width when there is no fixed width, 1 by default.
  final int flex;

  /// Alignment of the title and the cells.
  final TextAlign align;

  /// Sorts the rows by this column when its title is tapped.
  final bool allowsSorting;

  /// Draws a 1px line between this column and the next one.
  final bool showDivider;

  const SpectrumColumn({
    required this.id,
    required this.child,
    this.width,
    this.flex = 1,
    this.align = TextAlign.start,
    this.allowsSorting = false,
    this.showDivider = false,
  });
}
