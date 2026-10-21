import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// One destination of a SpectrumTabBar.
class SpectrumTabBarItem {
  /// Icon of the destination.
  final SpectrumIcons icon;

  /// Label below the icon.
  final String label;

  const SpectrumTabBarItem({required this.icon, required this.label});
}

/// Spectrum Tab Bar: the bar of destinations at the bottom of a mobile app, with an
/// icon and a label for each one.
class SpectrumTabBar extends StatelessWidget {
  /// Destinations of the bar.
  final List<SpectrumTabBarItem> items;

  /// Index of the current destination.
  final int selectedIndex;

  /// Called with the index of the tapped destination.
  final ValueChanged<int>? onSelectionChange;

  const SpectrumTabBar({super.key, required this.items, this.selectedIndex = 0, this.onSelectionChange});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = Theme.of(context).textTheme.labelSmall ?? const TextStyle();

    // Spectrum tab bar: the elevated layer with a 1px gray-200 line on top, 56px high,
    // above the bottom inset of the device.
    return Material(
      color: isDark ? colors.surfaceContainer : colors.surface,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                for (final (index, item) in items.indexed)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: index == selectedIndex,
                      label: item.label,
                      child: InkWell(
                        onTap: () => onSelectionChange?.call(index),
                        child: ExcludeSemantics(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 2,
                            children: [
                              // The current destination is the accent blue, the others gray-700.
                              SpectrumIcon(
                                item.icon,
                                size: 20,
                                color: index == selectedIndex ? colors.primary : colors.onSurfaceVariant,
                              ),
                              Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: style.copyWith(
                                  color: index == selectedIndex ? colors.primary : colors.onSurfaceVariant,
                                  fontWeight: index == selectedIndex ? FontWeight.w700 : FontWeight.w400,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
