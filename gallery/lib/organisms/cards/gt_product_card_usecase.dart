import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProductCard', type: GtProductCard)
Widget playgroundGtProductCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtProductCard',
    description: 'Documentation for GtProductCard',
    code: '''
GtProductCard(
  name: "Savings Account",
  description: "Earn up to 5% interest",
  icon: GtIcons.wallet,
  onTap: () {},
)
''',
    child: GtProductCard(
      name: "Savings Account",
      description: "Earn up to 5% interest",
      icon: GtIcons.wallet,
      onTap: () {},
    ),
  );
}
