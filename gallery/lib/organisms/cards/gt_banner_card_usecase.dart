import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBannerCard', type: GtBannerCard)
Widget playgroundGtBannerCardUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Make it easy to get paid. Invite your friends to send you money.',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Request money either by a link or a QR Code',
  );
  final variant = context.knobs.object.dropdown<GtCardVariant>(
    label: 'Variant',
    options: GtCardVariant.values,
    initialOption: GtCardVariant.warning,
    labelBuilder: (v) => v.name,
  );
  final hidden = context.knobs.boolean(label: 'Hidden', initialValue: false);

  return GtWidgetDocPage(
    title: 'GtBannerCard',
    description: 'A customizable promotional or informational banner card with variant styles and dismiss action.',
    code: '''
GtBannerCard(
  title: "$title",
  subtitle: "$subtitle",
  variant: GtCardVariant.${variant.name},
  hidden: $hidden,
  onClose: () {},
)''',
    child: GtBannerCard(
      title: title,
      subtitle: subtitle,
      variant: variant,
      hidden: hidden,
      onClose: () {},
    ),
  );
}
