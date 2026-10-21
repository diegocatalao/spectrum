import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// One editable part of a SpectrumSegmentedInput, like the day of a date.
class SpectrumInputSegment {
  /// Smallest number of the segment.
  final int min;

  /// Largest number of the segment.
  final int max;

  /// Text shown while the segment is empty, like "dd".
  final String placeholder;

  /// Name read by screen readers, like "Day".
  final String label;

  /// Text shown for a value instead of the number, like "PM" for 1.
  final String Function(int value)? format;

  /// Text after the segment, like "/" or ":".
  final String separator;

  const SpectrumInputSegment({
    required this.min,
    required this.max,
    required this.placeholder,
    required this.label,
    this.format,
    this.separator = '',
  });

  /// Digits needed to fill the segment, like 2 for a day and 4 for a year.
  int get digits => max.toString().length;
}

/// Input of the Spectrum 2 date and time fields: a SpectrumFieldBox with editable
/// segments, each one focused on its own, changed by typing digits, the up and down
/// arrows and Backspace, moving to the next segment when it is full.
class SpectrumSegmentedInput extends StatefulWidget {
  /// Segments of the input, in order.
  final List<SpectrumInputSegment> segments;

  /// Values of the segments, or null for the empty ones.
  final List<int?> values;

  /// Called with the values of the segments when one changes.
  final ValueChanged<List<int?>> onChanged;

  final bool isInvalid;
  final bool isDisabled;
  final bool isReadOnly;

  /// Widget after the segments, like the calendar button of the date picker.
  final Widget? trailing;

  const SpectrumSegmentedInput({
    super.key,
    required this.segments,
    required this.values,
    required this.onChanged,
    this.isInvalid = false,
    this.isDisabled = false,
    this.isReadOnly = false,
    this.trailing,
  });

  @override
  State<SpectrumSegmentedInput> createState() => _SpectrumSegmentedInputState();
}

class _SpectrumSegmentedInputState extends State<SpectrumSegmentedInput> {
  final List<FocusNode> _nodes = [];

  /// Digits typed in the focused segment, so "1" then "2" makes 12.
  String _typed = '';

  int? _focused;

  @override
  void initState() {
    super.initState();
    _syncNodes();
  }

  @override
  void didUpdateWidget(covariant SpectrumSegmentedInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncNodes();
  }

  void _syncNodes() {
    while (_nodes.length < widget.segments.length) {
      final index = _nodes.length;
      final node = FocusNode();
      node.addListener(() {
        setState(() {
          _typed = '';
          _focused = node.hasFocus ? index : (_focused == index ? null : _focused);
        });
      });
      _nodes.add(node);
    }
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }

    super.dispose();
  }

  void _set(int index, int? value) {
    final values = [...widget.values];

    while (values.length < widget.segments.length) {
      values.add(null);
    }

    values[index] = value;
    widget.onChanged(values);
  }

  KeyEventResult _handleKey(int index, KeyEvent event) {
    if (event is KeyUpEvent || widget.isDisabled || widget.isReadOnly) {
      return KeyEventResult.ignored;
    }

    final segment = widget.segments[index];
    final current = index < widget.values.length ? widget.values[index] : null;
    final key = event.logicalKey;
    final character = event.character;

    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.arrowDown) {
      // The arrows step the value, wrapping around the range.
      final step = key == LogicalKeyboardKey.arrowUp ? 1 : -1;
      final span = segment.max - segment.min + 1;
      final next = current == null ? segment.min : (current - segment.min + step) % span + segment.min;
      _typed = '';
      _set(index, next < segment.min ? next + span : next);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
      // Backspace empties the segment, or goes back to the previous one when empty.
      _typed = '';

      if (current == null && index > 0) {
        _nodes[index - 1].requestFocus();
      } else {
        _set(index, null);
      }

      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowRight && index < _nodes.length - 1) {
      _nodes[index + 1].requestFocus();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowLeft && index > 0) {
      _nodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    } else if (character != null && RegExp(r'^[0-9]$').hasMatch(character)) {
      // Digits build the number; the segment moves on once no other digit can follow.
      var typed = _typed + character;
      var value = int.parse(typed);

      if (value > segment.max) {
        typed = character;
        value = int.parse(typed);
      }

      _typed = typed;
      _set(index, value.clamp(segment.min, segment.max));

      if (typed.length >= segment.digits || value * 10 > segment.max) {
        _typed = '';

        if (index < _nodes.length - 1) {
          _nodes[index + 1].requestFocus();
        }
      }

      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: widget.isDisabled ? colors.outline : colors.onSurface,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    final parts = <Widget>[];

    for (final (index, segment) in widget.segments.indexed) {
      final value = index < widget.values.length ? widget.values[index] : null;
      final isFocused = _focused == index;
      final String text;

      if (value == null) {
        text = segment.placeholder;
      } else if (segment.format != null) {
        text = segment.format!(value);
      } else {
        text = value.toString().padLeft(segment.digits == 4 ? 4 : 2, '0');
      }

      parts.add(
        Semantics(
          label: segment.label,
          value: value?.toString(),
          textField: true,
          child: Focus(
            focusNode: _nodes[index],
            canRequestFocus: !widget.isDisabled,
            onKeyEvent: (node, event) => _handleKey(index, event),
            child: GestureDetector(
              onTap: widget.isDisabled ? null : () => _nodes[index].requestFocus(),
              // The focused segment is highlighted in the accent blue with white text.
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: isFocused ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  text,
                  style: style.copyWith(
                    color: isFocused ? colors.onPrimary : (value == null ? colors.onSurfaceVariant : style.color),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      if (segment.separator.isNotEmpty) {
        parts.add(Text(segment.separator, style: style.copyWith(color: colors.onSurfaceVariant)));
      }
    }

    return SpectrumFieldBox(
      isFocused: _focused != null,
      isInvalid: widget.isInvalid,
      isDisabled: widget.isDisabled,
      padding: EdgeInsetsDirectional.only(start: 12, end: widget.trailing == null ? 12 : 2),
      child: Row(
        children: [
          Expanded(child: Row(children: parts)),
          Visibility(
            visible: widget.isInvalid && !widget.isDisabled,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: SpectrumIcon(SpectrumIcons.alert, size: 14, color: colors.error),
            ),
          ),
          ?widget.trailing,
        ],
      ),
    );
  }
}
