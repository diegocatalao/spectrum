import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Card View: a grid of SpectrumCard, filling the width with as many
/// columns as fit, with optional single or multiple selection.
class SpectrumCardView extends StatefulWidget {
  /// Cards of the view.
  final List<SpectrumCard> children;

  /// Whether no card, one card or many cards can be selected.
  final SpectrumSelects selects;

  /// Indexes of the cards selected at start. When the parent changes them, the view follows.
  final List<int> selected;

  /// Called with the new selected indexes when a card is tapped.
  final ValueChanged<List<int>>? onSelectionChange;

  /// Space between the cards: 8px compact, 16px standard or 24px comfortable.
  final VisualDensity density;

  const SpectrumCardView({
    super.key,
    required this.children,
    this.selects = SpectrumSelects.none,
    this.selected = const [],
    this.onSelectionChange,
    this.density = VisualDensity.standard,
  });

  /// Returns the selection of the card inside a card view with selection, or null.
  static ({bool isSelected, bool isMultiple, VoidCallback onToggle})? cardOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_CardScope>();

    if (scope == null) {
      return null;
    }

    return (isSelected: scope.isSelected, isMultiple: scope.isMultiple, onToggle: scope.onToggle);
  }

  @override
  State<SpectrumCardView> createState() => _SpectrumCardViewState();
}

/// Keeps the selected cards.
class _SpectrumCardViewState extends State<SpectrumCardView> {
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumCardView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the selected indexes, the view follows them.
    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  void _handleToggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else if (widget.selects == SpectrumSelects.multiple) {
        _selected.add(index);
      } else {
        _selected
          ..clear()
          ..add(index);
      }
    });

    widget.onSelectionChange?.call(_selected.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final double gap;

    if (widget.density == VisualDensity.compact) {
      gap = 8;
    } else if (widget.density == VisualDensity.comfortable) {
      gap = 24;
    } else {
      gap = 16;
    }

    final cards = <Widget>[];

    for (final (index, card) in widget.children.indexed) {
      if (widget.selects == SpectrumSelects.none) {
        // Without selection, the cards are shown as they are.
        cards.add(card);
      } else {
        // Otherwise each card receives if it is selected and how to toggle itself.
        cards.add(
          _CardScope(
            isSelected: _selected.contains(index),
            isMultiple: widget.selects == SpectrumSelects.multiple,
            onToggle: () => _handleToggle(index),
            child: card,
          ),
        );
      }
    }

    // The cards wrap to new lines, as many per line as fit the width.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Wrap(spacing: gap, runSpacing: gap, children: cards),
    );
  }
}

/// Shares the selection of one card with that card.
class _CardScope extends InheritedWidget {
  final bool isSelected;
  final bool isMultiple;
  final VoidCallback onToggle;

  const _CardScope({required this.isSelected, required this.isMultiple, required this.onToggle, required super.child});

  @override
  bool updateShouldNotify(_CardScope oldWidget) {
    return oldWidget.isSelected != isSelected || oldWidget.isMultiple != isMultiple;
  }
}
