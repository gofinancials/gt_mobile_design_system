import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTipCard', type: GtTipCard)
Widget playgroundGtTipCardUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: 'GtTipCard',
    description: 'Documentation for GtTipCard',
    code: '''
GtTipCard(
  title: "Pro Tip",
  subtitle: "You can save your frequent transactions as favorites.",
  onClose: () {},
)
''',
    child: GtTipCard(
      title: "Pro Tip",
      subtitle: "You can save your frequent transactions as favorites.",
      onClose: () {},
    ),
  );
}
