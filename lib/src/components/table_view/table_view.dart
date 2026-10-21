import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Direction of the sorted column of a SpectrumTableView.
enum SpectrumSortDirection { ascending, descending }

/// Spectrum Table View: rows of data in columns, with a bold header that can sort
/// the rows, selection and density, inside a bordered box.
class SpectrumTableView extends StatefulWidget {
  /// Columns of the table.
  final SpectrumTableHeader header;

  /// Rows of the table.
  final SpectrumTableBody body;

  /// Whether no row, one row or many rows can be selected.
  final SpectrumSelects selects;

  /// Ids of the rows selected at start. When the parent changes them, the table follows.
  final Set<Object> selected;

  /// Called with the ids of the selected rows when a row is selected.
  final ValueChanged<Set<Object>>? onSelectionChange;

  /// Called with the id of the tapped row when the table has no selection.
  final ValueChanged<Object>? onAction;

  /// Id of the column the rows are sorted by.
  final Object? sortColumn;

  /// Direction of the sorted column.
  final SpectrumSortDirection sortDirection;

  /// Called with the column and the direction when a sortable column title is tapped.
  /// The parent sorts the rows.
  final void Function(Object column, SpectrumSortDirection direction)? onSortChange;

  /// Height of the rows: 32px compact, 40px standard or 48px comfortable.
  final VisualDensity density;

  /// Removes the border and the background of the table.
  final bool isQuiet;

  /// Lets the texts of the cells wrap instead of being cut with an ellipsis.
  final bool isWrapped;

  const SpectrumTableView({
    super.key,
    required this.header,
    required this.body,
    this.selects = SpectrumSelects.none,
    this.selected = const {},
    this.onSelectionChange,
    this.onAction,
    this.sortColumn,
    this.sortDirection = SpectrumSortDirection.ascending,
    this.onSortChange,
    this.density = VisualDensity.standard,
    this.isQuiet = false,
    this.isWrapped = false,
  });

  @override
  State<SpectrumTableView> createState() => _SpectrumTableViewState();
}

class _SpectrumTableViewState extends State<SpectrumTableView> {
  final Set<Object> _selected = {};
  Object? _hovered;

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumTableView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  bool get _isMultiple => widget.selects == SpectrumSelects.multiple;

