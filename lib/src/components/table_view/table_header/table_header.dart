import 'package:spectrum/spectrum.dart';

/// Spectrum Table Header: the columns of a SpectrumTableView.
class SpectrumTableHeader {
  /// Columns of the table, from the start to the end.
  final List<SpectrumColumn> children;

  const SpectrumTableHeader({required this.children});
}
