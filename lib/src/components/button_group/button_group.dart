import 'package:flutter/material.dart';

/// Spectrum Button Group: a set of related buttons that moves to a column
/// when there is no room to show them in a row.
class SpectrumButtonGroup extends StatelessWidget {
  /// Buttons of the group, usually SpectrumButtons.
  final List<Widget> children;

  /// Direction of the buttons. Horizontal groups turn vertical on overflow.
  final Axis orientation;

  /// Position of the buttons inside the group: start, center or end.
  final OverflowBarAlignment alignment;

  /// Disables every SpectrumButton inside the group.
  final bool isDisabled;

  const SpectrumButtonGroup({
    super.key,
    required this.children,
    this.orientation = Axis.horizontal,
    this.alignment = OverflowBarAlignment.start,
    this.isDisabled = false,
  });

  /// Returns True when the widget is inside a disabled group.
  static bool isDisabledOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ButtonGroupScope>()?.isDisabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final MainAxisAlignment rowAlignment;
    final CrossAxisAlignment columnAlignment;

    if (alignment == OverflowBarAlignment.end) {
      // When alignment is end, the buttons are pushed to the end of
      // the row, or to the end side of the column when vertical.
      rowAlignment = MainAxisAlignment.end;
      columnAlignment = CrossAxisAlignment.end;
    } else if (alignment == OverflowBarAlignment.center) {
      // When alignment is center, the buttons are centered
      // in the row and in the column.
      rowAlignment = MainAxisAlignment.center;
      columnAlignment = CrossAxisAlignment.center;
    } else {
      // Otherwise the buttons start at the beginning of the row,
      // or at the start side of the column when vertical.
      rowAlignment = MainAxisAlignment.start;
      columnAlignment = CrossAxisAlignment.start;
    }

    final Widget group;

    if (orientation == Axis.vertical) {
      // When orientation is vertical, the buttons are always stacked in a column.
      group = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: columnAlignment,
        spacing: 16,
        children: children,
      );
    } else {
      // When orientation is horizontal, OverflowBar shows the buttons in a row
      // and moves all of them to a column when they do not fit, as Spectrum 2.
      group = OverflowBar(
        spacing: 16,
        overflowSpacing: 16,
        alignment: rowAlignment,
        overflowAlignment: alignment,
        children: children,
      );
    }

    // The scope lets every SpectrumButton inside read isDisabled of the group.
    return _ButtonGroupScope(isDisabled: isDisabled, child: group);
  }
}

/// Shares the disabled state of the group with the buttons inside it.
class _ButtonGroupScope extends InheritedWidget {
  final bool isDisabled;

  const _ButtonGroupScope({required this.isDisabled, required super.child});

  @override
  bool updateShouldNotify(_ButtonGroupScope oldWidget) => oldWidget.isDisabled != isDisabled;
}
