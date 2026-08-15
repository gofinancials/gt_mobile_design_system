import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTipCard', type: GtTipCard)
Widget playgroundGtTipCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Confirm Referee Details',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue:
        'Please ensure your referees’ details are accurate. They will be contacted to complete a form.',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.away,
    labelBuilder: (v) => v.name,
  );
  final hidden = context.knobs.boolean(label: 'Hidden', initialValue: false);

  return GtWidgetDocPage(
    title: 'GtTipCard',
    description:
        'A informational card tailored for displaying helpful tips or contextual alerts.',
    code:
        '''
GtTipCard(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
  hidden: $hidden,
  onClose: () {},
)''',
    child: GtTipCard(
      title: title,
      subtitle: subtitle,
      variant: variant,
      hidden: hidden,
      onClose: () {},
    ),
  );
}
