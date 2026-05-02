// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gallery/atoms/borders.dart' as _gallery_atoms_borders;
import 'package:gallery/atoms/indicators/gt_indicators.dart.dart'
    as _gallery_atoms_indicators_gt_indicators;
import 'package:gallery/atoms/media/gt_icons.dart'
    as _gallery_atoms_media_gt_icons;
import 'package:gallery/atoms/media/gt_images.dart'
    as _gallery_atoms_media_gt_images;
import 'package:gallery/atoms/pallette.dart' as _gallery_atoms_pallette;
import 'package:gallery/atoms/shadows.dart' as _gallery_atoms_shadows;
import 'package:gallery/atoms/spacers/gt_divider.dart'
    as _gallery_atoms_spacers_gt_divider;
import 'package:gallery/atoms/spacers/gt_gap.dart'
    as _gallery_atoms_spacers_gt_gap;
import 'package:gallery/atoms/typography/gt_editable_text.dart'
    as _gallery_atoms_typography_gt_editable_text;
import 'package:gallery/atoms/typography/gt_rich_text.dart'
    as _gallery_atoms_typography_gt_rich_text;
import 'package:gallery/atoms/typography/gt_text.dart'
    as _gallery_atoms_typography_gt_text;
import 'package:gallery/gallery_cover.dart' as _gallery_gallery_cover;
import 'package:gallery/molecules/boxes/gt_boxes_usecase.dart'
    as _gallery_molecules_boxes_gt_boxes_usecase;
import 'package:gallery/molecules/buttons/gt_button_usecase.dart'
    as _gallery_molecules_buttons_gt_button_usecase;
import 'package:gallery/molecules/inputs/gt_inputs.dart'
    as _gallery_molecules_inputs_gt_inputs;
import 'package:gallery/molecules/media/gt_avatar.dart'
    as _gallery_molecules_media_gt_avatar;
import 'package:gallery/molecules/pills/gt_pill.dart'
    as _gallery_molecules_pills_gt_pill;
import 'package:gallery/molecules/text/gt_balance_text.dart'
    as _gallery_molecules_text_gt_balance_text;
import 'package:gallery/molecules/text/gt_status_text.dart'
    as _gallery_molecules_text_gt_status_text;
import 'package:gallery/molecules/tiles/gt_list_tile.dart'
    as _gallery_molecules_tiles_gt_list_tile;
import 'package:gallery/molecules/tiles/gt_list_tile_template.dart'
    as _gallery_molecules_tiles_gt_list_tile_template;
import 'package:gallery/organisms/app_bars/gt_home_app_bar.dart'
    as _gallery_organisms_app_bars_gt_home_app_bar;
import 'package:gallery/organisms/cards/gt_card.dart'
    as _gallery_organisms_cards_gt_card;
import 'package:gallery/organisms/grids/gt_grids.dart'
    as _gallery_organisms_grids_gt_grids;
import 'package:gallery/organisms/headers/gt_page_header.dart'
    as _gallery_organisms_headers_gt_page_header;
import 'package:gallery/organisms/menus/gt_context_menu.dart'
    as _gallery_organisms_menus_gt_context_menu;
import 'package:gallery/organisms/navigation/gt_bottom_navigation_bar.dart'
    as _gallery_organisms_navigation_gt_bottom_navigation_bar;
import 'package:gallery/organisms/slides/gt_slide.dart'
    as _gallery_organisms_slides_gt_slide;
import 'package:gallery/organisms/view_state/gt_empty_state.dart'
    as _gallery_organisms_view_state_gt_empty_state;
import 'package:gallery/organisms/view_state/gt_status_state.dart'
    as _gallery_organisms_view_state_gt_status_state;
import 'package:gallery/templates/dialogs/gt_confirm_dialog.dart'
    as _gallery_templates_dialogs_gt_confirm_dialog;
import 'package:gallery/templates/forms/gt_form.dart'
    as _gallery_templates_forms_gt_form;
import 'package:gallery/templates/modals/gt_bottom_modal.dart'
    as _gallery_templates_modals_gt_bottom_modal;
