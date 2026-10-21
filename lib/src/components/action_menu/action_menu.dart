import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Action Menu: an action button with an icon, a text or both,
/// that opens a menu with options in a popover below it.
class SpectrumActionMenu extends StatelessWidget {
  /// Options of the menu, usually SpectrumMenuItem and SpectrumDivider.
  final List<Widget> children;

  /// Icon of the button. When null, a child must be passed.
  final SpectrumIcon? icon;

  /// Text of the button, shown on the right of the icon.
  final Text? child;

  /// Text read by screen readers. Required in practice for icon only buttons.
  final String? label;

  /// Removes the gray background of the button.
  final bool isQuiet;

  /// Grays out the button and does not open the menu.
  final bool isDisabled;

  const SpectrumActionMenu({
    super.key,
    required this.children,
    this.icon,
    this.child,
    this.label,
    this.isQuiet = false,
    this.isDisabled = false,
  }) : assert(icon != null || child != null);

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      // Spectrum 2 popover, the same of the submenus.
      style: SpectrumSubmenuTrigger.menuStyleOf(context),
      alignmentOffset: const Offset(0, 4),
      menuChildren: children,
      builder: (context, controller, _) {
        // The button opens the menu, and a second tap closes it. While the
        // menu is open the button is selected, as sp-action-menu does on the web.
        return SpectrumActionButton(
          icon: icon,
          isQuiet: isQuiet,
          isDisabled: isDisabled,
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          child: child,
        );
      },
    );
  }
}
