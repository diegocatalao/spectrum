import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Submenu Trigger: turns a SpectrumMenuItem into an item that opens
/// another menu on its side, on hover, tap or the right arrow key.
class SpectrumSubmenuTrigger extends StatelessWidget {
  /// Item that opens the submenu. It shows a chevron instead of the selection.
  final SpectrumMenuItem child;

  /// Options of the submenu: SpectrumMenuItem, SpectrumMenuSection and SpectrumDivider.
  final List<Widget> menu;

  const SpectrumSubmenuTrigger({super.key, required this.child, required this.menu});

  /// Returns the options of the submenu of the item, or null when the item does
  /// not open a submenu.
  static List<Widget>? menuOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SubmenuScope>()?.menu;
  }

  /// Spectrum 2 popover of the menus: the elevated layer with 10px corners, 8px of
  /// space around the options, a 1px outline in the dark theme and the elevated shadow.
  static MenuStyle menuStyleOf(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll(isDark ? colors.surfaceContainer : colors.surface),
      side: WidgetStatePropertyAll(isDark ? BorderSide(color: colors.outlineVariant) : BorderSide.none),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
      elevation: const WidgetStatePropertyAll(4),
      shadowColor: WidgetStatePropertyAll(colors.shadow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SubmenuScope(menu: menu, child: child);
  }
}

/// Shares the options of the submenu with its item.
class _SubmenuScope extends InheritedWidget {
  final List<Widget> menu;

  const _SubmenuScope({required this.menu, required super.child});

  @override
  bool updateShouldNotify(_SubmenuScope oldWidget) => oldWidget.menu != menu;
}
