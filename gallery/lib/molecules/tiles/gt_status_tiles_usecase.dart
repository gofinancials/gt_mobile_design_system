import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtStatusTiles', type: GtStatusListTile)
Widget gtStatusTilesUseCase(BuildContext context) {
  return GtWidgetDocPage(
    title: "Status Tiles",
    description:
        "List tiles tailored for displaying step completions and statuses.",
    code: '''
GtStatusListTile(
  title: 'Identity Verification',
  description: 'Verify your ID to proceed.',
  icon: Icons.person,
  onPressed: () {},
)
''',
    child: Column(
      children: [
        GalleryPageSectionHeader(title: "GtStatusListTile"),
        GtStatusListTile(
          title: context.knobs.string(
            label: 'Title',
            initialValue: 'Identity Verification',
          ),
          subtitle: context.knobs.string(
            label: 'Subtitle',
            initialValue: 'Verify your ID to proceed.',
          ),
          icon: Icons.person,
          isDone: context.knobs.boolean(label: 'Is Done', initialValue: false),
          onPressed: () {},
        ),
        const GtGap.yLg(),

        GalleryPageSectionHeader(title: "GtIllustratedStepTile"),
        GtIllustratedStepTile(
          title: context.knobs.string(
            label: 'Step Title',
            initialValue: 'Profile Setup',
          ),
          subtitle: context.knobs.string(
            label: 'Step Subtitle',
            initialValue: 'Complete your profile setup',
          ),
          illustrationPath: GtVectorIllustrations.security,
          isDone: context.knobs.boolean(label: 'Is Done', initialValue: false),
        ),
      ],
    ),
  );
}
