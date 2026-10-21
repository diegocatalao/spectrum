import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Picker Section: a group of options of a SpectrumPicker with a header.
class SpectrumPickerSection {
  /// Title of the section.
  final SpectrumMenuHeader header;

  /// Options of the section.
  final List<SpectrumPickerItem> children;

  const SpectrumPickerSection({required this.header, required this.children});
}

/// Builds the menu of the options of a picker or a combo box: menu items with the
/// checkmark on the selected value, sections with their header, and dividers between them.
List<Widget> spectrumOptionsMenu({
  required List<Object> options,
  required String? selected,
  required ValueChanged<String> onSelect,
}) {
  Widget item(SpectrumPickerItem option) {
    return SpectrumMenuItem(
      icon: option.icon,
      description: option.description,
      isSelected: option.value == selected,
      isDisabled: option.isDisabled,
      onTap: () => onSelect(option.value),
      child: option.child,
    );
  }

  final menu = <Widget>[];

  for (final option in options) {
    if (option is SpectrumPickerSection) {
      if (menu.isNotEmpty) {
        menu.add(const SpectrumDivider());
      }

      menu.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [option.header, for (final child in option.children) item(child)],
        ),
      );
    } else if (option is SpectrumPickerItem) {
      menu.add(item(option));
    }
  }

  return menu;
}

/// Finds the option with the value among the options and the sections.
SpectrumPickerItem? spectrumOptionOf(List<Object> options, String? value) {
  for (final option in options) {
    if (option is SpectrumPickerItem && option.value == value) {
      return option;
    } else if (option is SpectrumPickerSection) {
      for (final child in option.children) {
        if (child.value == value) {
          return child;
        }
      }
    }
  }

  return null;
}
