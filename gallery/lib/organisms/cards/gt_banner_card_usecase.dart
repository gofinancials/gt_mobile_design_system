import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtBannerCard', type: GtBannerCard)
Widget playgroundGtBannerCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtBannerCard',
    description: 'Documentation for GtBannerCard',
    code: '''
GtBannerCard(
  title: "Banner Title",
  subtitle: "This is a banner message.",
  onClose: () {},
)
''',
    child: GtBannerCard(
      title: "Banner Title",
      subtitle: "This is a banner message.",
      onClose: () {},
    ),
  );
}
