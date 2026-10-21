import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Range Slider: a track with two thumbs to pick a range of numbers, with
/// a label and the range on its right.
class SpectrumRangeSlider extends StatefulWidget {
  /// Label above the track, or on its left when labelPosition is side.
  final Text? label;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Value at start. When the parent changes it, the slider follows.
  final RangeValues value;

  final double minValue;
  final double maxValue;

  /// Amount between the values that can be picked, 1 by default.
  final double step;

  /// Fills the track with the accent blue.
  final bool isEmphasized;

  /// Grays out the slider and ignores drags.
  final bool isDisabled;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  /// Formats the value shown on the right of the label. Without it, the number is shown
  /// with as many decimals as the step.
  final String Function(double value)? formatValue;

  /// Called with the value while it changes.
  final ValueChanged<RangeValues>? onChange;

  /// Called with the value when the thumb is released.
  final ValueChanged<RangeValues>? onChangeEnd;

  const SpectrumRangeSlider({
    super.key,
    this.label,
    this.contextualHelp,
    this.value = const RangeValues(0, 100),
    this.minValue = 0,
    this.maxValue = 100,
    this.step = 1,
    this.isEmphasized = false,
    this.isDisabled = false,
    this.labelPosition,
    this.formatValue,
    this.onChange,
    this.onChangeEnd,
  });

  @override
  State<SpectrumRangeSlider> createState() => _SpectrumRangeSliderState();
}

class _SpectrumRangeSliderState extends State<SpectrumRangeSlider> {
  RangeValues _value = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes the value, the slider follows it.
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  /// Shows the number with as many decimals as the step, or with formatValue.
  String _format(double value) {
    if (widget.formatValue != null) {
      return widget.formatValue!(value);
    }

    final decimals = widget.step % 1 == 0 ? 0 : widget.step.toString().split('.').last.length;
    return value.toStringAsFixed(decimals);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final isEmphasized = widget.isEmphasized || SpectrumForm.isEmphasizedOf(context);
    final position = widget.labelPosition ?? SpectrumForm.labelPositionOf(context);
    final textStyle = style.copyWith(color: isDisabled ? colors.outline : colors.onSurfaceVariant);

    final label = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Flexible(
          child: DefaultTextStyle(style: textStyle, child: widget.label ?? const SizedBox.shrink()),
        ),
        Visibility(visible: widget.contextualHelp != null, child: widget.contextualHelp ?? const SizedBox.shrink()),
      ],
    );
    final output = Text('${_format(_value.start)} – ${_format(_value.end)}', style: textStyle);

    final track = SpectrumSliderTrack(
      values: [_value.start, _value.end],
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      step: widget.step,
      isEmphasized: isEmphasized,
      isDisabled: isDisabled,
      semanticLabels: const ['Minimum', 'Maximum'],
      onChanged: (index, value) {
        setState(() {
          if (index == 0) {
            _value = RangeValues(value, _value.end);
          } else {
            _value = RangeValues(_value.start, value);
          }
        });
        widget.onChange?.call(_value);
      },
      onChangeEnd: () => widget.onChangeEnd?.call(_value),
    );

    if (position == SpectrumLabelPosition.side) {
      // When the label is on the side, the label, the track and the value share one
      // line, 16px apart.
      return Row(
        spacing: 16,
        children: [
          label,
          Expanded(child: track),
          output,
        ],
      );
    }

    // Otherwise the label and the value are above the track, at its two ends.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: label),
            output,
          ],
        ),
        track,
      ],
    );
  }
}
