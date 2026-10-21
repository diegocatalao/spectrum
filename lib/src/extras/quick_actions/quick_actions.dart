import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Quick Actions: a small floating bar of quiet action buttons shown over
/// an item, like a card, while it is hovered or focused.
class SpectrumQuickActions extends StatefulWidget {
  /// The item that shows the actions, like a SpectrumCard.
  final Widget child;

  /// Action buttons of the bar, usually quiet SpectrumActionButton with icons.
  final List<Widget> actions;

  /// Where the bar stands over the item, at the top end by default.
  final AlignmentGeometry alignment;

  /// Keeps the bar always visible instead of only on hover and focus.
  final bool isAlwaysVisible;

  const SpectrumQuickActions({
    super.key,
    required this.child,
    required this.actions,
    this.alignment = AlignmentDirectional.topEnd,
    this.isAlwaysVisible = false,
  });

  @override
  State<SpectrumQuickActions> createState() => _SpectrumQuickActionsState();
}

class _SpectrumQuickActionsState extends State<SpectrumQuickActions> {
  bool _isHovered = false;
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isShown = widget.isAlwaysVisible || _isHovered || _hasFocus;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Focus(
        canRequestFocus: false,
        onFocusChange: (value) => setState(() => _hasFocus = value),
        child: Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: widget.alignment,
                  // The bar fades in on hover: the elevated layer with 8px corners, 4px
                  // around the buttons and the elevated shadow.
                  child: AnimatedOpacity(
                    opacity: isShown ? 1 : 0,
                    duration: SpectrumMotion.duration,
                    child: IgnorePointer(
                      ignoring: !isShown,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? colors.surfaceContainer : colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: SpectrumActionButtonGroup(isQuiet: true, children: widget.actions),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
