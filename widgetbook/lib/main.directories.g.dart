// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:widgetbook/widgetbook.dart' as _widgetbook;
import 'package:widgetbook_workspace/components/accordion/accordion.dart'
    as _widgetbook_workspace_components_accordion_accordion;
import 'package:widgetbook_workspace/components/accordion/accordion_item/accordion_item.dart'
    as _widgetbook_workspace_components_accordion_accordion_item_accordion_item;
import 'package:widgetbook_workspace/components/actions/action_bar/action_bar.dart'
    as _widgetbook_workspace_components_actions_action_bar_action_bar;
import 'package:widgetbook_workspace/components/actions/action_button/action_button.dart'
    as _widgetbook_workspace_components_actions_action_button_action_button;
import 'package:widgetbook_workspace/components/actions/action_group/action_group.dart'
    as _widgetbook_workspace_components_actions_action_group_action_group;
import 'package:widgetbook_workspace/components/actions/action_menu/action_menu.dart'
    as _widgetbook_workspace_components_actions_action_menu_action_menu;
import 'package:widgetbook_workspace/components/actions/button/button.dart'
    as _widgetbook_workspace_components_actions_button_button;
import 'package:widgetbook_workspace/components/actions/button_group/button_group.dart'
    as _widgetbook_workspace_components_actions_button_group_button_group;
import 'package:widgetbook_workspace/components/actions/icon_button/icon_button.dart'
    as _widgetbook_workspace_components_actions_icon_button_icon_button;
import 'package:widgetbook_workspace/components/actions/menu/menu.dart'
    as _widgetbook_workspace_components_actions_menu_menu;
import 'package:widgetbook_workspace/components/actions/menu/menu_group/menu_group.dart'
    as _widgetbook_workspace_components_actions_menu_menu_group_menu_group;
import 'package:widgetbook_workspace/components/actions/menu/menu_item/menu_item.dart'
    as _widgetbook_workspace_components_actions_menu_menu_item_menu_item;
import 'package:widgetbook_workspace/components/actions/quick_actions/quick_actions.dart'
    as _widgetbook_workspace_components_actions_quick_actions_quick_actions;
import 'package:widgetbook_workspace/components/actions/segmented_control/segmented_control.dart'
    as _widgetbook_workspace_components_actions_segmented_control_segmented_control;
import 'package:widgetbook_workspace/components/actions/toggle_button/toggle_button.dart'
    as _widgetbook_workspace_components_actions_toggle_button_toggle_button;
import 'package:widgetbook_workspace/components/actions/toggle_button_group/toggle_button_group.dart'
    as _widgetbook_workspace_components_actions_toggle_button_group_toggle_button_group;
import 'package:widgetbook_workspace/components/actions/toolbar/toolbar.dart'
    as _widgetbook_workspace_components_actions_toolbar_toolbar;
import 'package:widgetbook_workspace/components/button/clear_button.dart'
    as _widgetbook_workspace_components_button_clear_button;
import 'package:widgetbook_workspace/components/button/close_button.dart'
    as _widgetbook_workspace_components_button_close_button;
import 'package:widgetbook_workspace/components/containers/contextual_help/contextual_help.dart'
    as _widgetbook_workspace_components_containers_contextual_help_contextual_help;
import 'package:widgetbook_workspace/components/containers/dialog/dialog.dart'
    as _widgetbook_workspace_components_containers_dialog_dialog;
import 'package:widgetbook_workspace/components/containers/divider/divider.dart'
    as _widgetbook_workspace_components_containers_divider_divider;
import 'package:widgetbook_workspace/components/containers/fullscreen_dialog/fullscreen_dialog.dart'
    as _widgetbook_workspace_components_containers_fullscreen_dialog_fullscreen_dialog;
import 'package:widgetbook_workspace/components/containers/image/image.dart'
    as _widgetbook_workspace_components_containers_image_image;
