import 'package:spectrum/spectrum.dart';

/// Spectrum Row: one row of a SpectrumTableBody, with one cell for each column.
class SpectrumRow {
  /// Id of the row, used for the selection.
  final Object id;

  /// Cells of the row, in the order of the columns.
  final List<SpectrumCell> children;

  /// Grays out the row and ignores taps.
  final bool isDisabled;

  const SpectrumRow({required this.id, required this.children, this.isDisabled = false});
}
