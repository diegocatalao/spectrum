import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Side Nav Section: a group of items of a SpectrumSideNav below a bold header.
class SpectrumSideNavSection extends StatelessWidget {
  /// Title of the section.
  final Text header;

  /// Items of the section.
  final List<SpectrumSideNavItem> children;

  const SpectrumSideNavSection({super.key, required this.header, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      label: header.data,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          // Spectrum 2 section header: bold 14px gray-800, 12px from the start,
          // 32px high, aligned with the texts of the items.
          ExcludeSemantics(
            child: Container(
              constraints: const BoxConstraints(minHeight: 32),
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: DefaultTextStyle(
                style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
                child: header,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
