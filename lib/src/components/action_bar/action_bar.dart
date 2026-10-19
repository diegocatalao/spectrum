import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Action Bar: a floating bar shown while items are selected,
/// with a close button, the number of selected items and the actions.
/// Its position on the screen is decided by the parent (Stack, Scaffold...).
class SpectrumActionBar extends StatelessWidget {
  /// Shows or hides the bar.
  final bool isOpen;

  /// Uses the accent blue as background instead of the gray surface.
  final bool isEmphasized;

  /// Number of selected items, shown as "N items selected" in the user language.
  final int selectedCount;

  /// Called by the close button, usually to clear the selection.
  final VoidCallback onClose;

  /// Action buttons shown on the right, always quiet inside the bar.
  final List<Widget> children;

  const SpectrumActionBar({
    super.key,
    required this.selectedCount,
    required this.onClose,
    this.isOpen = true,
    this.isEmphasized = false,
    this.children = const [],
  }) : assert(selectedCount >= 0);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shadow = BoxShadow(blurRadius: 4, offset: const Offset(0, 1), color: colors.shadow);

    return Visibility(
      visible: isOpen,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // When isEmphasized is True, the bar is blue and has no border
          // or shadow. Otherwise, it is the gray surface floating over
          // the content with a gray-400 border and a drop shadow.
          boxShadow: [if (!isEmphasized) shadow],
          color: isEmphasized ? colors.primary : colors.surface,
          border: Border.all(color: isEmphasized ? Colors.transparent : colors.outline),
        ),
        child: Row(
          children: [
            SpectrumCloseButton(onTap: onClose),
            const SizedBox(width: 4),
            // The counter takes all the free space, pushing the actions to the
            // right, and is cut with ellipsis when there is not enough room.
            Expanded(
              child: Text(
                MaterialLocalizations.of(context).selectedRowCountTitle(selectedCount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: isEmphasized ? colors.onPrimary : colors.onSurface),
              ),
            ),
            const SizedBox(width: 24),
            // As in Spectrum, the actions are always quiet inside the bar,
            // so the user does not need to pass isQuiet to each one.
            SpectrumActionButtonGroup(isQuiet: true, children: children),
          ],
        ),
      ),
    );
  }
}
