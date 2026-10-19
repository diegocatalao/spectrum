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
import 'package:widgetbook_workspace/components/actions/icon_button/icon_button.dart'
    as _widgetbook_workspace_components_actions_icon_button_icon_button;
import 'package:widgetbook_workspace/components/actions/menu/menu.dart'
    as _widgetbook_workspace_components_actions_menu_menu;
import 'package:widgetbook_workspace/components/actions/menu/menu_group/menu_group.dart'
    as _widgetbook_workspace_components_actions_menu_menu_group_menu_group;
import 'package:widgetbook_workspace/components/actions/menu/menu_item/menu_item.dart'
    as _widgetbook_workspace_components_actions_menu_menu_item_menu_item;
import 'package:widgetbook_workspace/components/button/close_button.dart'
    as _widgetbook_workspace_components_button_close_button;
import 'package:widgetbook_workspace/components/containers/divider/divider.dart'
    as _widgetbook_workspace_components_containers_divider_divider;

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
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'button',
        children: [
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
        ],
      ),
    ],
  ),
];
