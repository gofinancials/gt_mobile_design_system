import 'package:flutter/material.dart';
import 'package:gallery/widgets/widgets.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:gt_mobile_ui/gt_mobile_ui.dart';

@widgetbook.UseCase(name: 'Palette', type: GtColors)
Widget playgroundPaletteUseCase(BuildContext context) {
  return const _PalettePage();
}

class _PaletteCategory {
  final String name;
  final String id;
  final String description;
  final List<_NamedColor> colors;

  const _PaletteCategory({
    required this.name,
    required this.id,
    required this.description,
    required this.colors,
  });
}

class _NamedColor {
  final String label;
  final Color Function(GtPalette palette) color;

  const _NamedColor({required this.label, required this.color});
}

List<_PaletteCategory> _buildCategories(GtPalette p) => [
  _PaletteCategory(
    name: 'Primary / Brand',
    description: 'Core brand identity colours',
    id: 'primary',
    colors: [
      _NamedColor(label: 'dark', color: (p) => p.primary.dark),
      _NamedColor(label: 'darker', color: (p) => p.primary.darker),
      _NamedColor(label: 'base', color: (p) => p.primary.base),
      _NamedColor(label: 'alpha24', color: (p) => p.primary.alpha24),
      _NamedColor(label: 'alpha16', color: (p) => p.primary.alpha16),
      _NamedColor(label: 'alpha10', color: (p) => p.primary.alpha10),
    ],
  ),
  _PaletteCategory(
    name: 'Background',
    description: 'Surface and container backgrounds',
    id: 'bg',
    colors: [
      _NamedColor(label: 'strong', color: (p) => p.bg.strong),
      _NamedColor(label: 'surface', color: (p) => p.bg.surface),
      _NamedColor(label: 'sub', color: (p) => p.bg.sub),
      _NamedColor(label: 'soft', color: (p) => p.bg.soft),
      _NamedColor(label: 'weak', color: (p) => p.bg.weak),
      _NamedColor(label: 'weaker', color: (p) => p.bg.weaker),
      _NamedColor(label: 'white', color: (p) => p.bg.white),
      _NamedColor(label: 'warm', color: (p) => p.bg.warm),
      _NamedColor(label: 'neutralWarm50', color: (p) => p.bg.neutralWarm50),
      _NamedColor(label: 'sky', color: (p) => p.bg.sky),
    ],
  ),
  _PaletteCategory(
    name: 'Fill',
    description: 'Filled container backgrounds',
    id: 'fill',
    colors: [
      _NamedColor(label: 'strong', color: (p) => p.fill.strong),
      _NamedColor(label: 'surface', color: (p) => p.fill.surface),
      _NamedColor(label: 'sub', color: (p) => p.fill.sub),
      _NamedColor(label: 'soft', color: (p) => p.fill.soft),
      _NamedColor(label: 'weak', color: (p) => p.fill.weak),
      _NamedColor(label: 'weaker', color: (p) => p.fill.weaker),
      _NamedColor(label: 'white', color: (p) => p.fill.white),
      _NamedColor(label: 'warm', color: (p) => p.fill.warm),
      _NamedColor(label: 'neutralWarm50', color: (p) => p.fill.neutralWarm50),
      _NamedColor(label: 'sky', color: (p) => p.fill.sky),
    ],
  ),
  _PaletteCategory(
    name: 'Text',
    description: 'Typography content colours',
    id: 'text',
    colors: [
      _NamedColor(label: 'strong', color: (p) => p.text.strong),
      _NamedColor(label: 'sub', color: (p) => p.text.sub),
      _NamedColor(label: 'soft', color: (p) => p.text.soft),
      _NamedColor(label: 'disabled', color: (p) => p.text.disabled),
      _NamedColor(label: 'white', color: (p) => p.text.white),
      _NamedColor(label: 'darkerSub', color: (p) => p.text.darkerSub),
    ],
  ),
  _PaletteCategory(
    name: 'Stroke',
    description: 'Border and divider colours',
    id: 'stroke',
    colors: [
      _NamedColor(label: 'strong', color: (p) => p.stroke.strong),
      _NamedColor(label: 'sub', color: (p) => p.stroke.sub),
      _NamedColor(label: 'soft', color: (p) => p.stroke.soft),
      _NamedColor(label: 'white', color: (p) => p.stroke.white),
    ],
  ),
  _PaletteCategory(
    name: 'Icon',
    description: 'Iconography colours',
    id: 'icon',
    colors: [
      _NamedColor(label: 'strong', color: (p) => p.icon.strong),
      _NamedColor(label: 'sub', color: (p) => p.icon.sub),
      _NamedColor(label: 'soft', color: (p) => p.icon.soft),
      _NamedColor(label: 'disabled', color: (p) => p.icon.disabled),
      _NamedColor(label: 'white', color: (p) => p.icon.white),
    ],
  ),
  _PaletteCategory(
    name: 'Faded',
    description: 'Muted / low-emphasis state colours',
    id: 'faded',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.faded.darker),
      _NamedColor(label: 'dark', color: (p) => p.faded.dark),
      _NamedColor(label: 'base', color: (p) => p.faded.base),
      _NamedColor(label: 'light', color: (p) => p.faded.light),
      _NamedColor(label: 'lighter', color: (p) => p.faded.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Information',
    description: 'Info alerts, banners, badges',
    id: 'info',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.information.darker),
      _NamedColor(label: 'dark', color: (p) => p.information.dark),
      _NamedColor(label: 'base', color: (p) => p.information.base),
      _NamedColor(label: 'light', color: (p) => p.information.light),
      _NamedColor(label: 'lighter', color: (p) => p.information.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Alternative Information',
    description: 'Alternative info alerts, banners, badges',
    id: 'infoAlt',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.infoAlt.darker),
      _NamedColor(label: 'dark', color: (p) => p.infoAlt.dark),
      _NamedColor(label: 'base', color: (p) => p.infoAlt.base),
      _NamedColor(label: 'light', color: (p) => p.infoAlt.light),
      _NamedColor(label: 'lighter', color: (p) => p.infoAlt.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Warning',
    description: 'Warning alerts, banners, badges',
    id: 'warning',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.warning.darker),
      _NamedColor(label: 'dark', color: (p) => p.warning.dark),
      _NamedColor(label: 'base', color: (p) => p.warning.base),
      _NamedColor(label: 'light', color: (p) => p.warning.light),
      _NamedColor(label: 'lighter', color: (p) => p.warning.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Error',
    description: 'Error alerts, validation, destructive actions',
    id: 'error',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.error.darker),
      _NamedColor(label: 'dark', color: (p) => p.error.dark),
      _NamedColor(label: 'base', color: (p) => p.error.base),
      _NamedColor(label: 'light', color: (p) => p.error.light),
      _NamedColor(label: 'lighter', color: (p) => p.error.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Success',
    description: 'Success alerts, confirmations, positive states',
    id: 'success',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.success.darker),
      _NamedColor(label: 'dark', color: (p) => p.success.dark),
      _NamedColor(label: 'base', color: (p) => p.success.base),
      _NamedColor(label: 'light', color: (p) => p.success.light),
      _NamedColor(label: 'lighter', color: (p) => p.success.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Away',
    description: 'Neutral / tertiary accent',
    id: 'away',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.away.darker),
      _NamedColor(label: 'dark', color: (p) => p.away.dark),
      _NamedColor(label: 'base', color: (p) => p.away.base),
      _NamedColor(label: 'light', color: (p) => p.away.light),
      _NamedColor(label: 'lighter', color: (p) => p.away.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Feature',
    description: 'Feature highlights and promotions',
    id: 'feature',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.feature.darker),
      _NamedColor(label: 'dark', color: (p) => p.feature.dark),
      _NamedColor(label: 'base', color: (p) => p.feature.base),
      _NamedColor(label: 'light', color: (p) => p.feature.light),
      _NamedColor(label: 'lighter', color: (p) => p.feature.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Verified',
    description: 'Verification and trust indicators',
    id: 'verified',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.verified.darker),
      _NamedColor(label: 'dark', color: (p) => p.verified.dark),
      _NamedColor(label: 'base', color: (p) => p.verified.base),
      _NamedColor(label: 'light', color: (p) => p.verified.light),
      _NamedColor(label: 'lighter', color: (p) => p.verified.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Highlighted',
    description: 'Selection and highlight states',
    id: 'highlighted',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.highlighted.darker),
      _NamedColor(label: 'dark', color: (p) => p.highlighted.dark),
      _NamedColor(label: 'base', color: (p) => p.highlighted.base),
      _NamedColor(label: 'light', color: (p) => p.highlighted.light),
      _NamedColor(label: 'lighter', color: (p) => p.highlighted.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Stable',
    description: 'Stable / neutral state indicators',
    id: 'stable',
    colors: [
      _NamedColor(label: 'darker', color: (p) => p.stable.darker),
      _NamedColor(label: 'dark', color: (p) => p.stable.dark),
      _NamedColor(label: 'base', color: (p) => p.stable.base),
      _NamedColor(label: 'light', color: (p) => p.stable.light),
      _NamedColor(label: 'lighter', color: (p) => p.stable.lighter),
    ],
  ),
  _PaletteCategory(
    name: 'Cover',
    description: 'Splash and cover screen colours',
    id: 'coverColors',
    colors: [
      _NamedColor(label: 'light', color: (p) => p.coverColors.light),
      _NamedColor(label: 'dark', color: (p) => p.coverColors.dark),
    ],
  ),
  _PaletteCategory(
    name: 'Static',
    id: 'staticColors',
    description: 'Absolute black, white, and shadow',
    colors: [
      _NamedColor(label: 'black', color: (p) => p.staticColors.black),
      _NamedColor(label: 'white', color: (p) => p.staticColors.white),
      _NamedColor(label: 'shadow', color: (p) => p.staticColors.shadow),
    ],
  ),
];

