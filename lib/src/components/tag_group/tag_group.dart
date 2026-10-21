import 'package:flutter/material.dart';
import 'package:spectrum/spectrum.dart';

/// Spectrum Tag Group: a list of SpectrumTag, like the keywords of a file, that can
/// be selected or removed, with a label, a help text and an error message.
class SpectrumTagGroup extends StatefulWidget {
  /// Tags of the group.
  final List<SpectrumTag> children;

  /// Label of the group.
  final Text? label;

  /// Help text below the group, hidden while it is invalid.
  final Text? description;

  /// Error message below the group, shown while it is invalid.
  final Text? errorMessage;

  /// SpectrumContextualHelp shown next to the label.
  final Widget? contextualHelp;

  /// Whether no tag, one tag or many tags can be selected.
  final SpectrumSelects selects;

  /// Indexes of the tags selected at start. When the parent changes them, the group follows.
  final List<int> selected;

  /// Called with the new selected indexes when a tag is tapped.
  final ValueChanged<List<int>>? onSelectionChange;

  /// Called with the index of the tag whose remove button was tapped. When set, every
  /// tag shows the remove button.
  final ValueChanged<int>? onRemove;

  /// Text of the button after the tags, like "Clear all".
  final String? groupActionLabel;

  /// Called when the group action button is tapped.
  final VoidCallback? onGroupAction;

  /// Fills the selected tags with the accent blue.
  final bool isEmphasized;

  /// Grays out every tag.
  final bool isDisabled;

  /// Shows the error message below the tags.
  final bool isInvalid;

  /// Where the label is placed, from the SpectrumForm when null.
  final SpectrumLabelPosition? labelPosition;

  const SpectrumTagGroup({
    super.key,
    required this.children,
    this.label,
    this.description,
    this.errorMessage,
    this.contextualHelp,
    this.selects = SpectrumSelects.none,
    this.selected = const [],
    this.onSelectionChange,
    this.onRemove,
    this.groupActionLabel,
    this.onGroupAction,
    this.isEmphasized = false,
    this.isDisabled = false,
    this.isInvalid = false,
    this.labelPosition,
  });

  /// Returns the state of the tag inside a group, or null outside of one.
  static ({bool isSelected, bool isEmphasized, bool isDisabled, VoidCallback? onTap, VoidCallback? onRemove})? tagOf(
    BuildContext context,
  ) {
    final scope = context.dependOnInheritedWidgetOfExactType<_TagScope>();

    if (scope == null) {
      return null;
    }

    return (
      isSelected: scope.isSelected,
      isEmphasized: scope.isEmphasized,
      isDisabled: scope.isDisabled,
      onTap: scope.onTap,
      onRemove: scope.onRemove,
    );
  }

  @override
  State<SpectrumTagGroup> createState() => _SpectrumTagGroupState();
}

class _SpectrumTagGroupState extends State<SpectrumTagGroup> {
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.selected);
  }

  @override
  void didUpdateWidget(covariant SpectrumTagGroup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected.length != widget.selected.length || !_selected.containsAll(widget.selected)) {
      _selected
        ..clear()
        ..addAll(widget.selected);
    }
  }

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else if (widget.selects == SpectrumSelects.multiple) {
        _selected.add(index);
      } else {
        _selected
          ..clear()
          ..add(index);
      }
    });
    widget.onSelectionChange?.call(_selected.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled || SpectrumForm.isDisabledOf(context);
    final isSelectable = widget.selects != SpectrumSelects.none;

    return Semantics(
      container: true,
      label: widget.label?.data,
      child: SpectrumField(
        label: widget.label,
        description: widget.description,
        errorMessage: widget.errorMessage,
        contextualHelp: widget.contextualHelp,
        isInvalid: widget.isInvalid,
        isDisabled: isDisabled,
        labelPosition: widget.labelPosition,
        // The tags wrap to new lines, 8px apart, followed by the group action.
        input: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final (index, tag) in widget.children.indexed)
              _TagScope(
                isSelected: _selected.contains(index),
                isEmphasized: widget.isEmphasized,
                isDisabled: isDisabled,
                onTap: isSelectable ? () => _toggle(index) : null,
                onRemove: widget.onRemove == null ? null : () => widget.onRemove!(index),
                child: tag,
              ),
            Visibility(
              visible: widget.groupActionLabel != null,
              child: SpectrumActionButton(
                isQuiet: true,
                isDisabled: isDisabled,
                onTap: widget.onGroupAction,
                child: Text(widget.groupActionLabel ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagScope extends InheritedWidget {
  final bool isSelected;
  final bool isEmphasized;
  final bool isDisabled;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const _TagScope({
    required this.isSelected,
    required this.isEmphasized,
    required this.isDisabled,
    required this.onTap,
    required this.onRemove,
    required super.child,
  });

  @override
  bool updateShouldNotify(_TagScope oldWidget) {
    return oldWidget.isSelected != isSelected ||
        oldWidget.isEmphasized != isEmphasized ||
        oldWidget.isDisabled != isDisabled ||
        (oldWidget.onRemove == null) != (onRemove == null) ||
        (oldWidget.onTap == null) != (onTap == null);
  }
}
