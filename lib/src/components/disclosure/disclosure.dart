import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Disclosure: a header that, when tapped, expands or collapses the
/// panel below it. Inside a SpectrumAccordion it is an accordion item.
class SpectrumDisclosure extends StatefulWidget {
  /// Header with the chevron, the title and the actions.
  final SpectrumDisclosureHeader header;

  /// Content revealed below the header when expanded.
  final SpectrumDisclosurePanel panel;

  /// Whether the panel starts expanded. When the parent changes it, the
  /// disclosure follows. Inside a SpectrumAccordion, the accordion decides it.
  final bool isExpanded;

  /// Removes the divider below and rounds the corners of the hover background.
  final bool isQuiet;

  /// Grays out the title and ignores hover and tap.
  final bool isDisabled;

  /// Vertical and horizontal compactness of the header.
  final VisualDensity density;

  /// Called with the new expansion when the header is tapped, outside of an accordion.
  final ValueChanged<bool>? onExpandedChange;

  const SpectrumDisclosure({
    super.key,
    required this.header,
    required this.panel,
    this.isExpanded = false,
    this.isQuiet = false,
    this.isDisabled = false,
    this.density = VisualDensity.standard,
    this.onExpandedChange,
  });

  /// Returns the state shared by the disclosure with its header and panel.
  static ({bool isExpanded, bool isQuiet, bool isDisabled, VisualDensity density, VoidCallback onToggle})? stateOf(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_DisclosureScope>();

    if (scope == null) {
      return null;
    }

    return (
      isExpanded: scope.isExpanded,
      isQuiet: scope.isQuiet,
      isDisabled: scope.isDisabled,
      density: scope.density,
      onToggle: scope.onToggle,
    );
  }

  @override
  State<SpectrumDisclosure> createState() => _SpectrumDisclosureState();
}

/// Keeps the expansion of a disclosure that is not inside an accordion.
class _SpectrumDisclosureState extends State<SpectrumDisclosure> {
  /// Expansion of the disclosure on its own, changed on every tap.
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant SpectrumDisclosure oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When the parent changes isExpanded, the disclosure follows it.
    if (oldWidget.isExpanded != widget.isExpanded) {
      _isExpanded = widget.isExpanded;
    }
  }

  /// Inside an accordion, the accordion toggles the item. Otherwise the disclosure
  /// toggles itself and tells the parent through onExpandedChange.
  void _handleToggle() {
    final item = SpectrumAccordion.itemOf(context);

    if (item != null) {
      item.onToggle();
    } else {
      setState(() => _isExpanded = !_isExpanded);
      widget.onExpandedChange?.call(_isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inside an accordion, the accordion decides the expansion and its density,
    // and its isQuiet and isDisabled apply together with the ones of the item.
    final item = SpectrumAccordion.itemOf(context);
    final isQuiet = widget.isQuiet || (item?.isQuiet ?? false);

    return _DisclosureScope(
      isExpanded: item?.isExpanded ?? _isExpanded,
      isQuiet: isQuiet,
      isDisabled: widget.isDisabled || (item?.isDisabled ?? false),
      density: item?.density ?? widget.density,
      onToggle: _handleToggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.header,
          widget.panel,
          // The divider is only shown when the disclosure is not quiet, because
          // quiet disclosures are separated only by spacing.
          Visibility(visible: !isQuiet, child: const SpectrumDivider()),
        ],
      ),
    );
  }
}

/// Shares the state of the disclosure with its header and panel.
class _DisclosureScope extends InheritedWidget {
  final bool isExpanded;
  final bool isQuiet;
  final bool isDisabled;
  final VisualDensity density;
  final VoidCallback onToggle;

  const _DisclosureScope({
    required this.isExpanded,
    required this.isQuiet,
    required this.isDisabled,
    required this.density,
    required this.onToggle,
    required super.child,
  });

  @override
  bool updateShouldNotify(_DisclosureScope oldWidget) {
    return oldWidget.isExpanded != isExpanded ||
        oldWidget.isQuiet != isQuiet ||
        oldWidget.isDisabled != isDisabled ||
        oldWidget.density != density ||
        oldWidget.onToggle != onToggle;
  }
}
