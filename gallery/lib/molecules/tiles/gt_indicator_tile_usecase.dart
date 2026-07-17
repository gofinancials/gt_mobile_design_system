import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtIndicatorTile', type: GtIndicatorTile)
Widget playgroundGtIndicatorTileUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Indicator Tile');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Standard layout subtext for indicator items.');
  final hasIcon = context.knobs.boolean(label: 'Has Icon', initialValue: true);
  final leading = hasIcon ? const GtIcon(GtIcons.star) : null;

  return GtWidgetDocPage(
    title: 'GtIndicatorTile',
    description: 'A layout helper tile for structuring title, subtitle, leading and trailing widgets consistently.',
    code: '''
GtIndicatorTile(
  "Indicator Tile",
  subtitle: "Standard layout subtext for indicator items.",
  ${hasIcon ? 'icon: GtIcon(GtIcons.star),' : ''}
)''',
    child: Center(
      child: Padding(
        padding: context.insets.allDp(16.px),
        child: GtCard(
          padding: context.insets.allDp(16.px),
          variant: GtCardVariant.normal,
          child: GtIndicatorTile(
            title,
            subtitle: subtitle.isEmpty ? null : subtitle,
            icon: leading,
          ),
        ),
      ),
    ),
  );
}
