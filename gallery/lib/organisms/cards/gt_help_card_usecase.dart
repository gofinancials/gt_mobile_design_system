import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtHelpCard', type: GtHelpCard)
Widget playgroundGtHelpCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Need more help?');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Chat with us');
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtHelpCard',
    description: 'A help support card providing interactive customer care linkages.',
    code: '''
GtHelpCard(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
)''',
    child: GtHelpCard(
      title: title,
      subtitle: subtitle,
      variant: variant,
    ),
  );
}
