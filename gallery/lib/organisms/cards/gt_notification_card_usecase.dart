import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtNotificationCard', type: GtNotificationCard)
Widget playgroundGtNotificationCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Unauthorized access',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: "You don't have the permission to do this",
  );
  final variant = context.knobs.object.dropdown<GtNotificationVariant>(
    label: 'Variant',
    options: GtNotificationVariant.values,
    initialOption: GtNotificationVariant.error,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtNotificationCard',
    description:
        'A critical message notification card that displays alert state colors.',
    code:
        '''
GtNotificationCard(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtNotificationVariant.${variant.name},
  onClose: () {},
)''',
    child: GtNotificationCard(
      title: title,
      subtitle: subtitle,
      variant: variant,
      onClose: () {},
    ),
  );
}
