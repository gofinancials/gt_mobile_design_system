import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtProgressCards', type: GtProgressCard)
Widget gtProgressCardsUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Progress Cards",
    description: "Cards used to display progress towards a goal.",
    code: '''
GtProgressCard(
  title: 'Savings Goal',
  description: 'Buy a new car',
  maxValue: 5000000,
  currentValue: 2000000,
  continueText: 'Top Up',
  onContinue: () {},
  percentSubtext: '40% completed',
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtProgressCard"),
        GtProgressCard(
          title: context.knobs.string(label: 'Title', initialValue: 'Savings Goal'),
          subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'Buy a new car'),
          maxValue: 5000000.0,
          currentValue: 2000000.0,
          continueText: context.knobs.string(label: 'Button Text', initialValue: 'Top Up'),
          onContinue: () {},
          percentSubtext: context.knobs.string(label: 'Percent Subtext', initialValue: '40% completed'),
        ),
      ],
    ),
  );
}
