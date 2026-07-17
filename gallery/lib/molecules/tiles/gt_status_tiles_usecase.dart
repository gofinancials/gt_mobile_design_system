import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtStatusListTile', type: GtStatusListTile)
Widget playgroundGtStatusListTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Identity Verification',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Verify your ID to proceed.',
  );
  final isDone = context.knobs.boolean(label: 'Is Done', initialValue: false);

  return GtWidgetDocPage(
    title: "GtStatusListTile",
    description:
        "List tiles tailored for displaying step completions and statuses.",
    code:
        '''
GtStatusListTile(
  title: '$title',
  subtitle: '$subtitle',
  icon: Icons.person,
  isDone: $isDone,
  onPressed: () {},
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtStatusListTile(
          title: title,
          subtitle: subtitle,
          icon: GtIcons.verifiedUsers,
          isDone: isDone,
          onPressed: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'GtIllustratedStepTile', type: GtIllustratedStepTile)
Widget playgroundGtIllustratedStepTileUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Step Title',
    initialValue: 'Profile Setup',
  );
  final subtitle = context.knobs.string(
    label: 'Step Subtitle',
    initialValue: 'Complete your profile setup',
  );
  final isDone = context.knobs.boolean(label: 'Is Done', initialValue: false);

  return GtWidgetDocPage(
    title: "GtIllustratedStepTile",
    description:
        "A card tile featuring custom illustrations representing workflow steps.",
    code:
        '''
GtIllustratedStepTile(
  title: '$title',
  subtitle: '$subtitle',
  illustrationPath: GtVectorIllustrations.security,
  isDone: $isDone,
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(12.px),
        variant: GtCardVariant.normal,
        child: GtIllustratedStepTile(
          title: title,
          subtitle: subtitle,
          illustrationPath: GtVectorIllustrations.security,
          isDone: isDone,
        ),
      ),
    ),
  );
}
