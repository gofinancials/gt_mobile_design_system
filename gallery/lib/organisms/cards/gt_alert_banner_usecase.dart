import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtAlertBanner', type: GtAlertBanner)
Widget playgroundGtAlertBannerUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Nearly there',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue:
        'Your fixed savings plan matures in 7 days with ₦45,000 earned.',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.warning,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtAlertBanner',
    description:
        'A full-width banner alert with a dismiss/close button and variant styling.',
    code:
        '''
GtAlertBanner(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
  icon: GtSvg(GtVectorIllustrations.fuel),
  onClose: () {},
)''',
    child: GtAlertBanner(
      title: title,
      subtitle: subtitle,
      variant: variant,
      icon: GtSvg(GtVectorIllustrations.fuel),
      onClose: () {},
    ),
  );
}
