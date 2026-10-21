import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Picker: a button that opens a menu of options to pick one, showing the
/// picked option, with a label, a help text and an error message.
class SpectrumPicker extends StatefulWidget {
  /// Options of the menu: SpectrumPickerItem and SpectrumPickerSection.
  final List<Object> children;

  /// Label of the picker.
  final Text? label;

  /// Help text below the picker, hidden while it is invalid.
  final Text? description;

  /// Error message below the picker, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Text shown while no option is picked.
  final String placeholder;

  /// Value picked at start. When the parent changes it, the picker follows.
  final String? value;

  /// Called with the value of the picked option.
  final ValueChanged<String>? onChange;

  /// Removes the gray background of the button.
  final bool isQuiet;

  final bool isInvalid;
  final bool isRequired;
  final bool isDisabled;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumPicker({
    super.key,
    required this.children,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.placeholder = 'Select…',
    this.value,
    this.onChange,
    this.isQuiet = false,
    this.isInvalid = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.labelPosition,
  });

  @override
  State<SpectrumPicker> createState() => _SpectrumPickerState();
}

class _SpectrumPickerState extends State<SpectrumPicker> {
  String? _value;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SpectrumPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _select(String value) {
    if (mounted) {
      setState(() => _value = value);
    }

    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final option = spectrumOptionOf(widget.children, _value);
    final showFocusRing = _isFocused && FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final style = Theme.of(context).textTheme.bodySmall ?? const TextStyle();

    return SpectrumField(
      label: widget.label,
      description: widget.description,
      errorMessage: widget.errorMessage,
      contextualHelp: widget.contextualHelp,
      isInvalid: widget.isInvalid,
      isRequired: widget.isRequired,
      isDisabled: isDisabled,
      labelPosition: widget.labelPosition,
      input: MenuAnchor(
        style: SpectrumSubmenuTrigger.menuStyleOf(context),
        alignmentOffset: const Offset(0, 4),
        menuChildren: spectrumOptionsMenu(options: widget.children, selected: _value, onSelect: _select),
        builder: (context, controller, child) {
          final Color background, content;

          if (isDisabled) {
            background = widget.isQuiet ? Colors.transparent : colors.surfaceContainerHigh;
            content = colors.outline;
          } else if (widget.isQuiet) {
            background = Colors.transparent;
            content = colors.onSurface;
          } else {
            // Spectrum 2 picker button: gray-100, gray-200 while open or hovered.
            background = controller.isOpen || _isHovered ? colors.surfaceContainerHighest : colors.surfaceContainerHigh;
            content = colors.onSurface;
          }

          return Semantics(
            button: true,
            expanded: controller.isOpen,
            label: widget.label?.data,
            value: option?.child.data,
            child: Material(
              color: background,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: isDisabled ? null : () => controller.isOpen ? controller.close() : controller.open(),
                onHover: (value) => setState(() => _isHovered = value),
                onFocusChange: (value) => setState(() => _isFocused = value),
                // 32px high, 12px from the edges (none when quiet), the picked option or the
                // placeholder, the red alert icon when invalid and the chevron at the end.
                child: Container(
                  height: 32,
                  padding: EdgeInsets.symmetric(horizontal: widget.isQuiet ? 0 : 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: showFocusRing ? context.spectrum.focusIndicator : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: widget.isQuiet ? MainAxisSize.min : MainAxisSize.max,
                    spacing: 6,
                    children: [
                      Visibility(
                        visible: option?.icon != null,
                        child: IconTheme.merge(
                          data: IconThemeData(color: content),
                          child: option?.icon ?? const SizedBox.shrink(),
                        ),
                      ),
                      Flexible(
                        fit: widget.isQuiet ? FlexFit.loose : FlexFit.tight,
                        child: Text(
                          option?.child.data ?? widget.placeholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style.copyWith(color: option == null ? colors.onSurfaceVariant : content),
                        ),
                      ),
                      Visibility(
                        visible: widget.isInvalid && !isDisabled,
                        child: SpectrumIcon(SpectrumIcons.alert, size: 14, color: colors.error),
                      ),
                      SpectrumIcon(SpectrumIcons.chevronDown, color: content),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
