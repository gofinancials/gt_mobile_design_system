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
import 'package:gallery/molecules/text/gt_balance_text.dart'
    as _gallery_molecules_text_gt_balance_text;
import 'package:gallery/molecules/tiles/gt_list_tile.dart'
    as _gallery_molecules_tiles_gt_list_tile;
import 'package:gallery/molecules/tiles/gt_list_tile_template.dart'
    as _gallery_molecules_tiles_gt_list_tile_template;
import 'package:gallery/organisms/cards/gt_card.dart'
    as _gallery_organisms_cards_gt_card;
import 'package:gallery/organisms/headers/gt_page_header.dart'
    as _gallery_organisms_headers_gt_page_header;
import 'package:gallery/organisms/navigation/gt_bottom_navigation_bar.dart'
    as _gallery_organisms_navigation_gt_bottom_navigation_bar;
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
  _widgetbook.WidgetbookCategory(
    name: 'Atoms',
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
      _widgetbook.WidgetbookFolder(
        name: 'Spacing',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'GtDivider',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Dividers',
                builder:
                    _gallery_atoms_spacers_gt_divider.playgroundDividerUseCase,
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
      _widgetbook.WidgetbookCategory(
        name: 'Images',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'GtIcon',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Vector Icons',
                builder: _gallery_atoms_media_gt_icons.playgroundIconsUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'GtImage',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Images',
                builder: _gallery_atoms_media_gt_images.playgroundImageUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookCategory(
        name: 'Indicators',
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
      _widgetbook.WidgetbookCategory(
        name: 'Typography',
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
                builder:
                    _gallery_atoms_typography_gt_text.playgroundGtTextUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Molecules',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'GtBoxes',
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
        name: 'GtButtons',
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
        name: 'GtText',
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
        ],
      ),
      _widgetbook.WidgetbookCategory(
        name: 'Tiles',
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
                builder:
                    _gallery_molecules_tiles_gt_list_tile.gtListTileAllUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Organisms',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'Headers',
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
        name: 'Navigation',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'GtBottomNavigationBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Bottom Navigation Bar',
                builder: _gallery_organisms_navigation_gt_bottom_navigation_bar
                    .playgroundGtBottomNavigationBarUseCase,
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
        name: 'organisms',
        children: [
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
        ],
      ),
    ],
  ),
];
