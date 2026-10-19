import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Menu Item: one option of a menu, with a checkmark when selected,
/// an optional icon and a text, in this order from the left.
class SpectrumMenuItem extends StatelessWidget {
  /// Text of the option.
  final Text child;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// Shows the accent blue checkmark on the left. Inside a SpectrumMenuGroup
  /// with selection, the group decides it instead.
  final bool isSelected;

  /// Grays out the option and ignores taps.
  final bool isDisabled;

  /// Called when the option is tapped. The menu closes after it.
  final VoidCallback? onTap;

  const SpectrumMenuItem({
    super.key,
    required this.child,
    this.icon,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
  });

  /// Builds the content from the left: checkmark, icon and text, with the
  /// Spectrum spacing between them (10px after the checkmark, 6px after the icon).
  Widget getContent(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Inside a SpectrumMenuGroup with selection, the group decides if the item
    // is selected, and the checkmark space is always kept.
    final group = SpectrumMenuGroup.itemOf(context);
    final isSelected = group?.selected ?? this.isSelected;
    final isSelectable = group != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // When isSelected is True the 10px checkmark is shown. When only the
        // group is selectable, its space is kept hidden so the texts stay aligned.
        Visibility(
          visible: isSelected || isSelectable,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Visibility(
              visible: isSelected,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: SpectrumIcon(SpectrumIcons.checkmark, size: 10, color: colors.primary),
            ),
          ),
        ),
        // When there is an icon, it takes a 20px area followed by 6px before the text.
        Visibility(
          visible: icon != null,
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: SizedBox.square(dimension: 20, child: Center(child: icon)),
          ),
        ),
        // The text is Flexible so a long option is cut with ellipsis.
        Flexible(child: child),
      ],
    );
  }

  /// Inside a SpectrumMenuGroup with selection, the tap first tells the group
  /// to select the item. In both cases, the onTap passed by the user is called.
  void _handleTap(BuildContext context) {
    SpectrumMenuGroup.itemOf(context)?.onSelect();
    onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MenuItemButton(
      // Spectrum menu item: 32px high, 12px from the edges, gray-800 text that
      // gets lighter on hover, and a 12% gray-1000 background on hover and focus.
      style: ButtonStyle(
        // Keeps the Material density from changing the item height.
        visualDensity: VisualDensity.standard,
        // Stops Material from growing the item to a 48px touch target.
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // Spectrum item height of 32px, with the width coming from the content.
        minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
        // 12px between the edges of the item and its content.
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
        // Body S text, the 14px of the Spectrum menu.
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        // Removes the Material overlay, since the background below handles hover.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        // Background: 12% gray-1000 on hover and keyboard focus, none otherwise.
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.transparent;
          } else if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
            return colors.inverseSurface.withValues(alpha: 0.12);
          } else {
            return Colors.transparent;
          }
        }),
        // Text: gray-400 when disabled, gray-900 on hover and focus, gray-800 otherwise.
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colors.outline;
          } else if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
            return colors.inverseSurface;
          } else {
            return colors.onSurface;
          }
        }),
        // Icon: gray-400 when disabled, gray-800 otherwise.
        iconColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.disabled) ? colors.outline : colors.onSurface;
        }),
        // Rounded 8px corners, without border, for the hover background.
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.circular(8)),
        ),
      ),
      // When isDisabled is True, the tap is null and the item is skipped by the keyboard.
      onPressed: isDisabled ? null : () => _handleTap(context),
      // Checkmark, icon and text, built above. They are not passed as leadingIcon
      // because the MenuItemButton puts a fixed 12px gap after it.
      child: getContent(context),
    );
  }
}
