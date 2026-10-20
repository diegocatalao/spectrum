import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';
import 'package:url_launcher/link.dart';

/// Spectrum Menu Item: one option of a menu, with a checkmark when selected,
/// an optional icon and a text, in this order from the left.
class SpectrumMenuItem extends StatefulWidget {
  /// Text of the option.
  final Text child;

  /// Text shown below the label, in a smaller and lighter font.
  final Text? description;

  /// Widget shown on the right of the label, before the shortcut, like a
  /// badge or the current value of a setting. As in Spectrum 2, it must not
  /// be interactive, since buttons inside a menu item break the keyboard navigation.
  final Widget? value;

  /// Keyboard shortcut shown on the right of the label, like ⌘C. It is only
  /// a hint: the shortcut itself is registered by the app.
  final Text? keyboard;

  /// Address opened when the item is tapped. It also shows the link out
  /// arrow at the end of the item.
  final Uri? href;

  /// Icon shown on the left of the text.
  final SpectrumIcon? icon;

  /// 40px thumbnail shown on the left of the texts, like a file preview or
  /// a photo. It takes the place of the icon when both are given.
  final Image? image;

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
    this.description,
    this.value,
    this.keyboard,
    this.href,
    this.icon,
    this.image,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  State<SpectrumMenuItem> createState() => _SpectrumMenuItemState();
}

/// Keeps the press state of the item, used by the press scale animation.
class _SpectrumMenuItemState extends State<SpectrumMenuItem> {
  /// States of the MenuItemButton, listened to know when the item is pressed.
  final WidgetStatesController _states = WidgetStatesController();

  /// Press state, kept to shrink the item while it is held down.
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // When the MenuItemButton changes its states, the press state is updated,
    // so the press scale follows the pointer and the keyboard.
    _states.addListener(_handleStates);
  }

  /// Rebuilds only when the press state changes, since the MenuItemButton also
  /// updates other states, like disabled, while it is being built.
  void _handleStates() {
    final isPressed = _states.value.contains(WidgetState.pressed);

    if (isPressed != _isPressed) {
      setState(() => _isPressed = isPressed);
    }
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  /// Builds the content from the left: checkmark, icon and text, with the
  /// Spectrum spacing between them (10px after the checkmark, 6px after the icon).
  Widget getContent(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Inside a SpectrumMenuGroup with selection, the group decides if the item
    // is selected, and the checkmark space is always kept.
    final group = SpectrumMenuGroup.itemOf(context);
    final isSelected = group?.selected ?? widget.isSelected;
    final isSelectable = group != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              // The 20px height is the same as the icon box, so the checkmark is
              // centered on the first line, aligned with the icon and the label.
              child: SizedBox(
                height: 20,
                child: Center(
                  widthFactor: 1,
                  child: SpectrumIcon(SpectrumIcons.checkmark, size: 10, color: colors.primary),
                ),
              ),
            ),
          ),
        ),
        // When there is an icon, it takes a 20px area followed by 6px before the text.
        Visibility(
          visible: widget.icon != null && widget.image == null,
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: SizedBox.square(dimension: 20, child: Center(child: widget.icon)),
          ),
        ),
        // Spectrum 2 menu item image: a 40px square with 4px corners, 6px before the
        // text. The image is contained, so a wide or tall picture is not cropped.
        Visibility(
          visible: widget.image != null,
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox.square(
                dimension: 40,
                child: FittedBox(fit: BoxFit.contain, child: widget.image),
              ),
            ),
          ),
        ),
        // The texts take the width left by the checkmark and the icon, and the label
        // takes the width left by the value and the shortcut, so a long option is cut
        // with ellipsis and the shortcuts of every item line up on the right.
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Spectrum 2 menu item label: the "ui" font of the M size, 14px regular.
              // The label, the value and the shortcut share the first line, centered on
              // each other, so an icon or a badge as value lines up with the texts.
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      overflow: TextOverflow.ellipsis,
                      style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      child: widget.child,
                    ),
                  ),
                  // Spectrum 2 value: any widget 8px after the label, centered on its line.
                  Visibility(
                    visible: widget.value != null,
                    child: Padding(padding: const EdgeInsets.only(left: 8), child: widget.value),
                  ),
                  // Spectrum 2 keyboard shortcut: the "ui" font in gray, 8px after the label.
                  // When isDisabled is True, it is grayed out like the label.
                  Visibility(
                    visible: widget.keyboard != null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.end,
                        style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                          color: widget.isDisabled ? colors.outline : colors.onSurfaceVariant,
                        ),
                        child: widget.keyboard ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  // Spectrum 2 link out arrow: always the last element of an item with
                  // href, 8px after the shortcut, telling that the item opens a link.
                  Visibility(
                    visible: widget.href != null,
                    child: Padding(padding: const EdgeInsets.only(left: 8), child: SpectrumIcon(SpectrumIcons.linkOut)),
                  ),
                ],
              ),
              // Spectrum 2 menu item description: the "ui-sm" font, 12px regular,
              // which is the body style at the size of Detail S. When there is no
              // description, nothing is shown below the label.
              Visibility(
                visible: widget.description != null,
                child: DefaultTextStyle(
                  overflow: TextOverflow.ellipsis,
                  style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  child: widget.description ?? const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Inside a SpectrumMenuGroup with selection, the tap first tells the group
  /// to select the item. In both cases, the onTap passed by the user is called,
  /// and the href is opened when there is one.
  void _handleTap(BuildContext context, FollowLink? followLink) {
    SpectrumMenuGroup.itemOf(context)?.onSelect();
    widget.onTap?.call();

    if (widget.href != null) {
      followLink?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Link opens the href in the system browser, and on the web it also gives
    // the item the native link behaviors. Without href, it only builds the item.
    return Link(
      uri: widget.href,
      builder: (context, followLink) {
        // Tells screen readers that the item is a link when it has an href.
        return Semantics(
          link: widget.href != null,
          // Spectrum 2 "press scale": the item shrinks a little while it is pressed,
          // less than a button since the scale depends on the size of the item.
          child: SpectrumPressScale(
            isPressed: _isPressed,
            child: MenuItemButton(
              statesController: _states,
              // Gives the content a bounded width, so the label can be Expanded and push the
              // shortcut to the right. By default the MenuItemButton gives it an infinite width.
              overflowAxis: Axis.vertical,
              // Spectrum menu item: 32px high, 12px from the edges, gray-800 text that
              // gets lighter on hover, and a 12% gray-1000 background on hover and focus.
              style: ButtonStyle(
                // Keeps the Material density from changing the item height.
                visualDensity: VisualDensity.standard,
                // Stops Material from growing the item to a 48px touch target.
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // Spectrum item height of 32px, with the width coming from the content.
                minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
                // 12px between the edges of the item and its content, and 7px above and
                // below, the S2 center padding that keeps a 14px label centered in 32px
                // and spaces the description when the item grows.
                padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 7)),
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
              onPressed: widget.isDisabled ? null : () => _handleTap(context, followLink),
              // Checkmark, icon and text, built above. They are not passed as leadingIcon
              // because the MenuItemButton puts a fixed 12px gap after it.
              child: getContent(context),
            ),
          ),
        );
      },
    );
  }
}