class _PalettePage extends StatefulWidget {
  const _PalettePage();

  @override
  State<_PalettePage> createState() => _PalettePageState();
}

class _PalettePageState extends State<_PalettePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final categories = _buildCategories(palette);

    final filtered = _query.isEmpty
        ? categories
        : categories
              .map(
                (cat) => _PaletteCategory(
                  name: cat.name,
                  description: cat.description,
                  id: cat.id,
                  colors: cat.colors.where((c) {
                    final hex = _toHex(c.color(palette));
                    return c.label.lower.contains(_query) ||
                        hex.lower.contains(_query);
                  }).toList(),
                ),
              )
              .where((cat) => cat.colors.isNotEmpty)
              .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: context.insets.defaultAllInsets,
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: context.spacingMd,
            children: [
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  GalleryPageHeader(
                    title: 'Colour Palette',
                    rider:
                        '${categories.length} categories · ${categories.fold<int>(0, (s, c) => s + c.colors.length)} tokens · Tap to copy hex',
                  ),
                  GtTextField(
                    hintText: 'Search by name or hex...',
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v ?? ''),
                    decoration: context.inputStyles.searchDecoration,
                    prefix: GtIcon(GtIcons.magnifier, variant: .sub),
                    textInputAction: TextInputAction.search,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  key: const PageStorageKey("colors_palette"),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final cat = filtered[i];
                    return GallerySectionCard(
                      cat.name,
                      rider: cat.description,
                      child: Column(
                        children: [
                          for (final (index, nc) in cat.colors.indexed)
                            _ColorChip(
                              nc,
                              cat.id,
                              index: index,
                              length: cat.colors.length,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _searchCtrl = GtInputController();

class _ColorChip extends StatelessWidget {
  final _NamedColor color;
  final String id;
  final int index;
  final int length;

  const _ColorChip(
    this.color,
    this.id, {
    required this.index,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = this.color.color(palette);
    final hex = _toHex(color);
    final label = this.color.label;
    final isFirst = index == 0;
    final isLast = index == length - 1;
    final radius = context.dp(context.radii.md.px);

    BorderRadius borderRadius = .zero;

    if (isLast) {
      borderRadius = radius.bottomBorderRadius;
    }
    if (isFirst) {
      borderRadius = radius.topBorderRadius;
    }

    return GtCard(
      onPressed: () {
        context.copyTextToClipboard(hex);
      },
      color: color,
      borderRadius: borderRadius,
      padding: context.insets.allDp(12.px),
      child: GtPill(
        text: "context.palette.$id.$label  [$hex]",
        variant: .strong,
        bgColor: context.palette.bg.white,
        textStyle: context.textStyles.buttonXs(),
        padding: context.insets.symmetricDp(vertical: 4.px, horizontal: 8.px),
        borderRadius: context.borderRadius2Xl,
        alignment: .centerLeft,
      ),
    );
  }
}

String _toHex(Color color) {
  String hex = color.toCssHex(includeAlpha: true);
  if (hex.length > 7 && hex.lower.endsWith('ff')) {
    hex = hex.substring(0, hex.length - 2);
  }
  return hex.upper;
}