import 'package:gallery/templates/modals/gt_bottom_sheet.dart'
    as _gallery_templates_modals_gt_bottom_sheet;
import 'package:gallery/templates/overlays/gt_overlay.dart'
    as _gallery_templates_overlays_gt_overlay;
import 'package:gallery/templates/screens/gt_duo_tone_screen.dart'
    as _gallery_templates_screens_gt_duo_tone_screen;
import 'package:gallery/templates/screens/gt_how_to_screen.dart'
    as _gallery_templates_screens_gt_how_to_screen;
import 'package:gallery/templates/screens/gt_splash_screen.dart'
    as _gallery_templates_screens_gt_splash_screen;
import 'package:gallery/templates/slides/gt_slides.dart'
    as _gallery_templates_slides_gt_slides;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookComponent(
    name: 'DesignSystemCover',
    useCases: [
      _widgetbook.WidgetbookUseCase(
        name: 'Cover',
        builder: _gallery_gallery_cover.buildCover,
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'common',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'styling',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'GtColors',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Palette',
                builder: _gallery_atoms_pallette.playgroundPaletteUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'GtRadii',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Borders',
                builder: _gallery_atoms_borders.playgroundBordersUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'GtShadows',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Shadows',
                builder: _gallery_atoms_shadows.playgroundShadowsUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'atoms',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'indicators',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtSwitch',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtIndicators',
                    builder: _gallery_atoms_indicators_gt_indicators
                        .playgroundGtIndicatorsUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'media',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtIcon',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Vector Icons',
                    builder:
                        _gallery_atoms_media_gt_icons.playgroundIconsUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtImage',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Images',
                    builder:
                        _gallery_atoms_media_gt_images.playgroundImageUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'spacers',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtDivider',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Dividers',
                    builder: _gallery_atoms_spacers_gt_divider
                        .playgroundDividerUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtGap',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Gaps',
                    builder: _gallery_atoms_spacers_gt_gap.playgroundGapUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'typography',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtEditableText',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtEditableText',
                    builder: _gallery_atoms_typography_gt_editable_text
                        .playgroundGtEditableTextUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtRichText',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtRichText',
                    builder: _gallery_atoms_typography_gt_rich_text
                        .playgroundGtRichTextUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtText',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtText',
                    builder: _gallery_atoms_typography_gt_text
                        .playgroundGtTextUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'molecules',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'boxes',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtSizedBox',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtBoxes',
                    builder: _gallery_molecules_boxes_gt_boxes_usecase
                        .playgroundGtBoxesUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'buttons',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Buttons',
                    builder: _gallery_molecules_buttons_gt_button_usecase
                        .playgroundButtonsUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'inputs',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtCalendar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtCalendar',
                    builder: _gallery_molecules_inputs_gt_inputs
                        .buildGtCalendarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtPinInput',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtPinInput',
                    builder: _gallery_molecules_inputs_gt_inputs
                        .buildGtPinInputUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtTextField',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtTextField',
                    builder: _gallery_molecules_inputs_gt_inputs
                        .buildGtTextFieldUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'media',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtAvatar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtAvatar',
                    builder:
                        _gallery_molecules_media_gt_avatar.buildGtAvatarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtEditAvatar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtEditAvatar',
                    builder: _gallery_molecules_media_gt_avatar
                        .buildGtEditAvatarUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'pills',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtPill',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Pills Gallery',
                    builder:
                        _gallery_molecules_pills_gt_pill.buildGtPillUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'text',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtBalanceText',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Balance',
                    builder: _gallery_molecules_text_gt_balance_text
                        .playgroundGtBalanceTextUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtStatusText',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Access status',
                    builder: _gallery_molecules_text_gt_status_text
                        .playgroundGtStatusTextUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'tiles',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtBaseListTileTemplate',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'ListTileTemplates',
                    builder: _gallery_molecules_tiles_gt_list_tile_template
                        .gtListTileTemplateUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtListTile',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtListTiles',
                    builder: _gallery_molecules_tiles_gt_list_tile
                        .gtListTileAllUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'organisms',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'app_bars',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtActionAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtActionAppbar',
                    builder: _gallery_organisms_app_bars_gt_home_app_bar
                        .buildGtActionAppbarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtAppbar',
                    builder: _gallery_organisms_app_bars_gt_home_app_bar
                        .buildGtAppbarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtHomeAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtHomeAppbar',
                    builder: _gallery_organisms_app_bars_gt_home_app_bar
                        .buildGtHomeAppbarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtModalAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtTitleAppbar',
                    builder: _gallery_organisms_app_bars_gt_home_app_bar
                        .buildGtModalAppbarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtProAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtProAppbar',
                    builder: _gallery_organisms_app_bars_gt_home_app_bar
                        .buildGtProAppbarUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtTitleAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtTitleAppbar',
                    builder: _gallery_organisms_app_bars_gt_home_app_bar
                        .buildGtTitleAppbarUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'cards',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtCard',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Cards Gallery',
                    builder:
                        _gallery_organisms_cards_gt_card.buildGtCardUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'grids',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtTransferCategoryGrid',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtTransferCategoryGrid',
                    builder: _gallery_organisms_grids_gt_grids
                        .buildGtTransferCategoryGridUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'headers',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtPageHeader',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Page header',
                    builder: _gallery_organisms_headers_gt_page_header
                        .playgroundGtPageHeaderUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'menus',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtContextMenu',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtContextMenu',
                    builder: _gallery_organisms_menus_gt_context_menu
                        .buildGtContextMeunuUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'navigation',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtBottomNavigationBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Bottom Navigation Bar',
                    builder:
                        _gallery_organisms_navigation_gt_bottom_navigation_bar
                            .playgroundGtBottomNavigationBarUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'slides',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtSectionSlide',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtSectionSlide',
                    builder: _gallery_organisms_slides_gt_slide
                        .buildGtSectionSlideUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'view_state',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtEmptyState',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Empty state',
                    builder: _gallery_organisms_view_state_gt_empty_state
                        .playgroundGtEmptyStateUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtStatusState',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtStatusState',
                    builder: _gallery_organisms_view_state_gt_status_state
                        .playgroundGtStatusStateUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'templates',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'dialogs',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtConfirmDialog',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtConfirmDialog',
                    builder: _gallery_templates_dialogs_gt_confirm_dialog
                        .buildGtConfirmDialogUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'forms',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtVirtualKeypadForm',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtVirtualKeypadForm',
                    builder: _gallery_templates_forms_gt_form
                        .buildGtVirtualKeypadFormUsecase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtVirtualKeypadForm [Avatar]',
                    builder: _gallery_templates_forms_gt_form
                        .buildGtVirtualKeypadFormAvatarUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'modals',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtBottomModal',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtBottomModal',
                    builder: _gallery_templates_modals_gt_bottom_modal
                        .buildGtBottomModalUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtBottomSheet',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtBottomSheet',
                    builder: _gallery_templates_modals_gt_bottom_sheet
                        .buildGtBottomSheetUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'overlays',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtAlert',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtAlert',
                    builder: _gallery_templates_overlays_gt_overlay
                        .buildGtAlertUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtToast',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtToast',
                    builder: _gallery_templates_overlays_gt_overlay
                        .buildGtToastUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtDuotoneScreen',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtDuotoneScreen',
                    builder: _gallery_templates_screens_gt_duo_tone_screen
                        .buildGtDuotoneScreenUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtHowToScreen',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtHowToScreen',
                    builder: _gallery_templates_screens_gt_how_to_screen
                        .buildGtHowToScreenUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtSplashScreen',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtSplashScreen',
                    builder: _gallery_templates_screens_gt_splash_screen
                        .buildGtSplashScreenUsecase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'GtWelcomeScreen',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtWelcomeScreen',
                    builder: _gallery_templates_screens_gt_splash_screen
                        .buildtGWelcomeScreenUsecase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtWelcomeScreen.withTitleWidget',
                    builder: _gallery_templates_screens_gt_splash_screen
                        .buildGtWelcomeScreenTitleUsecase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'slides',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'GtWelcomeSlides',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'GtWelcomeSlides',
                    builder: _gallery_templates_slides_gt_slides
                        .buildGtWelcomeSlidesUsecase,
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
