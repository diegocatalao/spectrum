/// How a group manages the selection of its items, as the `selects`
/// attribute of sp-action-group and sp-menu-group.
enum SpectrumSelects {
  /// The group does not manage the selection.
  none,

  /// Only one item is selected at a time, as radio buttons.
  single,

  /// Any number of items can be selected, as checkboxes.
  multiple,
}