  void _toggle(Object id) {
    if (widget.selects == SpectrumSelects.none) {
      widget.onAction?.call(id);
      return;
    }

    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_isMultiple) {
        _selected.add(id);
      } else {
        _selected
          ..clear()
          ..add(id);
      }
    });
    widget.onSelectionChange?.call({..._selected});
  }

  /// Selects every enabled row, or none when all of them are selected.
  void _toggleAll() {
    final ids = [
      for (final row in widget.body.children)
        if (!row.isDisabled) row.id,
    ];
    final isAll = ids.every(_selected.contains);

    setState(() {
      if (isAll) {
        _selected.removeAll(ids);
      } else {
        _selected.addAll(ids);
      }
    });
    widget.onSelectionChange?.call({..._selected});
  }

  void _sort(SpectrumColumn column) {
    final SpectrumSortDirection direction;

    // Tapping the sorted column flips its direction; another column starts ascending.
    if (widget.sortColumn == column.id && widget.sortDirection == SpectrumSortDirection.ascending) {
      direction = SpectrumSortDirection.descending;
    } else {
      direction = SpectrumSortDirection.ascending;
    }

    widget.onSortChange?.call(column.id, direction);
  }

  /// Places a cell in the width of its column, with the divider of the column.
  Widget _sized(SpectrumColumn column, Widget child, Color divider) {
    final cell = DecoratedBox(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: column.showDivider ? divider : Colors.transparent)),
      ),
      child: child,
    );

    if (column.width != null) {
      return SizedBox(width: column.width, child: cell);
    }

    return Expanded(flex: column.flex, child: cell);
  }

  Alignment _alignOf(TextAlign align) {
    if (align == TextAlign.center) {
      return Alignment.center;
    } else if (align == TextAlign.end || align == TextAlign.right) {
      return AlignmentDirectional.centerEnd.resolve(Directionality.of(context));
    } else {
      return AlignmentDirectional.centerStart.resolve(Directionality.of(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final line = isDark ? SpectrumDarkColors.gray300 : SpectrumColors.gray300;
    final columns = widget.header.children;
    final rows = widget.body.children;
    final double rowHeight;

    if (widget.density == VisualDensity.compact) {
      rowHeight = 32;
    } else if (widget.density == VisualDensity.comfortable) {
      rowHeight = 48;
    } else {
      rowHeight = 40;
    }

    final enabledIds = [
      for (final row in rows)
        if (!row.isDisabled) row.id,
    ];
    final isAll = enabledIds.isNotEmpty && enabledIds.every(_selected.contains);
    final isSome = !isAll && enabledIds.any(_selected.contains);

    // Spectrum 2 header: 32px, bold 14px gray-800 titles 16px from the edges, the sort
    // arrow on the sorted column and a 1px gray-300 line below.
    final header = Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        children: [
          Visibility(
            visible: _isMultiple,
            child: SizedBox(
              width: 40,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                child: Semantics(
                  label: 'Select all',
                  child: SpectrumCheckbox(isSelected: isAll, isIndeterminate: isSome, onChanged: (_) => _toggleAll()),
                ),
              ),
            ),
          ),
          for (final column in columns)
            _sized(
              column,
              Semantics(
                header: true,
                button: column.allowsSorting,
                child: InkWell(
                  onTap: column.allowsSorting ? () => _sort(column) : null,
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: _alignOf(column.align),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Flexible(
                          child: DefaultTextStyle(
                            style: style.copyWith(fontWeight: FontWeight.w700, color: colors.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: column.child,
                          ),
                        ),
                        Visibility(
                          visible: widget.sortColumn == column.id,
                          child: SpectrumIcon(
                            widget.sortDirection == SpectrumSortDirection.ascending
                                ? SpectrumIcons.arrowUp
                                : SpectrumIcons.arrowDown,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              line,
            ),
        ],
      ),
    );

    final body = <Widget>[];

    for (final (index, row) in rows.indexed) {
      final isSelected = _selected.contains(row.id);
      final isHovered = _hovered == row.id;
      final Color background;

      if (isSelected) {
        // A selected row is a light gray, stronger on hover.
        background = colors.inverseSurface.withValues(alpha: isHovered ? 0.1 : 0.07);
      } else if (isHovered && !row.isDisabled) {
        // A hovered row shows a 5% gray-900 background.
        background = colors.inverseSurface.withValues(alpha: 0.05);
      } else {
        background = Colors.transparent;
      }

      final content = row.isDisabled ? colors.outline : colors.onSurface;

      body.add(
        Semantics(
          selected: isSelected,
          enabled: !row.isDisabled,
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: colors.inverseSurface.withValues(alpha: 0.05),
            onTap: row.isDisabled ? null : () => _toggle(row.id),
            onHover: (value) => setState(() => _hovered = value ? row.id : (_hovered == row.id ? null : _hovered)),
            // Spectrum 2 row: 40px (or the density), cells 16px from the edges, with a
            // 1px gray-300 line below every row but the last.
            child: Container(
              constraints: BoxConstraints(minHeight: rowHeight),
              decoration: BoxDecoration(
                color: background,
                border: Border(bottom: BorderSide(color: index < rows.length - 1 ? line : Colors.transparent)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Visibility(
                      visible: _isMultiple,
                      child: SizedBox(
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                          child: IgnorePointer(
                            child: ExcludeSemantics(
                              child: SpectrumCheckbox(isSelected: isSelected, isDisabled: row.isDisabled),
                            ),
                          ),
                        ),
                      ),
                    ),
                    for (final (position, column) in columns.indexed)
                      _sized(
                        column,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          alignment: _alignOf(column.align),
                          child: DefaultTextStyle(
                            style: style.copyWith(color: content),
                            textAlign: column.align,
                            maxLines: widget.isWrapped ? null : 1,
                            overflow: widget.isWrapped ? TextOverflow.clip : TextOverflow.ellipsis,
                            child: position < row.children.length ? row.children[position].child : const SizedBox(),
                          ),
                        ),
                        line,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Spectrum 2 table: a gray-25 box with a 1px gray-300 border and 6px corners, or
    // only the rows when quiet.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.isQuiet ? Colors.transparent : colors.surface,
          borderRadius: BorderRadius.circular(widget.isQuiet ? 0 : 6),
          border: widget.isQuiet ? null : Border.all(color: line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [header, ...body],
        ),
      ),
    );
  }
}