import 'package:widgetbook_workspace/components/containers/popover/popover.dart'
    as _widgetbook_workspace_components_containers_popover_popover;
import 'package:widgetbook_workspace/components/containers/tray/tray.dart'
    as _widgetbook_workspace_components_containers_tray_tray;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'components',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'accordion',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'SpectrumAccordion',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Actions',
                builder: _widgetbook_workspace_components_accordion_accordion
                    .BuildAccordionActions,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled Item',
                builder: _widgetbook_workspace_components_accordion_accordion
                    .BuildAccordionDisabledItem,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Expanding',
                builder: _widgetbook_workspace_components_accordion_accordion
                    .BuildAccordionExpanding,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Long Title',
                builder: _widgetbook_workspace_components_accordion_accordion
                    .BuildAccordionLongTitle,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Presentation',
                builder: _widgetbook_workspace_components_accordion_accordion
                    .BuildAccordionPresentation,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Rich Panel',
                builder: _widgetbook_workspace_components_accordion_accordion
                    .BuildAccordionRichPanel,
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'accordion_item',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumAccordionItem',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_accordion_accordion_item_accordion_item
                            .BuildAccordionItemPresentation,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'actions',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'action_bar',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumActionBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_action_bar_action_bar
                            .BuildActionBarPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'action_button',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumActionButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_action_button_action_button
                            .BuildActionButtonPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'action_group',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumActionGroup',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_action_group_action_group
                            .BuildActionGroupPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'action_menu',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumActionMenu',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_action_menu_action_menu
                            .BuildActionMenuPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'button',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_button_button
                            .BuildButtonPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'button_group',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumButtonGroup',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_button_group_button_group
                            .BuildButtonGroupPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'icon_button',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumIconButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_icon_button_icon_button
                            .BuildIconButtonPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'menu',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumMenu',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder: _widgetbook_workspace_components_actions_menu_menu
                        .BuildMenuPresentation,
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'menu_group',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'SpectrumMenuGroup',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Presentation',
                        builder:
                            _widgetbook_workspace_components_actions_menu_menu_group_menu_group
                                .BuildMenuGroupPresentation,
                      ),
                    ],
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'menu_item',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'SpectrumMenuItem',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Presentation',
                        builder:
                            _widgetbook_workspace_components_actions_menu_menu_item_menu_item
                                .BuildMenuItemPresentation,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'quick_actions',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumQuickActions',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_quick_actions_quick_actions
                            .BuildQuickActionsPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'segmented_control',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumSegmentedControl',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_segmented_control_segmented_control
                            .BuildSegmentedControlPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'toggle_button',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumToggleButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_toggle_button_toggle_button
                            .BuildToggleButtonPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'toggle_button_group',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumToggleButtonGroup',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_toggle_button_group_toggle_button_group
                            .BuildToggleButtonGroupPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'toolbar',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumToolbar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_actions_toolbar_toolbar
                            .BuildToolbarPresentation,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'button',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'SpectrumClearButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Presentation',
                builder: _widgetbook_workspace_components_button_clear_button
                    .BuildClearButtonPresentation,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'SpectrumCloseButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Presentation',
                builder: _widgetbook_workspace_components_button_close_button
                    .BuildCloseButtonPresentation,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'containers',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'contextual_help',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumContextualHelp',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_contextual_help_contextual_help
                            .BuildContextualHelpPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'dialog',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumDialog',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_dialog_dialog
                            .BuildDialogPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'divider',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumDivider',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_divider_divider
                            .BuildDividerPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'fullscreen_dialog',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumFullscreenDialog',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_fullscreen_dialog_fullscreen_dialog
                            .BuildFullscreenDialogPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'image',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumImage',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_image_image
                            .BuildImagePresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'popover',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumPopover',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_popover_popover
                            .BuildPopoverPresentation,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'tray',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SpectrumTray',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Presentation',
                    builder:
                        _widgetbook_workspace_components_containers_tray_tray
                            .BuildTrayPresentation,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
