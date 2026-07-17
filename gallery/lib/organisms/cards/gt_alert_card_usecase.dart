import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAlertCard', type: GtAlertCard)
Widget playgroundGtAlertCardUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Issue with address');
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'Address not verified');
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtAlertCard',
    description: 'An alert card designed to call attention to important state notices or failures.',
    code: '''
GtAlertCard(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
  icon: GtIcons.houseAlt,
)''',
    child: GtAlertCard(
      title: title,
      subtitle: subtitle,
      variant: variant,
      icon: GtIcons.houseAlt,
    ),
  );
}
