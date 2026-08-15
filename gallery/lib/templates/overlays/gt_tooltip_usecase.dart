import 'package:flutter/material.dart';
import 'package:gallery/lib.dart';
import 'package:gt_mobile_ui/gt_mobile_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'GtTooltipWidget', type: GtTooltipWidget)
Widget playgroundGtTooltipUseCase(BuildContext context) {
  final title = context.knobs.string(
    label: 'Tooltip Title',
    initialValue: 'View and add accounts',
  );
  final message = context.knobs.string(
    label: 'Tooltip Message',
    initialValue: 'You can view your other accounts and open a new one.',
  );

  return GtWidgetDocPage(
    title: 'GtTooltipWidget',
    description:
        'A floating tooltip bubble that anchors to a target widget and provides contextual help.',
    code:
        '''
GtTooltipWrapper(
  tooltipTitle: "$title",
  tooltipMessage: "$message",
  child: GtText("TAP ME"),
)''',
    child: Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: context.spacing.sectionMd,
          children: [
            GtTooltipWrapper(
              key: const ValueKey("Click me to see tooltip 1"),
              tooltipTitle: title,
              tooltipMessage: message,
              child: GtText(
                "Click me to see tooltip 1".toUpperCase(),
                style: context.textStyles.h6(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    ),
  );
}
