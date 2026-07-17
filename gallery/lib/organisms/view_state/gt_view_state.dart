import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_foundation/foundation.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtViewStateWidget', type: GtViewStateWidget)
Widget playgroundGtViewStateWidgetUseCase(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'No Internet Connection');
  final description = context.knobs.string(label: 'Description', initialValue: 'Please check your connection and try again.');
  final actionText = context.knobs.string(label: 'Action Text', initialValue: 'Retry');
  final hasAction = context.knobs.boolean(label: 'Has Action', initialValue: true);

  return GtWidgetDocPage(
    title: 'GtViewStateWidget',
    description: 'A customizable generic view state component offering flexible layout spacers and alignments.',
    code: '''
GtViewStateWidget(
  title: "$title",
  description: "$description",
  icon: AppImageData(GtVectorIllustrations.disconnected),
  ${hasAction ? 'actionText: "$actionText",' : ''}
  ${hasAction ? 'onActionPressed: () {},' : ''}
)''',
    child: Center(
      child: GtCard(
        padding: context.insets.allDp(24.px),
        variant: GtCardVariant.normal,
        child: GtViewStateWidget(
          title: title,
          description: description.isEmpty ? null : description,
          icon: AppImageData(GtVectorIllustrations.disconnected),
          actionText: hasAction && actionText.isNotEmpty ? actionText : null,
          onActionPressed: hasAction ? () {} : null,
        ),
      ),
    ),
  );
}
