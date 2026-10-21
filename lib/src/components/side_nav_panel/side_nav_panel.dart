import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Side Nav Panel: the panel that holds a SpectrumSideNav on the side of
/// the app, with a button that collapses it to its icons.
class SpectrumSideNavPanel extends StatefulWidget {
  /// Navigation of the panel.
  final SpectrumSideNav child;

  /// Widget at the top of the panel, like the name of the app.
  final Widget? header;

  /// Whether the panel starts collapsed.
  final bool isCollapsed;

  /// Called when the panel collapses or expands.
  final ValueChanged<bool>? onCollapsedChange;

  const SpectrumSideNavPanel({
    super.key,
    required this.child,
    this.header,
    this.isCollapsed = false,
    this.onCollapsedChange,
  });

  /// Returns True when the item is inside a collapsed panel.
  static bool isCollapsedOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PanelScope>()?.isCollapsed ?? false;
  }

  @override
  State<SpectrumSideNavPanel> createState() => _SpectrumSideNavPanelState();
}

class _SpectrumSideNavPanelState extends State<SpectrumSideNavPanel> {
  bool _isCollapsed = false;

  /// Whether the texts of the items are shown. When expanding, they only come back
  /// once the panel is wide again, so they never overflow while it grows.
  bool _showsLabels = true;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.isCollapsed;
    _showsLabels = !widget.isCollapsed;
  }

  @override
  void didUpdateWidget(covariant SpectrumSideNavPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isCollapsed != widget.isCollapsed) {
      _isCollapsed = widget.isCollapsed;
      _showsLabels = _showsLabels && !widget.isCollapsed;
    }
  }

  void _toggle() {
    setState(() {
      _isCollapsed = !_isCollapsed;

      // When collapsing, the texts hide at once, before the panel shrinks.
      if (_isCollapsed) {
        _showsLabels = false;
      }
    });
    widget.onCollapsedChange?.call(_isCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Spectrum 2 side panel: 240px wide, or 64px with only the icons when collapsed,
    // over the first layer (gray-50), sliding between both in 200ms.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: SpectrumMotion.easeOut,
      width: _isCollapsed ? 64 : 240,
      onEnd: () => setState(() => _showsLabels = !_isCollapsed),
      color: colors.surfaceContainerLow,
      padding: const EdgeInsets.all(8),
      child: _PanelScope(
        isCollapsed: !_showsLabels,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: _showsLabels && widget.header != null,
                    child: widget.header ?? const SizedBox.shrink(),
                  ),
                ),
                Semantics(
                  label: _isCollapsed ? 'Expand navigation' : 'Collapse navigation',
                  child: SpectrumActionButton(
                    icon: SpectrumIcon(SpectrumIcons.viewList),
                    isQuiet: true,
                    onTap: _toggle,
                  ),
                ),
              ],
            ),
            Expanded(child: SingleChildScrollView(child: widget.child)),
          ],
        ),
      ),
    );
  }
}

/// Shares whether the panel is collapsed with the items of the navigation.
class _PanelScope extends InheritedWidget {
  final bool isCollapsed;

  const _PanelScope({required this.isCollapsed, required super.child});

  @override
  bool updateShouldNotify(_PanelScope oldWidget) => oldWidget.isCollapsed != isCollapsed;
}
