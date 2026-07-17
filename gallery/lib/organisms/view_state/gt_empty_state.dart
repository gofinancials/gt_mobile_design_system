import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/data/models/media_data.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtEmptyState', type: GtEmptyState)
Widget playgroundGtEmptyStateUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: "You're all caught up");
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'No new notifications at the moment.');
  final illustration = context.knobs.object.dropdown<String>(
    label: 'Illustration',
    options: [GtVectorIllustrations.empty, GtVectorIllustrations.search, GtVectorIllustrations.notFound],
    initialOption: GtVectorIllustrations.empty,
  );
  final hasAction = context.knobs.boolean(label: 'Has Action Button', initialValue: true);
  final actionText = context.knobs.string(label: 'Action Text', initialValue: 'Add Beneficiary');
  final buttonVariant = context.knobs.object.dropdown<GtButtonVariant>(
    label: 'Button Variant',
    options: GtButtonVariant.values,
    initialOption: GtButtonVariant.primary,
    labelBuilder: (v) => v.name,
  );

  return GtWidgetDocPage(
    title: 'GtEmptyState',
    description: 'A component used to inform users when a screen has no data or actions, featuring SVG illustration.',
    code: '''
GtEmptyState(
  icon: AppImageData("$illustration"),
  title: "$title",
  subtitle: "$subtitle",
  ${hasAction ? 'actionText: "$actionText",' : ''}
  ${hasAction ? 'buttonVariant: GtButtonVariant.${buttonVariant.name},' : ''}
  ${hasAction ? 'onActionPressed: () {},' : ''}
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(16.px),
        variant: GtCardVariant.normal,
        child: GtEmptyState(
          icon: AppImageData(illustration),
          title: title,
          subtitle: subtitle,
          actionText: hasAction ? actionText : null,
          onActionPressed: hasAction ? () {} : null,
          buttonVariant: buttonVariant,
        ),
      ),
    ),
  );
}
