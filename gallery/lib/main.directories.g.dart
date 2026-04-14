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
];
