import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Picker Item: one option of a SpectrumPicker, with a value, a label and
/// an optional icon and description.
class SpectrumPickerItem {
  /// Value of the option, sent by the picker when it is selected.
  final String value;

  /// Label of the option, also shown in the picker button when selected.
  final Text child;

  /// Icon shown before the label.
  final SpectrumIcon? icon;

  /// Text below the label in the menu.
  final Text? description;

  /// Grays out the option and ignores taps.
  final bool isDisabled;

  const SpectrumPickerItem({
    required this.value,
    required this.child,
    this.icon,
    this.description,
    this.isDisabled = false,
  });
}
