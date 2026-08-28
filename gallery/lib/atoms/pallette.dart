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
      _NamedColor(
        label: 'transparent',
        color: (p) => p.staticColors.transparent,
      ),
    ],
  ),
  _PaletteCategory(
    name: 'Cards',
    id: 'cards',
    description: 'Payment card colors',
    colors: [
      _NamedColor(label: 'classic', color: (p) => p.cardColors.classic),
      _NamedColor(label: 'business', color: (p) => p.cardColors.business),
      _NamedColor(label: 'prime', color: (p) => p.cardColors.prime),
      _NamedColor(label: 'worldStop1', color: (p) => p.cardColors.worldStop1),
      _NamedColor(label: 'worldStop2', color: (p) => p.cardColors.worldStop2),
      _NamedColor(label: 'worldStop3', color: (p) => p.cardColors.worldStop3),
    ],
  ),

  // ---------------------------------------------------------------------------
  // RAW TOKENS (context.palette.raw)
  // ---------------------------------------------------------------------------
  _PaletteCategory(
    name: 'Raw: Primitive & Static',
    description: 'Raw primitive base tokens (context.palette.raw.*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'ash', color: (p) => p.raw.ash),
      _NamedColor(label: 'night', color: (p) => p.raw.night),
      _NamedColor(label: 'white', color: (p) => p.raw.white),
      _NamedColor(label: 'cream', color: (p) => p.raw.cream),
      _NamedColor(label: 'black', color: (p) => p.raw.black),
      _NamedColor(label: 'tertiaryText', color: (p) => p.raw.tertiaryText),
      _NamedColor(label: 'transparent', color: (p) => p.raw.transparent),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Neutral / Text',
    description: 'Raw neutral scale tokens (context.palette.raw.neutral*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'neutral950', color: (p) => p.raw.neutral950),
      _NamedColor(label: 'neutral800', color: (p) => p.raw.neutral800),
      _NamedColor(label: 'neutral700', color: (p) => p.raw.neutral700),
      _NamedColor(label: 'neutral600', color: (p) => p.raw.neutral600),
      _NamedColor(label: 'neutral500', color: (p) => p.raw.neutral500),
      _NamedColor(label: 'neutral400', color: (p) => p.raw.neutral400),
      _NamedColor(label: 'neutral300', color: (p) => p.raw.neutral300),
      _NamedColor(label: 'neutral200', color: (p) => p.raw.neutral200),
      _NamedColor(label: 'neutral100', color: (p) => p.raw.neutral100),
      _NamedColor(label: 'neutral50', color: (p) => p.raw.neutral50),
      _NamedColor(label: 'neutral25', color: (p) => p.raw.neutral25),
      _NamedColor(label: 'neutral12', color: (p) => p.raw.neutral12),
      _NamedColor(label: 'neutral0', color: (p) => p.raw.neutral0),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Neutral / Gray',
    description: 'Raw neutral gray tokens (context.palette.raw.neutralGray*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'neutralGray950', color: (p) => p.raw.neutralGray950),
      _NamedColor(label: 'neutralGray900', color: (p) => p.raw.neutralGray900),
      _NamedColor(label: 'neutralGray800', color: (p) => p.raw.neutralGray800),
      _NamedColor(label: 'neutralGray700', color: (p) => p.raw.neutralGray700),
      _NamedColor(label: 'neutralGray600', color: (p) => p.raw.neutralGray600),
      _NamedColor(label: 'neutralGray500', color: (p) => p.raw.neutralGray500),
      _NamedColor(label: 'neutralGray400', color: (p) => p.raw.neutralGray400),
      _NamedColor(label: 'neutralGray300', color: (p) => p.raw.neutralGray300),
      _NamedColor(label: 'neutralGray200', color: (p) => p.raw.neutralGray200),
      _NamedColor(label: 'neutralGray100', color: (p) => p.raw.neutralGray100),
      _NamedColor(label: 'neutralGray50', color: (p) => p.raw.neutralGray50),
      _NamedColor(label: 'neutralWarm50', color: (p) => p.raw.neutralWarm50),
      _NamedColor(label: 'neutralGray0', color: (p) => p.raw.neutralGray0),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Blue',
    description: 'Raw vibrant blue scale (context.palette.raw.blue*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'blue950', color: (p) => p.raw.blue950),
      _NamedColor(label: 'blue900', color: (p) => p.raw.blue900),
      _NamedColor(label: 'blue800', color: (p) => p.raw.blue800),
      _NamedColor(label: 'blue700', color: (p) => p.raw.blue700),
      _NamedColor(label: 'blue600', color: (p) => p.raw.blue600),
      _NamedColor(label: 'blue500', color: (p) => p.raw.blue500),
      _NamedColor(label: 'blue400', color: (p) => p.raw.blue400),
      _NamedColor(label: 'blue300', color: (p) => p.raw.blue300),
      _NamedColor(label: 'blue200', color: (p) => p.raw.blue200),
      _NamedColor(label: 'blue100', color: (p) => p.raw.blue100),
      _NamedColor(label: 'blue50', color: (p) => p.raw.blue50),
      _NamedColor(label: 'blue', color: (p) => p.raw.blue),
      _NamedColor(label: 'navy', color: (p) => p.raw.navy),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Orange',
    description: 'Raw vibrant orange scale (context.palette.raw.orange*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'orange950', color: (p) => p.raw.orange950),
      _NamedColor(label: 'orange900', color: (p) => p.raw.orange900),
      _NamedColor(label: 'orange800', color: (p) => p.raw.orange800),
      _NamedColor(label: 'orange700', color: (p) => p.raw.orange700),
      _NamedColor(label: 'orange600', color: (p) => p.raw.orange600),
      _NamedColor(label: 'orange500', color: (p) => p.raw.orange500),
      _NamedColor(label: 'orange400', color: (p) => p.raw.orange400),
      _NamedColor(label: 'orange300', color: (p) => p.raw.orange300),
      _NamedColor(label: 'orange200', color: (p) => p.raw.orange200),
      _NamedColor(label: 'orange100', color: (p) => p.raw.orange100),
      _NamedColor(label: 'orange50', color: (p) => p.raw.orange50),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Red',
    description: 'Raw vibrant red scale (context.palette.raw.red*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'red950', color: (p) => p.raw.red950),
      _NamedColor(label: 'red900', color: (p) => p.raw.red900),
      _NamedColor(label: 'red800', color: (p) => p.raw.red800),
      _NamedColor(label: 'red700', color: (p) => p.raw.red700),
      _NamedColor(label: 'red600', color: (p) => p.raw.red600),
      _NamedColor(label: 'red500', color: (p) => p.raw.red500),
      _NamedColor(label: 'red400', color: (p) => p.raw.red400),
      _NamedColor(label: 'red300', color: (p) => p.raw.red300),
      _NamedColor(label: 'red200', color: (p) => p.raw.red200),
      _NamedColor(label: 'red100', color: (p) => p.raw.red100),
      _NamedColor(label: 'red50', color: (p) => p.raw.red50),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Green',
    description: 'Raw vibrant green scale (context.palette.raw.green*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'green950', color: (p) => p.raw.green950),
      _NamedColor(label: 'green925', color: (p) => p.raw.green925),
      _NamedColor(label: 'green900', color: (p) => p.raw.green900),
      _NamedColor(label: 'green800', color: (p) => p.raw.green800),
      _NamedColor(label: 'green700', color: (p) => p.raw.green700),
      _NamedColor(label: 'green600', color: (p) => p.raw.green600),
      _NamedColor(label: 'green500', color: (p) => p.raw.green500),
      _NamedColor(label: 'green400', color: (p) => p.raw.green400),
      _NamedColor(label: 'green300', color: (p) => p.raw.green300),
      _NamedColor(label: 'green200', color: (p) => p.raw.green200),
      _NamedColor(label: 'green100', color: (p) => p.raw.green100),
      _NamedColor(label: 'green50', color: (p) => p.raw.green50),
      _NamedColor(label: 'darkGreen', color: (p) => p.raw.darkGreen),
      _NamedColor(label: 'lemon', color: (p) => p.raw.lemon),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Yellow',
    description: 'Raw vibrant yellow scale (context.palette.raw.yellow*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'yellow950', color: (p) => p.raw.yellow950),
      _NamedColor(label: 'yellow900', color: (p) => p.raw.yellow900),
      _NamedColor(label: 'yellow800', color: (p) => p.raw.yellow800),
      _NamedColor(label: 'yellow700', color: (p) => p.raw.yellow700),
      _NamedColor(label: 'yellow600', color: (p) => p.raw.yellow600),
      _NamedColor(label: 'yellow500', color: (p) => p.raw.yellow500),
      _NamedColor(label: 'yellow400', color: (p) => p.raw.yellow400),
      _NamedColor(label: 'yellow300', color: (p) => p.raw.yellow300),
      _NamedColor(label: 'yellow200', color: (p) => p.raw.yellow200),
      _NamedColor(label: 'yellow100', color: (p) => p.raw.yellow100),
      _NamedColor(label: 'yellow50', color: (p) => p.raw.yellow50),
      _NamedColor(label: 'yellow25', color: (p) => p.raw.yellow25),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Purple',
    description: 'Raw vibrant purple scale (context.palette.raw.purple*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'purple950', color: (p) => p.raw.purple950),
      _NamedColor(label: 'purple900', color: (p) => p.raw.purple900),
      _NamedColor(label: 'purple800', color: (p) => p.raw.purple800),
      _NamedColor(label: 'purple700', color: (p) => p.raw.purple700),
      _NamedColor(label: 'purple600', color: (p) => p.raw.purple600),
      _NamedColor(label: 'purple500', color: (p) => p.raw.purple500),
      _NamedColor(label: 'purple400', color: (p) => p.raw.purple400),
      _NamedColor(label: 'purple300', color: (p) => p.raw.purple300),
      _NamedColor(label: 'purple200', color: (p) => p.raw.purple200),
      _NamedColor(label: 'purple100', color: (p) => p.raw.purple100),
      _NamedColor(label: 'purple50', color: (p) => p.raw.purple50),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Pink',
    description: 'Raw vibrant pink scale (context.palette.raw.pink*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'pink950', color: (p) => p.raw.pink950),
      _NamedColor(label: 'pink900', color: (p) => p.raw.pink900),
      _NamedColor(label: 'pink800', color: (p) => p.raw.pink800),
      _NamedColor(label: 'pink700', color: (p) => p.raw.pink700),
      _NamedColor(label: 'pink600', color: (p) => p.raw.pink600),
      _NamedColor(label: 'pink500', color: (p) => p.raw.pink500),
      _NamedColor(label: 'pink400', color: (p) => p.raw.pink400),
      _NamedColor(label: 'pink300', color: (p) => p.raw.pink300),
      _NamedColor(label: 'pink200', color: (p) => p.raw.pink200),
      _NamedColor(label: 'pink100', color: (p) => p.raw.pink100),
      _NamedColor(label: 'pink50', color: (p) => p.raw.pink50),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Teal',
    description: 'Raw vibrant teal scale (context.palette.raw.teal*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'teal950', color: (p) => p.raw.teal950),
      _NamedColor(label: 'teal900', color: (p) => p.raw.teal900),
      _NamedColor(label: 'teal800', color: (p) => p.raw.teal800),
      _NamedColor(label: 'teal700', color: (p) => p.raw.teal700),
      _NamedColor(label: 'teal600', color: (p) => p.raw.teal600),
      _NamedColor(label: 'teal500', color: (p) => p.raw.teal500),
      _NamedColor(label: 'teal400', color: (p) => p.raw.teal400),
      _NamedColor(label: 'teal300', color: (p) => p.raw.teal300),
      _NamedColor(label: 'teal200', color: (p) => p.raw.teal200),
      _NamedColor(label: 'teal100', color: (p) => p.raw.teal100),
      _NamedColor(label: 'teal50', color: (p) => p.raw.teal50),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Teal Blue',
    description: 'Raw vibrant teal-blue scale (context.palette.raw.tealBlue*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'tealBlue800', color: (p) => p.raw.tealBlue800),
      _NamedColor(label: 'tealBlue700', color: (p) => p.raw.tealBlue700),
      _NamedColor(label: 'tealBlue600', color: (p) => p.raw.tealBlue600),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Sky',
    description: 'Raw vibrant sky scale (context.palette.raw.sky*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'sky950', color: (p) => p.raw.sky950),
      _NamedColor(label: 'sky900', color: (p) => p.raw.sky900),
      _NamedColor(label: 'sky800', color: (p) => p.raw.sky800),
      _NamedColor(label: 'sky700', color: (p) => p.raw.sky700),
      _NamedColor(label: 'sky600', color: (p) => p.raw.sky600),
      _NamedColor(label: 'sky500', color: (p) => p.raw.sky500),
      _NamedColor(label: 'sky400', color: (p) => p.raw.sky400),
      _NamedColor(label: 'sky300', color: (p) => p.raw.sky300),
      _NamedColor(label: 'sky200', color: (p) => p.raw.sky200),
      _NamedColor(label: 'sky100', color: (p) => p.raw.sky100),
      _NamedColor(label: 'sky50', color: (p) => p.raw.sky50),
      _NamedColor(label: 'skyAlpha5', color: (p) => p.raw.skyAlpha5),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Maroon',
    description: 'Raw vibrant maroon scale (context.palette.raw.maroon*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'maroon800', color: (p) => p.raw.maroon800),
      _NamedColor(label: 'maroon700', color: (p) => p.raw.maroon700),
      _NamedColor(label: 'maroon600', color: (p) => p.raw.maroon600),
    ],
  ),
  _PaletteCategory(
    name: 'Raw: Alpha Colors',
    description: 'Raw alpha transparency tokens (context.palette.raw.*Alpha*)',
    id: 'raw',
    colors: [
      _NamedColor(label: 'blueAlpha24', color: (p) => p.raw.blueAlpha24),
      _NamedColor(label: 'blueAlpha16', color: (p) => p.raw.blueAlpha16),
      _NamedColor(label: 'blueAlpha15', color: (p) => p.raw.blueAlpha15),
      _NamedColor(label: 'blueAlpha10', color: (p) => p.raw.blueAlpha10),
      _NamedColor(label: 'blueAlpha8', color: (p) => p.raw.blueAlpha8),
      _NamedColor(label: 'blueAlpha3', color: (p) => p.raw.blueAlpha3),
      _NamedColor(label: 'navyAlpha24', color: (p) => p.raw.navyAlpha24),
      _NamedColor(label: 'navyAlpha16', color: (p) => p.raw.navyAlpha16),
      _NamedColor(label: 'navyAlpha15', color: (p) => p.raw.navyAlpha15),
      _NamedColor(label: 'navyAlpha10', color: (p) => p.raw.navyAlpha10),
      _NamedColor(label: 'navyAlpha8', color: (p) => p.raw.navyAlpha8),
      _NamedColor(label: 'navyAlpha3', color: (p) => p.raw.navyAlpha3),
      _NamedColor(label: 'orangeAlpha24', color: (p) => p.raw.orangeAlpha24),
      _NamedColor(label: 'orangeAlpha16', color: (p) => p.raw.orangeAlpha16),
      _NamedColor(label: 'orangeAlpha15', color: (p) => p.raw.orangeAlpha15),
      _NamedColor(label: 'orangeAlpha10', color: (p) => p.raw.orangeAlpha10),
      _NamedColor(label: 'orangeAlpha8', color: (p) => p.raw.orangeAlpha8),
      _NamedColor(label: 'orangeAlpha3', color: (p) => p.raw.orangeAlpha3),
      _NamedColor(label: 'redAlpha24', color: (p) => p.raw.redAlpha24),
      _NamedColor(label: 'redAlpha16', color: (p) => p.raw.redAlpha16),
      _NamedColor(label: 'redAlpha15', color: (p) => p.raw.redAlpha15),
      _NamedColor(label: 'redAlpha10', color: (p) => p.raw.redAlpha10),
      _NamedColor(label: 'redAlpha8', color: (p) => p.raw.redAlpha8),
      _NamedColor(label: 'redAlpha3', color: (p) => p.raw.redAlpha3),
      _NamedColor(label: 'greenAlpha24', color: (p) => p.raw.greenAlpha24),
      _NamedColor(label: 'greenAlpha16', color: (p) => p.raw.greenAlpha16),
      _NamedColor(label: 'greenAlpha15', color: (p) => p.raw.greenAlpha15),
      _NamedColor(label: 'greenAlpha10', color: (p) => p.raw.greenAlpha10),
      _NamedColor(label: 'greenAlpha8', color: (p) => p.raw.greenAlpha8),
      _NamedColor(label: 'greenAlpha3', color: (p) => p.raw.greenAlpha3),
      _NamedColor(label: 'yellowAlpha24', color: (p) => p.raw.yellowAlpha24),
      _NamedColor(label: 'yellowAlpha16', color: (p) => p.raw.yellowAlpha16),
      _NamedColor(label: 'yellowAlpha15', color: (p) => p.raw.yellowAlpha15),
      _NamedColor(label: 'yellowAlpha10', color: (p) => p.raw.yellowAlpha10),
      _NamedColor(label: 'yellowAlpha8', color: (p) => p.raw.yellowAlpha8),
      _NamedColor(label: 'yellowAlpha3', color: (p) => p.raw.yellowAlpha3),
      _NamedColor(label: 'skyAlpha24', color: (p) => p.raw.skyAlpha24),
      _NamedColor(label: 'skyAlpha16', color: (p) => p.raw.skyAlpha16),
      _NamedColor(label: 'skyAlpha15', color: (p) => p.raw.skyAlpha15),
      _NamedColor(label: 'skyAlpha10', color: (p) => p.raw.skyAlpha10),
      _NamedColor(label: 'skyAlpha8', color: (p) => p.raw.skyAlpha8),
      _NamedColor(label: 'skyAlpha3', color: (p) => p.raw.skyAlpha3),
      _NamedColor(label: 'purpleAlpha24', color: (p) => p.raw.purpleAlpha24),
      _NamedColor(label: 'purpleAlpha16', color: (p) => p.raw.purpleAlpha16),
      _NamedColor(label: 'purpleAlpha15', color: (p) => p.raw.purpleAlpha15),
      _NamedColor(label: 'purpleAlpha10', color: (p) => p.raw.purpleAlpha10),
      _NamedColor(label: 'purpleAlpha8', color: (p) => p.raw.purpleAlpha8),
      _NamedColor(label: 'purpleAlpha3', color: (p) => p.raw.purpleAlpha3),
      _NamedColor(label: 'pinkAlpha24', color: (p) => p.raw.pinkAlpha24),
      _NamedColor(label: 'pinkAlpha16', color: (p) => p.raw.pinkAlpha16),
      _NamedColor(label: 'pinkAlpha15', color: (p) => p.raw.pinkAlpha15),
      _NamedColor(label: 'pinkAlpha10', color: (p) => p.raw.pinkAlpha10),
      _NamedColor(label: 'pinkAlpha8', color: (p) => p.raw.pinkAlpha8),
      _NamedColor(label: 'pinkAlpha3', color: (p) => p.raw.pinkAlpha3),
      _NamedColor(label: 'tealAlpha24', color: (p) => p.raw.tealAlpha24),
      _NamedColor(label: 'tealAlpha16', color: (p) => p.raw.tealAlpha16),
      _NamedColor(label: 'tealAlpha15', color: (p) => p.raw.tealAlpha15),
      _NamedColor(label: 'tealAlpha10', color: (p) => p.raw.tealAlpha10),
      _NamedColor(label: 'tealAlpha8', color: (p) => p.raw.tealAlpha8),
      _NamedColor(label: 'tealAlpha3', color: (p) => p.raw.tealAlpha3),
      _NamedColor(
        label: 'tealBlueAlpha24',
        color: (p) => p.raw.tealBlueAlpha24,
      ),
      _NamedColor(
        label: 'tealBlueAlpha16',
        color: (p) => p.raw.tealBlueAlpha16,
      ),
      _NamedColor(
        label: 'tealBlueAlpha15',
        color: (p) => p.raw.tealBlueAlpha15,
      ),
      _NamedColor(
        label: 'tealBlueAlpha10',
        color: (p) => p.raw.tealBlueAlpha10,
      ),
      _NamedColor(label: 'tealBlueAlpha8', color: (p) => p.raw.tealBlueAlpha8),
      _NamedColor(label: 'tealBlueAlpha3', color: (p) => p.raw.tealBlueAlpha3),
      _NamedColor(label: 'whiteAlpha24', color: (p) => p.raw.whiteAlpha24),
      _NamedColor(label: 'whiteAlpha16', color: (p) => p.raw.whiteAlpha16),
      _NamedColor(label: 'whiteAlpha15', color: (p) => p.raw.whiteAlpha15),
      _NamedColor(label: 'whiteAlpha10', color: (p) => p.raw.whiteAlpha10),
      _NamedColor(label: 'whiteAlpha8', color: (p) => p.raw.whiteAlpha8),
      _NamedColor(label: 'whiteAlpha3', color: (p) => p.raw.whiteAlpha3),
      _NamedColor(label: 'neutralAlpha24', color: (p) => p.raw.neutralAlpha24),
      _NamedColor(label: 'neutralAlpha16', color: (p) => p.raw.neutralAlpha16),
      _NamedColor(label: 'neutralAlpha15', color: (p) => p.raw.neutralAlpha15),
      _NamedColor(label: 'neutralAlpha10', color: (p) => p.raw.neutralAlpha10),
      _NamedColor(label: 'neutralAlpha8', color: (p) => p.raw.neutralAlpha8),
      _NamedColor(label: 'neutralAlpha3', color: (p) => p.raw.neutralAlpha3),
      _NamedColor(label: 'blackAlpha24', color: (p) => p.raw.blackAlpha24),
      _NamedColor(label: 'blackAlpha16', color: (p) => p.raw.blackAlpha16),
      _NamedColor(label: 'blackAlpha15', color: (p) => p.raw.blackAlpha15),
      _NamedColor(label: 'blackAlpha10', color: (p) => p.raw.blackAlpha10),
      _NamedColor(label: 'blackAlpha8', color: (p) => p.raw.blackAlpha8),
      _NamedColor(label: 'blackAlpha3', color: (p) => p.raw.blackAlpha3),
      _NamedColor(label: 'maroonAlpha24', color: (p) => p.raw.maroonAlpha24),
      _NamedColor(label: 'maroonAlpha16', color: (p) => p.raw.maroonAlpha16),
      _NamedColor(label: 'maroonAlpha15', color: (p) => p.raw.maroonAlpha15),
      _NamedColor(label: 'maroonAlpha10', color: (p) => p.raw.maroonAlpha10),
      _NamedColor(label: 'maroonAlpha8', color: (p) => p.raw.maroonAlpha8),
      _NamedColor(label: 'maroonAlpha3', color: (p) => p.raw.maroonAlpha3),
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
  final _searchCtrl = GtInputController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
        context.copyText(hex);
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
