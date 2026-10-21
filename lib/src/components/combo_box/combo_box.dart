import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Combo Box Item: one option of a SpectrumComboBox, the same as a SpectrumPickerItem.
typedef SpectrumComboBoxItem = SpectrumPickerItem;

/// Spectrum Combo Box Section: a group of options of a SpectrumComboBox, the same as a
/// SpectrumPickerSection.
typedef SpectrumComboBoxSection = SpectrumPickerSection;

/// Spectrum Combo Box: a text field that filters a list of options while typing,
/// with a button that opens the whole list.
class SpectrumComboBox extends StatefulWidget {
  /// Options of the list: SpectrumComboBoxItem and SpectrumComboBoxSection.
  final List<Object> children;

  /// Label of the field.
  final Text? label;

  /// Help text below the field, hidden while it is invalid.
  final Text? description;

  /// Error message below the field, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Value picked at start. When the parent changes it, the field follows.
  final String? value;

  /// Called with the value of the picked option.
  final ValueChanged<String>? onChange;

  /// Called with the text on every change.
  final ValueChanged<String>? onInputChange;

  /// Keeps a typed text that is not an option. Otherwise the text goes back to the
  /// picked option when the field loses the focus.
  final bool allowsCustomValue;

  final bool isInvalid;
  final bool isRequired;
  final bool isDisabled;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumComboBox({
    super.key,
    required this.children,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.value,
    this.onChange,
    this.onInputChange,
    this.allowsCustomValue = false,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.labelPosition,
  });

  @override
  State<SpectrumComboBox> createState() => _SpectrumComboBoxState();
}

class _SpectrumComboBoxState extends State<SpectrumComboBox> {
  final TextEditingController _controller = TextEditingController();
  final OverlayPortalController _overlay = OverlayPortalController();
  final LayerLink _link = LayerLink();
  String? _value;

  /// Text that filters the options, or empty to show all of them.
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _controller.text = spectrumOptionOf(widget.children, _value)?.child.data ?? '';
  }

  @override
  void didUpdateWidget(covariant SpectrumComboBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
      _controller.text = spectrumOptionOf(widget.children, _value)?.child.data ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Keeps the options whose label contains the filter, ignoring case.
  List<Object> get _filtered {
    final filter = _filter.toLowerCase();

    if (filter.isEmpty) {
      return widget.children;
    }

    bool matches(SpectrumPickerItem item) => (item.child.data ?? '').toLowerCase().contains(filter);
    final result = <Object>[];

    for (final option in widget.children) {
      if (option is SpectrumPickerItem && matches(option)) {
        result.add(option);
      } else if (option is SpectrumPickerSection) {
        final children = option.children.where(matches).toList();

        if (children.isNotEmpty) {
          result.add(SpectrumPickerSection(header: option.header, children: children));
        }
      }
    }

    return result;
  }

  void _open({bool showAll = false}) {
    setState(() {
      if (showAll) {
        _filter = '';
      }
    });
    _overlay.show();
  }

  void _close() {
    _overlay.hide();

    // Without custom values, the text goes back to the picked option.
    if (!widget.allowsCustomValue) {
      _controller.text = spectrumOptionOf(widget.children, _value)?.child.data ?? '';
    }
  }

  void _select(String value) {
    setState(() {
      _value = value;
      _filter = '';
    });
    _controller.text = spectrumOptionOf(widget.children, value)?.child.data ?? '';
    _overlay.hide();
    widget.onChange?.call(value);
  }

  Widget _buildList(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final options = _filtered;
    final width = _link.leaderSize?.width ?? 240;

    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        targetAnchor: Alignment.bottomLeft,
        offset: const Offset(0, 4),
        child: TapRegion(
          groupId: this,
          onTapOutside: (event) => _close(),
          // Spectrum 2 list: the popover of the menus, as wide as the field.
          child: Material(
            color: isDark ? colors.surfaceContainer : colors.surface,
            borderRadius: BorderRadius.circular(10),
            elevation: 4,
            shadowColor: colors.shadow,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: width, maxWidth: width, maxHeight: 320),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Visibility(
                  visible: options.isNotEmpty,
                  replacement: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'No results',
                      style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle()).copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: spectrumOptionsMenu(options: options, selected: _value, onSelect: _select),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: widget.isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      input: CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _overlay,
          overlayChildBuilder: _buildList,
          child: TapRegion(
            groupId: this,
            // The Escape key closes the list, and the down arrow opens it.
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): _close,
                const SingleActivator(LogicalKeyboardKey.arrowDown): () => _open(showAll: true),
              },
              child: SpectrumFieldInput(
                controller: _controller,
                isInvalid: widget.isInvalid,
                isDisabled: isDisabled,
                padding: const EdgeInsetsDirectional.only(start: 12, end: 2),
                onChanged: (text) {
                  setState(() => _filter = text);
                  _overlay.show();
                  widget.onInputChange?.call(text);
                },
                onFocusChange: (hasFocus) {
                  if (!hasFocus && !_overlay.isShowing) {
                    _close();
                  }
                },
                // The button at the end opens the whole list.
                trailing: Semantics(
                  label: 'Show suggestions',
                  child: SpectrumActionButton(
                    icon: SpectrumIcon(SpectrumIcons.chevronDown, color: isDisabled ? colors.outline : null),
                    isQuiet: true,
                    isDisabled: isDisabled,
                    onTap: () => _overlay.isShowing ? _close() : _open(showAll: true),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
